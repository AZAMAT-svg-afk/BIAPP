package model

import "time"

type AIMessage struct {
	Role      string    `json:"role"`
	Content   string    `json:"content"`
	CreatedAt time.Time `json:"created_at,omitempty"`
}

type ChatRequest struct {
	Message     string         `json:"message"`
	Language    string         `json:"language"`
	AIMode      string         `json:"aiMode"`
	UserContext map[string]any `json:"userContext"`
	Context     map[string]any `json:"context,omitempty"`
	History     []AIMessage    `json:"history,omitempty"`
}

type ChatResponse struct {
	Reply       string         `json:"reply"`
	Message     string         `json:"message,omitempty"`
	Mode        string         `json:"mode,omitempty"`
	Provider    string         `json:"provider"`
	Model       string         `json:"model,omitempty"`
	ContextUsed map[string]any `json:"context_used,omitempty"`
}
