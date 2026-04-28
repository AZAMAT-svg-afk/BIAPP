package database

import (
	"strings"

	"github.com/imanflow/baraka-ai/backend_go/internal/config"
)

type DB struct {
	Driver string
	DSN    string
}

func Open(cfg config.Config) *DB {
	driver := "memory"
	if strings.HasPrefix(cfg.DatabaseURL, "postgres://") || strings.HasPrefix(cfg.DatabaseURL, "postgresql://") {
		driver = "postgres"
	}
	if strings.HasPrefix(cfg.DatabaseURL, "sqlite://") {
		driver = "sqlite"
	}

	return &DB{
		Driver: driver,
		DSN:    cfg.DatabaseURL,
	}
}

// TODO: Replace this descriptor with a real PostgreSQL pool, for example pgxpool,
// when persistence/sync becomes the backend source of truth.
