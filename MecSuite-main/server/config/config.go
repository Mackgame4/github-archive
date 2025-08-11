package config

const (
	IS_PRODUCTION = true
	ORIGIN = "*" // Change to your frontend URL in production, e.g., "https://yourdomain.com"
	AUTHORIZED_TOKENS = "secret,another-secret" // Comma-separated list of authorized tokens
	MONGO_URI = "mongodb://localhost:27017"
	MONGO_DB  = "goapi"
	API_PORT  = ":8443"
	API_HOST  = "http://localhost" + API_PORT
)