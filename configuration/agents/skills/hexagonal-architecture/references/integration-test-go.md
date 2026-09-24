# Integration test in Go

Extends `worked-example-go.md`: it tests that example's use case against the
real adapter, and reuses `fixedClock` from its unit test.

`internal/vitals/record_reading_integration_test.go`

The unit test fakes the port, so it cannot prove that the adapter honors it.
This test drives the use case through its inbound port, wired to the real
adapter against TimescaleDB through testcontainers. Only the clock stays fake.
It checks what a caller relies on: the reading lands, a repeated reading
becomes `ErrDuplicate`, an unanticipated failure becomes `ErrStoreFailure`,
neither exposes the driver error, and a cancellation stays the caller's. The
build tag keeps it out of the default run, because it needs Docker:
`go test -tags integration ./...`.

```go
//go:build integration

package vitals_test

import (
	"context"
	"database/sql"
	"errors"
	"log/slog"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgconn"
	"github.com/testcontainers/testcontainers-go"
	"github.com/testcontainers/testcontainers-go/modules/postgres"

	"example.com/clinic/internal/vitals"
	"example.com/clinic/internal/vitals/timescale"
)

// The migrations own this schema. The test applies it to a fresh database.
const schema = `
CREATE TABLE vitals (
	patient_id text        NOT NULL,
	taken_at   timestamptz NOT NULL,
	systolic   int         NOT NULL,
	diastolic  int         NOT NULL,
	PRIMARY KEY (patient_id, taken_at)
);
SELECT create_hypertable('vitals', by_range('taken_at'));`

// Drives the use case through its inbound port, wired to the real adapter as
// the composition root wires it. Only the clock stays fake, so the recorded
// time is exact. One container serves every subtest, and each subtest uses
// its own patient.
func TestRecordReadingWithTimescale(t *testing.T) {
	ctx := context.Background()

	container, err := postgres.Run(ctx, "timescale/timescaledb:2.22.1-pg17", postgres.BasicWaitStrategies())
	testcontainers.CleanupContainer(t, container)
	if err != nil {
		t.Fatal(err)
	}
	dsn, err := container.ConnectionString(ctx, "sslmode=disable")
	if err != nil {
		t.Fatal(err)
	}

	db, err := sql.Open("pgx", dsn)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { db.Close() })
	if _, err := db.ExecContext(ctx, schema); err != nil {
		t.Fatal(err)
	}

	appender, err := timescale.Open(dsn, slog.New(slog.DiscardHandler))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { appender.Close() })

	now := time.Date(2026, 1, 2, 3, 4, 5, 0, time.UTC)
	useCase := vitals.NewRecordReading(appender, fixedClock{now: now})

	t.Run("stores the reading", func(t *testing.T) {
		result, err := useCase.Record(ctx, validCommand("p-stored"))

		if err != nil {
			t.Fatalf("want no error, got %v", err)
		}
		if !result.RecordedAt.Equal(now) {
			t.Fatalf("want RecordedAt %v, got %v", now, result.RecordedAt)
		}

		var takenAt time.Time
		var systolic, diastolic int
		err = db.QueryRowContext(ctx,
			`SELECT taken_at, systolic, diastolic FROM vitals WHERE patient_id = $1`, "p-stored",
		).Scan(&takenAt, &systolic, &diastolic)
		if err != nil {
			t.Fatal(err)
		}
		if !takenAt.Equal(now) || systolic != 120 || diastolic != 80 {
			t.Fatalf("want 120/80 taken at %v, got %d/%d taken at %v", now, systolic, diastolic, takenAt)
		}
	})

	t.Run("reports a repeated reading as ErrDuplicate", func(t *testing.T) {
		if _, err := useCase.Record(ctx, validCommand("p-duplicate")); err != nil {
			t.Fatal(err)
		}

		// The fixed clock gives the second reading the same key.
		_, err := useCase.Record(ctx, validCommand("p-duplicate"))

		if !errors.Is(err, vitals.ErrDuplicate) {
			t.Fatalf("want ErrDuplicate, got %v", err)
		}
		assertNoDriverError(t, err)
	})

	t.Run("reports an unexpected store failure as ErrStoreFailure", func(t *testing.T) {
		// Hide the table, so the insert fails in a way no rule anticipates.
		if _, err := db.ExecContext(ctx, `ALTER TABLE vitals RENAME TO vitals_hidden`); err != nil {
			t.Fatal(err)
		}
		t.Cleanup(func() {
			if _, err := db.ExecContext(ctx, `ALTER TABLE vitals_hidden RENAME TO vitals`); err != nil {
				t.Error(err)
			}
		})

		_, err := useCase.Record(ctx, validCommand("p-failure"))

		if !errors.Is(err, vitals.ErrStoreFailure) {
			t.Fatalf("want ErrStoreFailure, got %v", err)
		}
		assertNoDriverError(t, err)
	})

	t.Run("returns the caller's cancellation", func(t *testing.T) {
		cancelled, cancel := context.WithCancel(ctx)
		cancel()

		_, err := useCase.Record(cancelled, validCommand("p-cancelled"))

		if !errors.Is(err, context.Canceled) {
			t.Fatalf("want context.Canceled, got %v", err)
		}
	})
}

// Needs no container: nothing listens on port 1.
func TestRecordReadingWithUnreachableStore(t *testing.T) {
	appender, err := timescale.Open("postgres://user:pass@127.0.0.1:1/vitals?connect_timeout=2", slog.New(slog.DiscardHandler))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { appender.Close() })
	useCase := vitals.NewRecordReading(appender, fixedClock{now: time.Unix(0, 0).UTC()})

	_, err = useCase.Record(context.Background(), validCommand("p-unreachable"))

	if !errors.Is(err, vitals.ErrUnavailable) {
		t.Fatalf("want ErrUnavailable, got %v", err)
	}
	assertNoDriverError(t, err)
}

func validCommand(patientID string) vitals.RecordCommand {
	return vitals.RecordCommand{PatientID: patientID, Systolic: 120, Diastolic: 80}
}

// The driver error must not reach the caller through the error chain.
func assertNoDriverError(t *testing.T, err error) {
	t.Helper()
	var pgErr *pgconn.PgError
	var connectErr *pgconn.ConnectError
	if errors.As(err, &pgErr) || errors.As(err, &connectErr) {
		t.Fatalf("driver error exposed: %v", err)
	}
}
```
