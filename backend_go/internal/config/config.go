package config

import "os"

type Config struct {
	HTTPAddr              string
	Port                  string
	JWTSecret             string
	DatabaseURL           string
	CORSAllowedOrigin     string
	Environment           string
	AIProvider            string
	AIModel               string
	OpenAIAPIKey          string
	HuggingFaceAPIKey     string
	AlemAPIKey            string
	AlemEmbeddingAPIKey   string
	AlemRerankAPIKey      string
	AlemEndpoint          string
	AlemEmbeddingEndpoint string
	AlemEmbeddingModel    string
	AlemRerankEndpoint    string
	AlemRerankModel       string
}

func Load() Config {
	port := env("PORT", "8080")
	alemEmbeddingAPIKey := os.Getenv("ALEM_EMBEDDING_API_KEY")
	alemRerankAPIKey := os.Getenv("ALEM_RERANK_API_KEY")

	return Config{
		HTTPAddr:            env("HTTP_ADDR", ":"+port),
		Port:                port,
		JWTSecret:           env("JWT_SECRET", "dev-change-me"),
		DatabaseURL:         env("DATABASE_URL", "memory://local"),
		CORSAllowedOrigin:   env("CORS_ALLOWED_ORIGIN", "*"),
		Environment:         env("APP_ENV", "development"),
		AIProvider:          env("AI_PROVIDER", "mock"),
		AIModel:             os.Getenv("AI_MODEL"),
		OpenAIAPIKey:        os.Getenv("OPENAI_API_KEY"),
		HuggingFaceAPIKey:   os.Getenv("HUGGINGFACE_API_KEY"),
		AlemAPIKey:          os.Getenv("ALEM_API_KEY"),
		AlemEmbeddingAPIKey: alemEmbeddingAPIKey,
		AlemRerankAPIKey:    alemRerankAPIKey,
		AlemEndpoint:        env("ALEM_ENDPOINT", "https://llm.alem.ai/v1/chat/completions"),
		AlemEmbeddingEndpoint: env(
			"ALEM_EMBEDDING_ENDPOINT",
			"https://llm.alem.ai/v1/embeddings",
		),
		AlemEmbeddingModel: os.Getenv("ALEM_EMBEDDING_MODEL"),
		AlemRerankEndpoint: env(
			"ALEM_RERANK_ENDPOINT",
			"https://llm.alem.ai/v1/rerank",
		),
		AlemRerankModel: os.Getenv("ALEM_RERANK_MODEL"),
	}
}

func env(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}

	return fallback
}
