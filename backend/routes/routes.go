package routes

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
	"github.com/poojya425/smarttransit/backend/handlers"
)

// Register sets up all API routes and middleware.
func Register(r *gin.Engine, db *sqlx.DB) {
	r.Use(cors.New(cors.Config{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders: []string{"Origin", "Content-Type", "Authorization"},
	}))

	api := r.Group("/api/v1")
	{
		// Bus routes
		buses := api.Group("/buses")
		buses.GET("", handlers.GetBuses(db))
		buses.GET("/:id", handlers.GetBusById(db))
		buses.POST("", handlers.CreateBus(db))
		buses.PUT("/:id", handlers.UpdateBus(db))
		buses.DELETE("/:id", handlers.DeleteBus(db))

		// Route routes
		routeGroup := api.Group("/routes")
		routeGroup.GET("", handlers.GetRoutes(db))
		routeGroup.GET("/:id", handlers.GetRouteById(db))
		routeGroup.POST("", handlers.CreateRoute(db))
		routeGroup.PUT("/:id", handlers.UpdateRoute(db))
		routeGroup.DELETE("/:id", handlers.DeleteRoute(db))

		// Booking routes
		bookings := api.Group("/bookings")
		bookings.GET("", handlers.GetBookings(db))
		bookings.GET("/:id", handlers.GetBookingById(db))
		bookings.POST("", handlers.CreateBooking(db))
		bookings.PUT("/:id", handlers.UpdateBooking(db))
		bookings.DELETE("/:id", handlers.DeleteBooking(db))
	}
}
