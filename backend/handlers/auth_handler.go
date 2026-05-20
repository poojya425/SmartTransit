package handlers

import (
	"log"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
	"github.com/poojya425/smarttransit/backend/models"
	"golang.org/x/crypto/bcrypt"
)

// Register creates a new user account.
func Register(db *sqlx.DB, jwtSecret string) gin.HandlerFunc {
	return func(c *gin.Context) {
		var input struct {
			Name     string `json:"name"`
			Email    string `json:"email"`
			Phone    string `json:"phone"`
			Password string `json:"password"`
		}
		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}
		if input.Email == "" || input.Password == "" {
			c.JSON(400, gin.H{"error": "Email and password are required"})
			return
		}
		// Hash the password
		hash, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
		if err != nil {
			log.Printf("Register hash error: %v", err)
			c.JSON(500, gin.H{"error": "Failed to hash password"})
			return
		}
		user := models.User{
			ID:           uuid.New().String(),
			Name:         input.Name,
			Email:        input.Email,
			Phone:        input.Phone,
			PasswordHash: string(hash),
		}
		_, err = db.Exec(
			"INSERT INTO users (id, name, email, phone, password_hash) VALUES ($1,$2,$3,$4,$5)",
			user.ID, user.Name, user.Email, user.Phone, user.PasswordHash,
		)
		if err != nil {
			log.Printf("Register db error: %v", err)
			c.JSON(500, gin.H{"error": "Email already exists or database error"})
			return
		}
		c.JSON(201, gin.H{"message": "User registered successfully"})
	}
}

// Login authenticates a user and returns a JWT token.
func Login(db *sqlx.DB, jwtSecret string) gin.HandlerFunc {
	return func(c *gin.Context) {
		var input struct {
			Email    string `json:"email"`
			Password string `json:"password"`
		}
		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}
		// Find user by email
		var user models.User
		err := db.Get(&user, "SELECT * FROM users WHERE email=$1", input.Email)
		if err != nil {
			c.JSON(401, gin.H{"error": "Invalid email or password"})
			return
		}
		// Check password
		err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(input.Password))
		if err != nil {
			c.JSON(401, gin.H{"error": "Invalid email or password"})
			return
		}
		// Generate JWT token
		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"user_id": user.ID,
			"email":   user.Email,
			"exp":     time.Now().Add(24 * time.Hour).Unix(),
		})
		tokenString, err := token.SignedString([]byte(jwtSecret))
		if err != nil {
			log.Printf("Login token error: %v", err)
			c.JSON(500, gin.H{"error": "Failed to generate token"})
			return
		}
		c.JSON(200, gin.H{
			"token": tokenString,
			"user": gin.H{
				"id":    user.ID,
				"name":  user.Name,
				"email": user.Email,
			},
		})
	}
}
