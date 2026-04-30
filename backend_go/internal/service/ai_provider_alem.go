package service

import "github.com/imanflow/baraka-ai/backend_go/internal/config"

const defaultAlemChatCompletionsURL = "https://llm.alem.ai/v1/chat/completions"

func newAlemProvider(cfg config.Config) AIProvider {
	endpoint := cfg.AlemEndpoint
	if endpoint == "" {
		endpoint = defaultAlemChatCompletionsURL
	}

	return compatibleChatProvider{
		name:     "alem",
		endpoint: endpoint,
		apiKey:   cfg.AlemAPIKey,
		model:    cfg.AIModel,
		client:   defaultAIHTTPClient(),
	}
}
