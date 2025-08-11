package main

import (
	"strings"
	"log"
	"main/config"
	"main/database"
	"main/utils"
	"github.com/gin-gonic/gin"
)

// CORS middleware
func CORSMiddleware() gin.HandlerFunc {
	return gin.HandlerFunc(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", config.ORIGIN)
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})
}

// Security headers middleware
func SecurityHeaders() gin.HandlerFunc {
	return gin.HandlerFunc(func(c *gin.Context) {
		c.Writer.Header().Set("X-Content-Type-Options", "nosniff")
		c.Writer.Header().Set("X-Frame-Options", "DENY")
		c.Writer.Header().Set("X-XSS-Protection", "1; mode=block")
		c.Writer.Header().Set("Content-Security-Policy", "default-src 'self'")
		c.Writer.Header().Set("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
		c.Next()
	})
}

func AuthMiddleware() gin.HandlerFunc {
	// Load authorized tokens from environment
	authorizedTokens := strings.Split(config.AUTHORIZED_TOKENS, ",")
	return func(c *gin.Context) {
		// Get token from header
		token := c.GetHeader("Authorization")
		if token == "" {
			c.AbortWithStatusJSON(401, gin.H{"error": "Authorization header required"})
			return
		}
		// Check if token is authorized
		valid := false
		for _, t := range authorizedTokens {
			if token == t {
				valid = true
				break
			}
		}
		if !valid {
			c.AbortWithStatusJSON(403, gin.H{"error": "Invalid authorization token"})
			return
		}
		c.Next()
	}
}

func main() {
	// Connect to DB
	database.ConnectDB()
	// Set Gin to release mode for production
	if (config.IS_PRODUCTION) {
		gin.SetMode(gin.ReleaseMode)
	}
	// Initialize Gin router
	r := gin.Default()
	// Add CORS middleware
	r.Use(CORSMiddleware())
	// Add security middleware
	r.Use(SecurityHeaders())
	// Add authentication middleware
	r.Use(AuthMiddleware())
	// Add request logging middleware
	r.Use(gin.Logger())
	// Add recovery middleware
	r.Use(gin.Recovery())
	// Setup routes
	SetupRoutes(r)
	// Start the server
	log.Println(utils.Blue + "ℹ Server running on " + config.API_HOST + utils.Reset)
	if err := r.Run(config.API_PORT); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}