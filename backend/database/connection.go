package database

import (
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"github.com/poojya425/smarttransit/backend/config"
	log "github.com/sirupsen/logrus"
)

// Connect establishes a connection to the PostgreSQL database.
// Returns a sqlx.DB instance or exits if connection fails.
func Connect(cfg *config.Config) *sqlx.DB {
	db, err := sqlx.Connect("postgres", cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(5)

	log.Info("Database connected successfully")
	return db
}
