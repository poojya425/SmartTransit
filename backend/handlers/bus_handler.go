package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
	"github.com/poojya425/smarttransit/backend/models"
)

// GetBuses returns all buses from the database.
func GetBuses(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var buses []models.Bus
		err := db.Select(&buses, "SELECT * FROM buses ORDER BY created_at DESC")
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, buses)
	}
}

// GetBusById returns a single bus by ID.
func GetBusById(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		var bus models.Bus
		err := db.Get(&bus, "SELECT * FROM buses WHERE id=$1", id)
		if err != nil {
			c.JSON(404, gin.H{"error": "Bus not found"})
			return
		}
		c.JSON(200, bus)
	}
}

// CreateBus adds a new bus to the database.
func CreateBus(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var bus models.Bus
		if err := c.ShouldBindJSON(&bus); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}
		bus.ID = uuid.New().String()
		_, err := db.Exec(
			"INSERT INTO buses (id, bus_number, route_id, capacity, status) VALUES ($1,$2,$3,$4,$5)",
			bus.ID, bus.BusNumber, bus.RouteID, bus.Capacity, bus.Status,
		)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(201, bus)
	}
}

// UpdateBus updates an existing bus by ID.
func UpdateBus(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		var bus models.Bus
		if err := c.ShouldBindJSON(&bus); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}
		_, err := db.Exec(
			"UPDATE buses SET bus_number=$1, route_id=$2, capacity=$3, status=$4 WHERE id=$5",
			bus.BusNumber, bus.RouteID, bus.Capacity, bus.Status, id,
		)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, gin.H{"message": "Bus updated successfully"})
	}
}

// DeleteBus removes a bus by ID.
func DeleteBus(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		_, err := db.Exec("DELETE FROM buses WHERE id=$1", id)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, gin.H{"message": "Bus deleted successfully"})
	}
}
