-- One row, holding the latest encrypted snapshot of your CORTEX progress.
CREATE TABLE IF NOT EXISTS state (
  id         INTEGER PRIMARY KEY CHECK (id = 1),
  version    INTEGER NOT NULL,
  updated_at TEXT    NOT NULL,
  device     TEXT,
  blob       TEXT    NOT NULL
);
