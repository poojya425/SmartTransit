package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
	"github.com/poojya425/smarttransit/backend/models"
)

// GetBookings returns all bookings from the database.
func GetBookings(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var bookings []models.Booking
		err := db.Select(&bookings, "SELECT * FROM bookings ORDER BY created_at DESC")
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, bookings)
	}
}

// GetBookingById returns a single booking by ID.
func GetBookingById(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		var booking models.Booking
		err := db.Get(&booking, "SELECT * FROM bookings WHERE id=$1", id)
		if err != nil {
			c.JSON(404, gin.H{"error": "Booking not found"})
			return
		}
		c.JSON(200, booking)
	}
}

// CreateBooking adds a new booking to the database.
func CreateBooking(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var booking models.Booking
		if err := c.ShouldBindJSON(&booking); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}
		booking.ID = uuid.New().String()
		booking.Status = "pending"
		_, err := db.Exec(
			"INSERT INTO bookings (id, user_id, bus_id, seat_number, status) VALUES ($1,$2,$3,$4,$5)",
			booking.ID, booking.UserID, booking.BusID, booking.SeatNumber, booking.Status,
		)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(201, booking)
	}
}

// UpdateBooking updates an existing booking by ID.
func UpdateBooking(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		var booking models.Booking
		if err := c.ShouldBindJSON(&booking); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}
		_, err := db.Exec(
			"UPDATE bookings SET user_id=$1, bus_id=$2, seat_number=$3, status=$4 WHERE id=$5",
			booking.UserID, booking.BusID, booking.SeatNumber, booking.Status, id,
		)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, gin.H{"message": "Booking updated successfully"})
	}
}

// DeleteBooking removes a booking by ID.
func DeleteBooking(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		_, err := db.Exec("DELETE FROM bookings WHERE id=$1", id)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, gin.H{"message": "Booking deleted successfully"})
	}
}
