package models

import (
	"time"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Record struct {
	ID           primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	VehicleID    primitive.ObjectID `json:"vehicleId" bson:"vehicleId" binding:"required"`
	Services     []Service 			`json:"services,omitempty" bson:"services,omitempty"`
	Notes string            		`json:"notes,omitempty" bson:"notes,omitempty"`
	PartsUsed    []Part         `json:"partsUsed,omitempty" bson:"partsUsed,omitempty"`
	Mileage      int                `json:"mileage" bson:"mileage" binding:"min=0"`
	LabourHours	float64				`json:"labourHours" bson:"labourHours" binding:"min=0"`
	LabourCost    float64            `json:"labourCost" bson:"labourCost" binding:"min=0"`
	TotalCost    float64            `json:"totalCost" bson:"totalCost" binding:"min=0"`
	ServiceDate  time.Time          `json:"serviceDate" bson:"serviceDate" binding:"required"`
	NextServiceDue time.Time        `json:"nextServiceDue,omitempty" bson:"nextServiceDue,omitempty"`
	StartTime 	time.Time			`json:"startTime" bson:"startTime" binding:"required"` // When the vehicle entered the shop
	EndTime		time.Time				`json:"endTime" bson:"endTime"`
}