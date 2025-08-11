package models

import (
	"time"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Appointment struct {
	ID          primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	ClientID    primitive.ObjectID `json:"clientId" bson:"clientId" binding:"required"`
	VehicleID   primitive.ObjectID `json:"vehicleId" bson:"vehicleId" binding:"required"`
	ServiceType primitive.ObjectID `json:"serviceType,omitempty" bson:"serviceType,omitempty"`
	ScheduledAt time.Time          `json:"scheduledAt" bson:"scheduledAt" binding:"required"`
	Duration    time.Duration      `json:"duration" bson:"duration" binding:"required"` // in minutes
	Status      string             `json:"status" bson:"status" binding:"required,oneof=scheduled in-progress completed cancelled"`
	Notes       string             `json:"notes,omitempty" bson:"notes,omitempty"`
	CreatedAt   time.Time          `json:"createdAt,omitempty" bson:"createdAt,omitempty"`
}