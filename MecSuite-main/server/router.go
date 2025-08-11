package main

import (
	"main/handlers"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	// Root route
	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Welcome to the API",
			"version": "1.0.0",
		})
	})

	// Clients routes
	clients := r.Group("/clients")
	{
		// GET /clients
		clients.GET("", handlers.GetClients)
		// POST /clients
		clients.POST("", handlers.CreateClient)
		// GET /clients/:id
		clients.GET("/:id", handlers.GetClientByID)
	}
}