package model

type AIMessage struct {
	Role      string `json:"role"`
	Content   string `json:"content"`
	CreatedAt string `json:"created_at,omitempty"`
}

type ChatRequest struct {
	Message           string         `json:"message"`
	Language          string         `json:"language"`
	DetectedLanguage  string         `json:"detectedLanguage,omitempty"`
	AIMode            string         `json:"aiMode"`
	ModeSystemPrompt  string         `json:"modeSystemPrompt,omitempty"`
	ReplyLanguageRule string         `json:"replyLanguageRule,omitempty"`
	UserContext       map[string]any `json:"userContext"`
	Context           map[string]any `json:"context,omitempty"`
	History           []AIMessage    `json:"history,omitempty"`
}

type ChatResponse struct {
	Reply       string         `json:"reply"`
	Message     string         `json:"message,omitempty"`
	Mode        string         `json:"mode,omitempty"`
	Provider    string         `json:"provider"`
	Model       string         `json:"model,omitempty"`
	ContextUsed map[string]any `json:"context_used,omitempty"`
}

type EmbeddingRequest struct {
	Input string `json:"input"`
}

type EmbeddingResponse struct {
	Embedding []float64 `json:"embedding"`
	Model     string    `json:"model"`
	Provider  string    `json:"provider"`
}

type RerankDocument struct {
	ID       string         `json:"id"`
	Text     string         `json:"text"`
	Metadata map[string]any `json:"metadata,omitempty"`
}

type RerankRequest struct {
	Query     string           `json:"query"`
	Documents []RerankDocument `json:"documents"`
	TopK      int              `json:"topK,omitempty"`
}

type RerankResult struct {
	ID       string         `json:"id"`
	Text     string         `json:"text"`
	Score    float64        `json:"score"`
	Index    int            `json:"index"`
	Metadata map[string]any `json:"metadata,omitempty"`
}

type RerankResponse struct {
	Results  []RerankResult `json:"results"`
	Model    string         `json:"model"`
	Provider string         `json:"provider"`
}
