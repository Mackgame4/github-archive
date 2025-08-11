package handlers

import (
	"context"
	"net/http"
	"time"
	"main/database"
	"main/models"
	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

func GetClients(c *gin.Context) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	dbCollection := database.GetCollection("clients")
	cursor, err := dbCollection.Find(ctx, bson.M{})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch clients"})
		return
	}
	defer cursor.Close(ctx)
	var clients []models.Client
	if err = cursor.All(ctx, &clients); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to decode clients"})
		return
	}
	if clients == nil {
		clients = []models.Client{}
	}
	c.JSON(http.StatusOK, clients)
}

func CreateClient(c *gin.Context) {
	var client models.Client
	if err := c.ShouldBindJSON(&client); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	dbCollection := database.GetCollection("clients")
	result, err := dbCollection.InsertOne(ctx, client)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create client"})
		return
	}
	client.ID = result.InsertedID.(primitive.ObjectID)
	c.JSON(http.StatusCreated, client)
}

func GetClientByID(c *gin.Context) {
	idStr := c.Param("id")
	objectID, err := primitive.ObjectIDFromHex(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid client ID format"})
		return
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	var client models.Client
	dbCollection := database.GetCollection("clients")
	err = dbCollection.FindOne(ctx, bson.M{"_id": objectID}).Decode(&client)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			c.JSON(http.StatusNotFound, gin.H{"error": "Client not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch client"})
		return
	}
	c.JSON(http.StatusOK, client)
}