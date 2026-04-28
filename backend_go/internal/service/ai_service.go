package service

import (
	"context"
	"fmt"
	"strings"

	"github.com/imanflow/baraka-ai/backend_go/internal/config"
	"github.com/imanflow/baraka-ai/backend_go/internal/model"
)

type AIProvider interface {
	Name() string
	Chat(ctx context.Context, request AIProviderRequest) (string, error)
}

type AIProviderRequest struct {
	Model        string
	SystemPrompt string
	UserMessage  string
	Language     string
	Mode         string
	UserContext  map[string]any
	History      []model.AIMessage
}

type AIService struct {
	cfg           config.Config
	provider      AIProvider
	promptBuilder AIPromptBuilder
}

func NewAIService(cfg config.Config) AIService {
	return AIService{
		cfg:           cfg,
		provider:      newAIProvider(cfg),
		promptBuilder: AIPromptBuilder{},
	}
}

func newAIProvider(cfg config.Config) AIProvider {
	switch strings.ToLower(strings.TrimSpace(cfg.AIProvider)) {
	case "openai":
		return newOpenAIProvider(cfg)
	case "huggingface":
		return newHuggingFaceProvider("huggingface", cfg)
	case "qwen":
		return newHuggingFaceProvider("qwen", cfg)
	default:
		return MockAIProvider{}
	}
}

func (s AIService) Chat(ctx context.Context, request model.ChatRequest) (model.ChatResponse, error) {
	request = normalizeChatRequest(request)
	if strings.TrimSpace(request.Message) == "" {
		return model.ChatResponse{}, ErrInvalidInput
	}

	if request.AIMode == "off" {
		reply := localizedAIOff(request.Language)
		return model.ChatResponse{
			Reply:       reply,
			Message:     reply,
			Mode:        request.AIMode,
			Provider:    s.provider.Name(),
			Model:       s.cfg.AIModel,
			ContextUsed: request.UserContext,
		}, nil
	}

	systemPrompt := s.promptBuilder.Build(request)
	reply, err := s.provider.Chat(ctx, AIProviderRequest{
		Model:        s.cfg.AIModel,
		SystemPrompt: systemPrompt,
		UserMessage:  request.Message,
		Language:     request.Language,
		Mode:         request.AIMode,
		UserContext:  request.UserContext,
		History:      request.History,
	})
	if err != nil {
		return model.ChatResponse{}, err
	}

	return model.ChatResponse{
		Reply:       reply,
		Message:     reply,
		Mode:        request.AIMode,
		Provider:    s.provider.Name(),
		Model:       s.cfg.AIModel,
		ContextUsed: request.UserContext,
	}, nil
}

func (s AIService) DailySummary(userID string) model.ChatResponse {
	reply := "Daily summary is ready. The full personalized summary will use /ai/chat context next."
	return model.ChatResponse{
		Reply:    reply,
		Message:  reply,
		Mode:     "summary",
		Provider: s.provider.Name(),
		Model:    s.cfg.AIModel,
	}
}

func (s AIService) Motivation() model.ChatResponse {
	reply := "Small step now, calm mind later."
	return model.ChatResponse{
		Reply:    reply,
		Message:  reply,
		Mode:     "motivation",
		Provider: s.provider.Name(),
		Model:    s.cfg.AIModel,
	}
}

func (s AIService) TaskSuggestions() map[string]any {
	return map[string]any{
		"suggestions": []string{
			"Read one page",
			"Do two minutes of movement",
			"Review today's top task",
		},
		"provider": s.provider.Name(),
		"model":    s.cfg.AIModel,
	}
}

func normalizeChatRequest(request model.ChatRequest) model.ChatRequest {
	if request.UserContext == nil {
		request.UserContext = map[string]any{}
	}
	if request.Context != nil {
		for key, value := range request.Context {
			if _, exists := request.UserContext[key]; !exists {
				request.UserContext[key] = value
			}
		}
	}
	if strings.TrimSpace(request.Language) == "" {
		request.Language = stringFromAny(request.UserContext["language"], "ru")
	}
	if strings.TrimSpace(request.AIMode) == "" {
		request.AIMode = stringFromAny(request.UserContext["aiMode"], "")
	}
	if strings.TrimSpace(request.AIMode) == "" {
		request.AIMode = stringFromAny(request.UserContext["mode"], "normal")
	}
	request.Language = strings.ToLower(strings.TrimSpace(request.Language))
	request.AIMode = strings.ToLower(strings.TrimSpace(request.AIMode))
	return request
}

func stringFromAny(value any, fallback string) string {
	if text, ok := value.(string); ok && strings.TrimSpace(text) != "" {
		return strings.TrimSpace(text)
	}
	return fallback
}

func listLen(value any) int {
	switch typed := value.(type) {
	case []any:
		return len(typed)
	case []map[string]any:
		return len(typed)
	default:
		return 0
	}
}

func nestedString(parent map[string]any, key string, nestedKey string) string {
	value, ok := parent[key].(map[string]any)
	if !ok {
		return ""
	}
	return stringFromAny(value[nestedKey], "")
}

func providerConfigError(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrProviderConfig, fmt.Sprintf(format, args...))
}

func providerFailure(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrProviderFailure, fmt.Sprintf(format, args...))
}
