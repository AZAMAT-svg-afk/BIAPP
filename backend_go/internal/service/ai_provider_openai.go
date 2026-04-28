package service

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	"github.com/imanflow/baraka-ai/backend_go/internal/config"
)

const openAIChatCompletionsURL = "https://api.openai.com/v1/chat/completions"

type compatibleChatProvider struct {
	name     string
	endpoint string
	apiKey   string
	model    string
	client   *http.Client
}

func newOpenAIProvider(cfg config.Config) AIProvider {
	return compatibleChatProvider{
		name:     "openai",
		endpoint: openAIChatCompletionsURL,
		apiKey:   cfg.OpenAIAPIKey,
		model:    cfg.AIModel,
		client:   defaultAIHTTPClient(),
	}
}

func defaultAIHTTPClient() *http.Client {
	return &http.Client{Timeout: 45 * time.Second}
}

func (p compatibleChatProvider) Name() string {
	return p.name
}

func (p compatibleChatProvider) Chat(ctx context.Context, request AIProviderRequest) (string, error) {
	modelName := strings.TrimSpace(p.model)
	if modelName == "" {
		return "", providerConfigError("AI_MODEL is required for %s provider", p.name)
	}
	if strings.TrimSpace(p.apiKey) == "" {
		return "", providerConfigError("API key is required for %s provider", p.name)
	}

	body := chatCompletionRequest{
		Model:       modelName,
		Messages:    buildChatMessages(request),
		MaxTokens:   180,
		Temperature: 0.15,
	}

	payload, err := json.Marshal(body)
	if err != nil {
		return "", providerFailure("encode request: %v", err)
	}

	httpRequest, err := http.NewRequestWithContext(ctx, http.MethodPost, p.endpoint, bytes.NewReader(payload))
	if err != nil {
		return "", providerFailure("create request: %v", err)
	}

	httpRequest.Header.Set("Authorization", "Bearer "+p.apiKey)
	httpRequest.Header.Set("Content-Type", "application/json")
	httpRequest.Header.Set("Accept", "application/json")

	response, err := p.client.Do(httpRequest)
	if err != nil {
		return "", providerFailure("request failed: %v", err)
	}
	defer response.Body.Close()

	rawBody, err := io.ReadAll(io.LimitReader(response.Body, 1<<20))
	if err != nil {
		return "", providerFailure("read response: %v", err)
	}

	if response.StatusCode < 200 || response.StatusCode >= 300 {
		return "", providerFailure("%s returned %d: %s", p.name, response.StatusCode, compactBody(rawBody))
	}

	var decoded chatCompletionResponse
	if err := json.Unmarshal(rawBody, &decoded); err != nil {
		return "", providerFailure("decode response: %v. Body: %s", err, compactBody(rawBody))
	}

	if decoded.Error != nil && strings.TrimSpace(decoded.Error.Message) != "" {
		return "", providerFailure("%s error: %s", p.name, decoded.Error.Message)
	}

	if len(decoded.Choices) == 0 || strings.TrimSpace(decoded.Choices[0].Message.Content) == "" {
		return "", providerFailure("%s returned empty reply. Body: %s", p.name, compactBody(rawBody))
	}

	return strings.TrimSpace(decoded.Choices[0].Message.Content), nil
}

type chatCompletionRequest struct {
	Model       string                  `json:"model"`
	Messages    []chatCompletionMessage `json:"messages"`
	MaxTokens   int                     `json:"max_tokens,omitempty"`
	Temperature float64                 `json:"temperature,omitempty"`
}

type chatCompletionMessage struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type chatCompletionResponse struct {
	Choices []struct {
		Message chatCompletionMessage `json:"message"`
	} `json:"choices"`
	Error *struct {
		Message string `json:"message"`
	} `json:"error,omitempty"`
}

func buildChatMessages(request AIProviderRequest) []chatCompletionMessage {
	messages := []chatCompletionMessage{
		{Role: "system", Content: request.SystemPrompt},
	}

	history := request.History
	if len(history) > 10 {
		history = history[len(history)-10:]
	}

	for _, item := range history {
		role := strings.ToLower(strings.TrimSpace(item.Role))
		content := strings.TrimSpace(item.Content)

		if content == "" || !isAllowedChatRole(role) {
			continue
		}

		if role == "user" && strings.EqualFold(content, strings.TrimSpace(request.UserMessage)) {
			continue
		}

		messages = append(messages, chatCompletionMessage{
			Role:    role,
			Content: content,
		})
	}

	messages = append(messages, chatCompletionMessage{
		Role:    "user",
		Content: strings.TrimSpace(request.UserMessage),
	})

	return messages
}

func isAllowedChatRole(role string) bool {
	return role == "user" || role == "assistant" || role == "system"
}

func compactBody(body []byte) string {
	const limit = 320

	text := strings.TrimSpace(string(body))
	if len(text) > limit {
		return fmt.Sprintf("%s...", text[:limit])
	}

	return text
}
