package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Part struct {
	PartID      primitive.ObjectID `json:"partId" bson:"partId" binding:"required"`
	Name        string             `json:"name" bson:"name" binding:"required"`
	Quantity    int                `json:"quantity" bson:"quantity" binding:"min=1"`
	UnitPrice   float64            `json:"unitPrice" bson:"unitPrice" binding:"min=0"`
}