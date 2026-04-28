package service

import "github.com/imanflow/baraka-ai/backend_go/internal/config"

const huggingFaceChatCompletionsURL = "https://router.huggingface.co/v1/chat/completions"

func newHuggingFaceProvider(name string, cfg config.Config) AIProvider {
	return compatibleChatProvider{
		name:     name,
		endpoint: huggingFaceChatCompletionsURL,
		apiKey:   cfg.HuggingFaceAPIKey,
		model:    cfg.AIModel,
		client:   defaultAIHTTPClient(),
	}
}
