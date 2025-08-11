package database

import (
	"context"
	"log"
	"time"
	"main/config"
	"main/utils"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var DB *mongo.Database

func ConnectDB() {
	// Create context
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	
	// Connect to MongoDB
	client, err := mongo.Connect(ctx, options.Client().ApplyURI(config.MONGO_URI))
	if err != nil {
		log.Fatal("Failed to connect to MongoDB:", err)
	}

	// Ping the database
	err = client.Ping(ctx, nil)
	if err != nil {
		log.Fatal("Failed to ping MongoDB:", err)
	}

	DB = client.Database(config.MONGO_DB)
	log.Println(utils.Green + "Connected to MongoDB: " + config.MONGO_URI + "/" + config.MONGO_DB + utils.Reset)
}

func GetCollection(collectionName string) *mongo.Collection {
	return DB.Collection(collectionName)
}