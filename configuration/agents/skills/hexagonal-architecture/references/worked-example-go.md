# Worked example in Go

Records a patient vitals reading.

```
internal/vitals/
  reading.go                          # entity and domain errors
  record_reading.go                   # use case and its ports
  record_reading_test.go              # use case test, no database
  record_reading_integration_test.go  # see integration-test-go.md
  httpin/handler.go                   # inbound adapter
  timescale/appender.go               # outbound adapter
cmd/api/main.go                       # composition root
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

var ErrOutOfRange = errors.New("vitals: reading outside physiological range")

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

`internal/vitals/record_reading.go`

```go
package vitals

import (
	"context"
	"errors"
	"time"
)

// Adapters translate all store failures into these use-case-owned errors.
var (
	ErrDuplicate    = errors.New("vitals: reading already recorded")
	ErrUnavailable  = errors.New("vitals: store unavailable")
	ErrStoreFailure = errors.New("vitals: store operation failed")
)

// Outbound port. The caller declares it, names the capability, and lists one
// method because it uses one method.
type ReadingAppender interface {
	Append(ctx context.Context, r Reading) error
}

// Time is an outbound capability. So is logging. Derive durations from it
// too: deadline.Sub(clock.Now()), not time.Until(deadline), and
// clock.Now().Sub(start), not time.Since(start). Both read the real clock.
type Clock interface {
	Now() time.Time
}

// Inbound port. The adapter depends on this, not on the struct below.
// NewRecordReading returns the interface on purpose, against the usual Go
// habit of returning concrete types: the port is the only way in.
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
	reading, err := NewReading(
		PatientID(cmd.PatientID),
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

`internal/vitals/httpin/handler.go`

```go
package httpin

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"time"

	"example.com/clinic/internal/vitals"
)

// The adapter owns the wire format. The use case never receives this type.
type recordRequest struct {
	PatientID string `json:"patient_id"`
	Systolic  int    `json:"systolic"`
	Diastolic int    `json:"diastolic"`
}

type recordResponse struct {
	RecordedAt time.Time `json:"recorded_at"`
}

// Depends on the inbound port, so a stub use case can test it.
func RecordHandler(useCase vitals.RecordReading) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var body recordRequest
		if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
			http.Error(w, "malformed body", http.StatusBadRequest)
			return
		}

		result, err := useCase.Record(r.Context(), vitals.RecordCommand{
			PatientID: body.PatientID,
			Systolic:  body.Systolic,
			Diastolic: body.Diastolic,
		})

		// Domain and use-case errors become status codes only here.
		switch {
		case errors.Is(err, vitals.ErrOutOfRange):
			http.Error(w, err.Error(), http.StatusUnprocessableEntity)
		case errors.Is(err, vitals.ErrDuplicate):
			http.Error(w, err.Error(), http.StatusConflict)
		case errors.Is(err, vitals.ErrUnavailable):
			http.Error(w, err.Error(), http.StatusServiceUnavailable)
		case errors.Is(err, context.Canceled):
			// The client went away. Nobody reads a response.
		case errors.Is(err, context.DeadlineExceeded):
			http.Error(w, "timed out", http.StatusServiceUnavailable)
		case err != nil:
			http.Error(w, "internal error", http.StatusInternalServerError)
		default:
			w.WriteHeader(http.StatusCreated)
			_ = json.NewEncoder(w).Encode(recordResponse{RecordedAt: result.RecordedAt})
		}
	}
}
```

## Outbound adapter

`internal/vitals/timescale/appender.go`

```go
package timescale

import (
	"context"
	"database/sql"
	"database/sql/driver"
	"errors"
	"log/slog"
	"net"
	"strings"

	"github.com/jackc/pgx/v5/pgconn"
	_ "github.com/jackc/pgx/v5/stdlib" // registers "pgx", so errors are *pgconn.PgError

	"example.com/clinic/internal/vitals"
)

// The driver, pool, retries, backoff, and breaker belong in this package.
// Adapters sit at the edge, so they may log directly.
type Appender struct {
	db  *sql.DB
	log *slog.Logger
}

// Open takes configuration, not a connection. The composition root reads the
// DSN; the adapter decides how to connect.
func Open(dsn string, log *slog.Logger) (*Appender, error) {
	db, err := sql.Open("pgx", dsn)
	if err != nil {
		return nil, err
	}
	return &Appender{db: db, log: log}, nil
}

func (a *Appender) Close() error {
	return a.db.Close()
}

func (a *Appender) Append(ctx context.Context, r vitals.Reading) error {
	const query = `INSERT INTO vitals (patient_id, taken_at, systolic, diastolic) VALUES ($1,$2,$3,$4)`

	_, err := a.db.ExecContext(ctx, query, string(r.PatientID), r.TakenAt, r.Systolic, r.Diastolic)
	if err == nil {
		return nil
	}

	// The caller cancelled or ran out of time. That is not a store failure.
	// Return the context error so the inbound adapter can tell them apart.
	if ctxErr := ctx.Err(); ctxErr != nil {
		return ctxErr
	}

	// A *pgconn.PgError must not reach the use case.
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) && pgErr.Code == "23505" { // unique violation
		return vitals.ErrDuplicate
	}

	// The driver error stays in diagnostics. Do not log patient data.
	a.log.ErrorContext(ctx, "append vitals reading", "err", err)

	if unavailable(err) {
		return vitals.ErrUnavailable
	}

	// Unexpected failures must not expose infrastructure errors either.
	return vitals.ErrStoreFailure
}

// Most outages never reach the server, so they arrive as dial or network
// errors, not as a *pgconn.PgError with a connection-exception code.
func unavailable(err error) bool {
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) {
		return strings.HasPrefix(pgErr.Code, "08") // connection exception
	}
	var connectErr *pgconn.ConnectError
	var netErr net.Error
	return errors.As(err, &connectErr) || errors.As(err, &netErr) || errors.Is(err, driver.ErrBadConn)
}
```

## Composition root

`cmd/api/main.go`

```go
package main

import (
	"log"
	"log/slog"
	"net/http"
	"os"
	"time"

	"example.com/clinic/internal/vitals"
	"example.com/clinic/internal/vitals/httpin"
	"example.com/clinic/internal/vitals/timescale"
)

func main() {
	if err := run(); err != nil {
		log.Fatal(err)
	}
}

// run returns instead of exiting, so the deferred Close runs.
func run() error {
	logger := slog.New(slog.NewJSONHandler(os.Stderr, nil))

	// Adapters are constructed and wired once, here.
	appender, err := timescale.Open(os.Getenv("DATABASE_URL"), logger)
	if err != nil {
		return err
	}
	defer appender.Close()

	useCase := vitals.NewRecordReading(appender, systemClock{})

	mux := http.NewServeMux()
	mux.Handle("POST /vitals", httpin.RecordHandler(useCase))

	return http.ListenAndServe(":8080", mux)
}

type systemClock struct{}

func (systemClock) Now() time.Time {
	return time.Now().UTC()
}
```

## Test doubles

`internal/vitals/record_reading_test.go`

The test needs no database, no server, and no clock control beyond a struct
literal. If it needs more, a boundary is in the wrong place.

```go
package vitals_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"example.com/clinic/internal/vitals"
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

// Tests pin the clock far from real time, so a call that bypasses the port
// with time.Now, time.Since, or time.Until produces a visibly wrong result.
type fixedClock struct {
	now time.Time
}

func (c fixedClock) Now() time.Time {
	return c.now
}

func TestRecordStampsReadingWithInjectedClock(t *testing.T) {
	now := time.Unix(0, 0).UTC()
	appender := &fakeAppender{}
	useCase := vitals.NewRecordReading(appender, fixedClock{now: now})

	result, err := useCase.Record(context.Background(), vitals.RecordCommand{
		PatientID: "p-1",
		Systolic:  120,
		Diastolic: 80,
	})

	if err != nil {
		t.Fatalf("want no error, got %v", err)
	}
	if !result.RecordedAt.Equal(now) {
		t.Fatalf("want RecordedAt %v from the injected clock, got %v", now, result.RecordedAt)
	}
	if len(appender.appended) != 1 || !appender.appended[0].TakenAt.Equal(now) {
		t.Fatalf("want one reading taken at %v, got %v", now, appender.appended)
	}
}

func TestRecordRejectsImpossibleReading(t *testing.T) {
	appender := &fakeAppender{}
	useCase := vitals.NewRecordReading(appender, fixedClock{now: time.Unix(0, 0).UTC()})

	_, err := useCase.Record(context.Background(), vitals.RecordCommand{
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

func TestRecordReturnsStoreFailure(t *testing.T) {
	appender := &fakeAppender{err: vitals.ErrUnavailable}
	useCase := vitals.NewRecordReading(appender, fixedClock{now: time.Unix(0, 0).UTC()})

	_, err := useCase.Record(context.Background(), vitals.RecordCommand{
		PatientID: "p-1",
		Systolic:  120,
		Diastolic: 80,
	})

	if !errors.Is(err, vitals.ErrUnavailable) {
		t.Fatalf("want ErrUnavailable, got %v", err)
	}
}
```
