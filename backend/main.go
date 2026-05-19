package main

import (
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/poojya425/smarttransit/backend/config"
	"github.com/poojya425/smarttransit/backend/database"
	"github.com/poojya425/smarttransit/backend/routes"
	log "github.com/sirupsen/logrus"
)

func main() {
	// Load environment variables from .env file
	if err := godotenv.Load(); err != nil {
		log.Warn("No .env file found, using system environment variables")
	}

	// Load configuration
	cfg := config.Load()

	// Connect to database
	db := database.Connect(cfg)
	defer db.Close()

	// Initialize Gin router
	r := gin.Default()

	// Register all routes
	routes.Register(r, db)

	// Start server on port 8080
	log.Infof("Server starting on port %s", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
