package config

import (
	"os"
)

// Config holds all configuration values for the application.
type Config struct {
	DatabaseURL string
	Port        string
	JWTSecret   string
}

// Load reads configuration from environment variables.
func Load() *Config {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	return &Config{
		DatabaseURL: os.Getenv("DATABASE_URL"),
		Port:        port,
		JWTSecret:   os.Getenv("JWT_SECRET"),
	}
}
