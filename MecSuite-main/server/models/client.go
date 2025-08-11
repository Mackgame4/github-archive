package models

import (
	"time"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Client struct {
	ID        primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Name      string             `json:"name" bson:"name" binding:"required"`
	Email     string             `json:"email" bson:"email" binding:"omitempty,email"`
	//Password  string			 `json:"password" bson:"password" binding:"omitempty,password"`
	Phone     string             `json:"phone,omitempty" bson:"phone,omitempty" binding:"omitempty,e164"` // E.164 format (+1234567890)
	Address   string             `json:"address,omitempty" bson:"address,omitempty"`
	CreatedAt time.Time          `json:"createdAt,omitempty" bson:"createdAt,omitempty"`
	UpdatedAt time.Time          `json:"updatedAt,omitempty" bson:"updatedAt,omitempty"`
}