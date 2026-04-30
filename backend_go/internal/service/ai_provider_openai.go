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
	return &http.Client{Timeout: 60 * time.Second}
}

func (p compatibleChatProvider) Name() string {
	return p.name
}

func (p compatibleChatProvider) Chat(ctx context.Context, request AIProviderRequest) (string, error) {
	modelName := strings.TrimSpace(p.model)
	if modelName == "" {
		return "", providerConfigError("AI_MODEL is required for %s provider", p.name)
	}

	apiKey := strings.TrimSpace(p.apiKey)
	if apiKey == "" {
		return "", providerConfigError("API key is required for %s provider", p.name)
	}

	disableThinking := false

	body := chatCompletionRequest{
		Model:       modelName,
		Messages:    buildChatMessages(request),
		MaxTokens:   2500,
		Temperature: 0.2,
		TopP:        0.9,
		Stream:      false,

		// Important for Qwen3 / Alem:
		// bool false with omitempty is omitted, so this must be *bool.
		EnableThinking: &disableThinking,

		// Some OpenAI-compatible Qwen/vLLM routers use this field
		// to disable thinking mode.
		ChatTemplateKwargs: map[string]any{
			"enable_thinking": false,
		},
	}

	payload, err := json.Marshal(body)
	if err != nil {
		return "", providerFailure("encode request: %v", err)
	}

	httpRequest, err := http.NewRequestWithContext(ctx, http.MethodPost, p.endpoint, bytes.NewReader(payload))
	if err != nil {
		return "", providerFailure("create request: %v", err)
	}

	httpRequest.Header.Set("Authorization", "Bearer "+apiKey)
	httpRequest.Header.Set("Content-Type", "application/json")
	httpRequest.Header.Set("Accept", "application/json")

	response, err := p.client.Do(httpRequest)
	if err != nil {
		return "", providerFailure("request failed: %v", err)
	}
	defer response.Body.Close()

	rawBody, err := io.ReadAll(io.LimitReader(response.Body, 2<<20))
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

	if len(decoded.Choices) == 0 {
		return "", providerFailure("%s returned no choices. Body: %s", p.name, compactBody(rawBody))
	}

	content := strings.TrimSpace(decoded.Choices[0].Message.Content)
	if content == "" {
		reasoning := strings.TrimSpace(decoded.Choices[0].Message.ReasoningContent)
		if reasoning != "" {
			return "", providerFailure(
				"%s returned reasoning only without final content. finish_reason=%s. Increase max_tokens or disable thinking. Body: %s",
				p.name,
				decoded.Choices[0].FinishReason,
				compactBody(rawBody),
			)
		}

		return "", providerFailure("%s returned empty reply. Body: %s", p.name, compactBody(rawBody))
	}

	return content, nil
}

type chatCompletionRequest struct {
	Model              string                  `json:"model"`
	Messages           []chatCompletionMessage `json:"messages"`
	MaxTokens          int                     `json:"max_tokens,omitempty"`
	Temperature        float64                 `json:"temperature,omitempty"`
	TopP               float64                 `json:"top_p,omitempty"`
	Stream             bool                    `json:"stream"`
	EnableThinking     *bool                   `json:"enable_thinking,omitempty"`
	ChatTemplateKwargs map[string]any          `json:"chat_template_kwargs,omitempty"`
}

type chatCompletionMessage struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type chatCompletionResponse struct {
	Choices []struct {
		FinishReason string `json:"finish_reason"`
		Message      struct {
			Role             string `json:"role"`
			Content          string `json:"content"`
			ReasoningContent string `json:"reasoning_content,omitempty"`
		} `json:"message"`
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
	const limit = 700

	text := strings.TrimSpace(string(body))
	if len(text) > limit {
		return fmt.Sprintf("%s...", text[:limit])
	}

	return text
}
