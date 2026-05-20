package models

import "time"

// User represents a registered user in the system.
type User struct {
	ID           string    `db:"id" json:"id"`
	Name         string    `db:"name" json:"name"`
	Email        string    `db:"email" json:"email"`
	Phone        string    `db:"phone" json:"phone"`
	PasswordHash string    `db:"password_hash" json:"-"`
	CreatedAt    time.Time `db:"created_at" json:"created_at"`
}

// Route represents a bus route in the system.
type Route struct {
	ID        string    `db:"id" json:"id"`
	Name      string    `db:"name" json:"name"`
	StartStop string    `db:"start_stop" json:"start_stop"`
	EndStop   string    `db:"end_stop" json:"end_stop"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
}

// Bus represents a bus vehicle in the system.
type Bus struct {
	ID        string    `db:"id" json:"id"`
	BusNumber string    `db:"bus_number" json:"bus_number"`
	RouteID   *string   `db:"route_id" json:"route_id"`
	Capacity  int       `db:"capacity" json:"capacity"`
	Status    string    `db:"status" json:"status"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
}

// Booking represents a seat booking made by a user.
type Booking struct {
	ID         string    `db:"id" json:"id"`
	UserID     *string   `db:"user_id" json:"user_id"`
	BusID      *string   `db:"bus_id" json:"bus_id"`
	SeatNumber int       `db:"seat_number" json:"seat_number"`
	Status     string    `db:"status" json:"status"`
	CreatedAt  time.Time `db:"created_at" json:"created_at"`
}
