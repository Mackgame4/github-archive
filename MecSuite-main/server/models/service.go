package models

import (
	"time"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Service struct {
	ID          primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Name        string             `json:"name" bson:"name" binding:"required"`
	Description string             `json:"description,omitempty" bson:"description,omitempty"`
	Duration    time.Duration      `json:"duration" bson:"duration" binding:"min=0"`
	BasePrice   float64            `json:"basePrice" bson:"basePrice" binding:"min=0"`
}