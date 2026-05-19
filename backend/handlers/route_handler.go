package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
	"github.com/poojya425/smarttransit/backend/models"
)

// GetRoutes returns all routes from the database.
func GetRoutes(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var routes []models.Route
		err := db.Select(&routes, "SELECT * FROM routes ORDER BY created_at DESC")
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, routes)
	}
}

// GetRouteById returns a single route by ID.
func GetRouteById(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		var route models.Route
		err := db.Get(&route, "SELECT * FROM routes WHERE id=$1", id)
		if err != nil {
			c.JSON(404, gin.H{"error": "Route not found"})
			return
		}
		c.JSON(200, route)
	}
}

// CreateRoute adds a new route to the database.
func CreateRoute(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var route models.Route
		if err := c.ShouldBindJSON(&route); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}
		route.ID = uuid.New().String()
		_, err := db.Exec(
			"INSERT INTO routes (id, name, start_stop, end_stop) VALUES ($1,$2,$3,$4)",
			route.ID, route.Name, route.StartStop, route.EndStop,
		)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(201, route)
	}
}

// UpdateRoute updates an existing route by ID.
func UpdateRoute(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		var route models.Route
		if err := c.ShouldBindJSON(&route); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}
		_, err := db.Exec(
			"UPDATE routes SET name=$1, start_stop=$2, end_stop=$3 WHERE id=$4",
			route.Name, route.StartStop, route.EndStop, id,
		)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, gin.H{"message": "Route updated successfully"})
	}
}

// DeleteRoute removes a route by ID.
func DeleteRoute(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		_, err := db.Exec("DELETE FROM routes WHERE id=$1", id)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, gin.H{"message": "Route deleted successfully"})
	}
}
