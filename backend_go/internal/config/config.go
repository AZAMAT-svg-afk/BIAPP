package config

import "os"

type Config struct {
	HTTPAddr          string
	Port              string
	JWTSecret         string
	DatabaseURL       string
	CORSAllowedOrigin string
	Environment       string
	AIProvider        string
	AIModel           string
	OpenAIAPIKey      string
	HuggingFaceAPIKey string
}

func Load() Config {
	port := env("PORT", "8080")
	return Config{
		HTTPAddr:          env("HTTP_ADDR", ":"+port),
		Port:              port,
		JWTSecret:         env("JWT_SECRET", "dev-change-me"),
		DatabaseURL:       env("DATABASE_URL", "memory://local"),
		CORSAllowedOrigin: env("CORS_ALLOWED_ORIGIN", "*"),
		Environment:       env("APP_ENV", "development"),
		AIProvider:        env("AI_PROVIDER", "mock"),
		AIModel:           os.Getenv("AI_MODEL"),
		OpenAIAPIKey:      os.Getenv("OPENAI_API_KEY"),
		HuggingFaceAPIKey: os.Getenv("HUGGINGFACE_API_KEY"),
	}
}

func env(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
