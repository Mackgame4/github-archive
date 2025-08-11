package models

import (
	"time"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Vehicle struct {
	ID           primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	ClientID     primitive.ObjectID `json:"clientId" bson:"clientId" binding:"required"`
	Plate        string             `json:"plate" bson:"plate" binding:"required"`
	Make        string             `json:"make" bson:"make,omitempty" binding:"omitempty"`
	Model        string             `json:"model" bson:"model,omitempty" binding:"omitempty"`
	Year         int                `json:"year" bson:"year,omitempty" binding:"omitempty,min=1000"`
	VIN          string             `json:"vin,omitempty" bson:"vin,omitempty" binding:"omitempty,min=17,max=17"`
	Color        string             `json:"color,omitempty" bson:"color,omitempty"`
	Mileage      int                `json:"mileage" bson:"mileage" binding:"min=0"`
	LastService  time.Time          `json:"lastService,omitempty" bson:"lastService,omitempty"`
	CreatedAt    time.Time          `json:"createdAt,omitempty" bson:"createdAt,omitempty"`
	UpdatedAt time.Time          `json:"updatedAt,omitempty" bson:"updatedAt,omitempty"`
}