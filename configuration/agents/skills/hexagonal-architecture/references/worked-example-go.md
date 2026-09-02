# Worked example in Go

Records a patient vitals reading.

```
internal/vitals/
  reading.go                      # entity and domain errors
  app/record_reading.go           # use case and its ports
  app/record_reading_test.go      # use case test, no database
  adapter/httpin/handler.go       # inbound adapter
  adapter/timescale/appender.go   # outbound adapter
cmd/api/main.go                   # composition root
```

## Domain

`internal/vitals/reading.go`

```go
package vitals

import (
	"errors"
	"time"
)

type PatientID string

// Adapters translate into these. No other error type leaves this package.
var (
	ErrOutOfRange  = errors.New("vitals: reading outside physiological range")
	ErrDuplicate   = errors.New("vitals: reading already recorded")
	ErrUnavailable = errors.New("vitals: store unavailable")
)

type Reading struct {
	PatientID PatientID
	TakenAt   time.Time
	Systolic  int
	Diastolic int
}

// Construction enforces the invariant. An invalid Reading cannot exist.
func NewReading(id PatientID, takenAt time.Time, systolic, diastolic int) (Reading, error) {
	if id == "" || systolic < 40 || systolic > 300 || diastolic < 20 || diastolic >= systolic {
		return Reading{}, ErrOutOfRange
	}
	return Reading{PatientID: id, TakenAt: takenAt, Systolic: systolic, Diastolic: diastolic}, nil
}
```

## Use case and ports

`internal/vitals/app/record_reading.go`

```go
package app

import (
	"context"
	"time"

	"eno/internal/vitals"
)

// Outbound port. The caller declares it, names the capability, and lists one
// method because it uses one method.
type ReadingAppender interface {
	Append(ctx context.Context, r vitals.Reading) error
}

// Time is an outbound capability. So is logging.
type Clock interface {
	Now() time.Time
}

// Inbound port. The adapter depends on this, not on the struct below.
type RecordReading interface {
	Record(ctx context.Context, cmd RecordCommand) (RecordResult, error)
}

// Boundary types. No JSON tags. No HTTP types.
type RecordCommand struct {
	PatientID string
	Systolic  int
	Diastolic int
}

type RecordResult struct {
	RecordedAt time.Time
}

type recordReading struct {
	appender ReadingAppender
	clock    Clock
}

func NewRecordReading(appender ReadingAppender, clock Clock) RecordReading {
	return recordReading{appender: appender, clock: clock}
}

// Orchestration only. The entity holds the rules.
func (u recordReading) Record(ctx context.Context, cmd RecordCommand) (RecordResult, error) {
	reading, err := vitals.NewReading(
		vitals.PatientID(cmd.PatientID),
		u.clock.Now(),
		cmd.Systolic,
		cmd.Diastolic,
	)
	if err != nil {
		return RecordResult{}, err
	}

	if err := u.appender.Append(ctx, reading); err != nil {
		return RecordResult{}, err
	}

	return RecordResult{RecordedAt: reading.TakenAt}, nil
}
```

## Inbound adapter

`internal/vitals/adapter/httpin/handler.go`

```go
package httpin

import (
	"encoding/json"
	"errors"
	"net/http"

	"eno/internal/vitals"
	"eno/internal/vitals/app"
)

// The adapter owns the wire format. The use case never receives this type.
type recordRequest struct {
	PatientID string `json:"patient_id"`
	Systolic  int    `json:"systolic"`
	Diastolic int    `json:"diastolic"`
}

// Depends on the inbound port, so a stub use case can test it.
func RecordHandler(useCase app.RecordReading) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var body recordRequest
		if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
			http.Error(w, "malformed body", http.StatusBadRequest)
			return
		}

		result, err := useCase.Record(r.Context(), app.RecordCommand{
			PatientID: body.PatientID,
			Systolic:  body.Systolic,
			Diastolic: body.Diastolic,
		})

		// Domain errors become status codes here, and only here.
		switch {
		case errors.Is(err, vitals.ErrOutOfRange):
			http.Error(w, err.Error(), http.StatusUnprocessableEntity)
		case errors.Is(err, vitals.ErrDuplicate):
			http.Error(w, err.Error(), http.StatusConflict)
		case errors.Is(err, vitals.ErrUnavailable):
			http.Error(w, err.Error(), http.StatusServiceUnavailable)
		case err != nil:
			http.Error(w, "internal error", http.StatusInternalServerError)
		default:
			w.WriteHeader(http.StatusCreated)
			_ = json.NewEncoder(w).Encode(map[string]any{"recorded_at": result.RecordedAt})
		}
	}
}
```

## Outbound adapter

`internal/vitals/adapter/timescale/appender.go`

```go
package timescale

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgconn"

	"eno/internal/vitals"
)

// The pool, retries, backoff, and breaker belong in this package.
type Appender struct {
	db *sql.DB
}

func NewAppender(db *sql.DB) *Appender {
	return &Appender{db: db}
}

func (a *Appender) Append(ctx context.Context, r vitals.Reading) error {
	const query = `INSERT INTO vitals (patient_id, taken_at, systolic, diastolic) VALUES ($1,$2,$3,$4)`

	_, err := a.db.ExecContext(ctx, query, string(r.PatientID), r.TakenAt, r.Systolic, r.Diastolic)
	if err == nil {
		return nil
	}

	// A *pgconn.PgError must not reach the use case.
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) {
		switch {
		case pgErr.Code == "23505": // unique violation
			return vitals.ErrDuplicate
		case strings.HasPrefix(pgErr.Code, "08"): // connection exception
			return vitals.ErrUnavailable
		}
	}

	return fmt.Errorf("append reading: %w", err)
}
```

## Composition root

`cmd/api/main.go`

```go
package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"eno/internal/vitals/adapter/httpin"
	"eno/internal/vitals/adapter/timescale"
	"eno/internal/vitals/app"
)

func main() {
	db := mustOpen(os.Getenv("DATABASE_URL"))

	// Adapters are constructed and wired once, here.
	appender := timescale.NewAppender(db)
	useCase := app.NewRecordReading(appender, systemClock{})

	mux := http.NewServeMux()
	mux.Handle("POST /vitals", httpin.RecordHandler(useCase))

	log.Fatal(http.ListenAndServe(":8080", mux))
}

type systemClock struct{}

func (systemClock) Now() time.Time {
	return time.Now().UTC()
}
```

## Test doubles

`internal/vitals/app/record_reading_test.go`

The test needs no database, no server, and no clock control beyond a struct
literal. If it needs more, a boundary is in the wrong place.

```go
package app_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"eno/internal/vitals"
	"eno/internal/vitals/app"
)

type fakeAppender struct {
	appended []vitals.Reading
	err      error
}

func (f *fakeAppender) Append(_ context.Context, r vitals.Reading) error {
	if f.err != nil {
		return f.err
	}
	f.appended = append(f.appended, r)
	return nil
}

type fixedClock struct {
	now time.Time
}

func (c fixedClock) Now() time.Time {
	return c.now
}

func TestRecordRejectsImpossibleReading(t *testing.T) {
	appender := &fakeAppender{}
	useCase := app.NewRecordReading(appender, fixedClock{now: time.Unix(0, 0).UTC()})

	_, err := useCase.Record(context.Background(), app.RecordCommand{
		PatientID: "p-1",
		Systolic:  90,
		Diastolic: 120,
	})

	if !errors.Is(err, vitals.ErrOutOfRange) {
		t.Fatalf("want ErrOutOfRange, got %v", err)
	}
	if len(appender.appended) != 0 {
		t.Fatal("an invalid reading must not reach the store")
	}
}

func TestRecordTranslatesStoreFailure(t *testing.T) {
	appender := &fakeAppender{err: vitals.ErrUnavailable}
	useCase := app.NewRecordReading(appender, fixedClock{now: time.Unix(0, 0).UTC()})

	_, err := useCase.Record(context.Background(), app.RecordCommand{
		PatientID: "p-1",
		Systolic:  120,
		Diastolic: 80,
	})

	if !errors.Is(err, vitals.ErrUnavailable) {
		t.Fatalf("want ErrUnavailable, got %v", err)
	}
}
```
