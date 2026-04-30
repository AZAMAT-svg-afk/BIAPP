package service

import (
	"bytes"
	"context"
	"encoding/json"
	"io"
	"net/http"
	"strings"

	"github.com/imanflow/baraka-ai/backend_go/internal/config"
	"github.com/imanflow/baraka-ai/backend_go/internal/model"
)

type AlemSemanticProvider struct {
	fallbackAPIKey    string
	embeddingAPIKey   string
	rerankAPIKey      string
	embeddingEndpoint string
	embeddingModel    string
	rerankEndpoint    string
	rerankModel       string
	client            *http.Client
}

func newAlemSemanticProvider(cfg config.Config) AlemSemanticProvider {
	return AlemSemanticProvider{
		fallbackAPIKey:    cfg.AlemAPIKey,
		embeddingAPIKey:   cfg.AlemEmbeddingAPIKey,
		rerankAPIKey:      cfg.AlemRerankAPIKey,
		embeddingEndpoint: cfg.AlemEmbeddingEndpoint,
		embeddingModel:    cfg.AlemEmbeddingModel,
		rerankEndpoint:    cfg.AlemRerankEndpoint,
		rerankModel:       cfg.AlemRerankModel,
		client:            defaultAIHTTPClient(),
	}
}

func (p AlemSemanticProvider) Name() string {
	return "alem"
}

func (p AlemSemanticProvider) Embed(ctx context.Context, input string) ([]float64, error) {
	apiKey := strings.TrimSpace(p.embeddingAPIKey)
	if apiKey == "" {
		apiKey = strings.TrimSpace(p.fallbackAPIKey)
	}
	if apiKey == "" {
		return nil, providerConfigError("ALEM_EMBEDDING_API_KEY or ALEM_API_KEY is required for Alem embeddings")
	}

	endpoint := strings.TrimSpace(p.embeddingEndpoint)
	if endpoint == "" {
		return nil, providerConfigError("ALEM_EMBEDDING_ENDPOINT is required")
	}

	modelName := strings.TrimSpace(p.embeddingModel)
	if modelName == "" {
		return nil, providerConfigError("ALEM_EMBEDDING_MODEL is required")
	}

	rawBody, err := p.postJSON(ctx, endpoint, apiKey, map[string]any{
		"model": modelName,
		"input": strings.TrimSpace(input),
	})
	if err != nil {
		return nil, err
	}

	embedding, err := parseEmbeddingResponse(rawBody)
	if err != nil {
		return nil, err
	}

	return embedding, nil
}

func (p AlemSemanticProvider) Rerank(
	ctx context.Context,
	query string,
	documents []model.RerankDocument,
	topK int,
) ([]model.RerankResult, error) {
	apiKey := strings.TrimSpace(p.rerankAPIKey)
	if apiKey == "" {
		apiKey = strings.TrimSpace(p.fallbackAPIKey)
	}
	if apiKey == "" {
		return nil, providerConfigError("ALEM_RERANK_API_KEY or ALEM_API_KEY is required for Alem reranking")
	}

	endpoint := strings.TrimSpace(p.rerankEndpoint)
	if endpoint == "" {
		return nil, providerConfigError("ALEM_RERANK_ENDPOINT is required")
	}

	modelName := strings.TrimSpace(p.rerankModel)
	if modelName == "" {
		return nil, providerConfigError("ALEM_RERANK_MODEL is required")
	}

	if topK <= 0 || topK > len(documents) {
		topK = len(documents)
	}

	documentTexts := make([]string, 0, len(documents))
	for _, document := range documents {
		documentTexts = append(documentTexts, strings.TrimSpace(document.Text))
	}

	rawBody, err := p.postJSON(ctx, endpoint, apiKey, map[string]any{
		"model":     modelName,
		"query":     strings.TrimSpace(query),
		"documents": documentTexts,
		"top_n":     topK,
	})
	if err != nil {
		return nil, err
	}

	results, err := parseRerankResponse(rawBody, documents)
	if err != nil {
		return nil, err
	}
	if topK > 0 && len(results) > topK {
		results = results[:topK]
	}

	return results, nil
}

func (p AlemSemanticProvider) postJSON(
	ctx context.Context,
	endpoint string,
	apiKey string,
	body map[string]any,
) ([]byte, error) {
	payload, err := json.Marshal(body)
	if err != nil {
		return nil, providerFailure("encode semantic request: %v", err)
	}

	request, err := http.NewRequestWithContext(
		ctx,
		http.MethodPost,
		endpoint,
		bytes.NewReader(payload),
	)
	if err != nil {
		return nil, providerFailure("create semantic request: %v", err)
	}

	request.Header.Set("Authorization", "Bearer "+apiKey)
	request.Header.Set("Content-Type", "application/json")
	request.Header.Set("Accept", "application/json")

	response, err := p.client.Do(request)
	if err != nil {
		return nil, providerFailure("semantic request failed: %v", err)
	}
	defer response.Body.Close()

	rawBody, err := io.ReadAll(io.LimitReader(response.Body, 2<<20))
	if err != nil {
		return nil, providerFailure("read semantic response: %v", err)
	}

	if response.StatusCode < 200 || response.StatusCode >= 300 {
		return nil, providerFailure("alem semantic returned %d: %s", response.StatusCode, compactBody(rawBody))
	}

	return rawBody, nil
}

func parseEmbeddingResponse(rawBody []byte) ([]float64, error) {
	var decoded struct {
		Data []struct {
			Embedding []float64 `json:"embedding"`
		} `json:"data"`
		Embedding []float64 `json:"embedding"`
		Error     *struct {
			Message string `json:"message"`
		} `json:"error,omitempty"`
	}

	if err := json.Unmarshal(rawBody, &decoded); err != nil {
		return nil, providerFailure("decode embedding response: %v. Body: %s", err, compactBody(rawBody))
	}

	if decoded.Error != nil && strings.TrimSpace(decoded.Error.Message) != "" {
		return nil, providerFailure("alem embedding error: %s", decoded.Error.Message)
	}

	if len(decoded.Data) > 0 && len(decoded.Data[0].Embedding) > 0 {
		return decoded.Data[0].Embedding, nil
	}

	if len(decoded.Embedding) > 0 {
		return decoded.Embedding, nil
	}

	var generic map[string]json.RawMessage
	if err := json.Unmarshal(rawBody, &generic); err == nil {
		if rawEmbedding, ok := generic["embeddings"]; ok {
			var nested [][]float64
			if err := json.Unmarshal(rawEmbedding, &nested); err == nil && len(nested) > 0 && len(nested[0]) > 0 {
				return nested[0], nil
			}
		}
	}

	return nil, providerFailure("alem embedding response missing embedding. Body: %s", compactBody(rawBody))
}

func parseRerankResponse(
	rawBody []byte,
	documents []model.RerankDocument,
) ([]model.RerankResult, error) {
	var envelope struct {
		Results []json.RawMessage `json:"results"`
		Data    []json.RawMessage `json:"data"`
		Error   *struct {
			Message string `json:"message"`
		} `json:"error,omitempty"`
	}

	if err := json.Unmarshal(rawBody, &envelope); err != nil {
		return nil, providerFailure("decode rerank response: %v. Body: %s", err, compactBody(rawBody))
	}

	if envelope.Error != nil && strings.TrimSpace(envelope.Error.Message) != "" {
		return nil, providerFailure("alem rerank error: %s", envelope.Error.Message)
	}

	resultItems := envelope.Results
	if len(resultItems) == 0 {
		resultItems = envelope.Data
	}
	if len(resultItems) == 0 {
		return nil, providerFailure("alem rerank response missing results. Body: %s", compactBody(rawBody))
	}

	results := make([]model.RerankResult, 0, len(resultItems))
	for resultIndex, rawResult := range resultItems {
		result, ok := parseRerankResult(rawResult, resultIndex, documents)
		if !ok {
			continue
		}
		results = append(results, result)
	}

	if len(results) == 0 {
		return nil, providerFailure("alem rerank response had no usable results. Body: %s", compactBody(rawBody))
	}

	return results, nil
}

func parseRerankResult(
	rawResult json.RawMessage,
	resultIndex int,
	documents []model.RerankDocument,
) (model.RerankResult, bool) {
	var item map[string]json.RawMessage
	if err := json.Unmarshal(rawResult, &item); err != nil {
		return model.RerankResult{}, false
	}

	index, hasIndex := intField(item, "index")
	if !hasIndex {
		index, hasIndex = intField(item, "document_index")
	}
	if !hasIndex {
		index = resultIndex
	}
	if index < 0 || index >= len(documents) {
		return model.RerankResult{}, false
	}

	score, hasScore := floatField(item, "relevance_score")
	if !hasScore {
		score, hasScore = floatField(item, "score")
	}
	if !hasScore {
		score, _ = floatField(item, "similarity")
	}

	document := documents[index]
	text := stringField(item, "text")
	if text == "" {
		text = nestedStringField(item, "document", "text")
	}
	if text == "" {
		text = document.Text
	}

	return model.RerankResult{
		ID:       document.ID,
		Text:     text,
		Score:    score,
		Index:    index,
		Metadata: document.Metadata,
	}, true
}

func intField(item map[string]json.RawMessage, key string) (int, bool) {
	value, ok := floatField(item, key)
	if !ok {
		return 0, false
	}
	return int(value), true
}

func floatField(item map[string]json.RawMessage, key string) (float64, bool) {
	raw, ok := item[key]
	if !ok {
		return 0, false
	}

	var value float64
	if err := json.Unmarshal(raw, &value); err == nil {
		return value, true
	}

	var text string
	if err := json.Unmarshal(raw, &text); err == nil {
		var parsed float64
		if err := json.Unmarshal([]byte(text), &parsed); err == nil {
			return parsed, true
		}
	}

	return 0, false
}

func stringField(item map[string]json.RawMessage, key string) string {
	raw, ok := item[key]
	if !ok {
		return ""
	}

	var value string
	if err := json.Unmarshal(raw, &value); err == nil {
		return strings.TrimSpace(value)
	}

	return ""
}

func nestedStringField(item map[string]json.RawMessage, key string, nestedKey string) string {
	raw, ok := item[key]
	if !ok {
		return ""
	}

	var nested map[string]json.RawMessage
	if err := json.Unmarshal(raw, &nested); err != nil {
		return ""
	}

	return stringField(nested, nestedKey)
}
