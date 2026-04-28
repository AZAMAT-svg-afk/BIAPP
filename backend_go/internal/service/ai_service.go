package service

import (
	"context"
	"fmt"
	"strings"
	"unicode"

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

	reply = normalizeAIReply(reply)

	// Language repair: егер модель бұрыс тілде жауап берсе,
	// бір рет қайта сұраймыз. Repair сәтсіз болса — оригиналды қалдырамыз.
	if shouldAttemptLanguageRepair(s.provider.Name(), request.Language, reply) {
		repaired, repairErr := s.repairLanguage(ctx, request, reply)
		if repairErr == nil && isUsableRepairedReply(request.Language, repaired) {
			reply = normalizeAIReply(repaired)
		}
	}

	reply = postProcessReply(request.Language, reply)

	if strings.TrimSpace(reply) == "" {
		reply = localizedTemporaryAIReply(request.Language)
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

func (s AIService) repairLanguage(ctx context.Context, request model.ChatRequest, originalReply string) (string, error) {
	prompt := buildLanguageRepairPrompt(request.Language)

	return s.provider.Chat(ctx, AIProviderRequest{
		Model:        s.cfg.AIModel,
		SystemPrompt: prompt,
		UserMessage:  originalReply,
		Language:     request.Language,
		Mode:         request.AIMode,
		UserContext:  request.UserContext,
		History:      nil,
	})
}

func buildLanguageRepairPrompt(language string) string {
	switch normalizePromptLanguage(language) {
	case "Kazakh":
		return `SYSTEM OVERRIDE — LANGUAGE LOCK: KAZAKH ONLY.
You MUST rewrite the text below in Kazakh Cyrillic. No Russian. No English. No exceptions.

You are a strict Kazakh language editor.

Your task:
Rewrite the user's answer into clean, natural, grammatically correct Kazakh.

Rules:
- Reply ONLY in Kazakh Cyrillic.
- Do not add new facts.
- Do not remove important meaning.
- Do not change task names (e.g. "10 отжимание", "Go", "React" — keep as written).
- The sentence around task names must be Kazakh.
- Do not ask new questions.
- Do not use Russian, English, Turkish, Uzbek, Kyrgyz, or random words.
- Replace mixed phrases:
  "Начни сейчас" -> "Қазір баста"
  "начни" -> "баста"
  "сейчас" -> "қазір"
  "сделай" -> "жаса"
  "задача" -> "тапсырма"
  "план" -> "жоспар"
  "потом" -> "кейін"
  "хорошо" -> "жақсы"
- Output only the corrected final answer.
- Keep it short: 2 to 4 sentences.
- Preserve the original meaning.`

	case "English":
		return `SYSTEM OVERRIDE — LANGUAGE LOCK: ENGLISH ONLY.
You MUST rewrite the text below in English. No Russian. No Kazakh. No exceptions.

You are a strict English language editor.

Your task:
Rewrite the user's answer into clear, natural, grammatically correct English.

Rules:
- Reply ONLY in English.
- Do not add new facts.
- Do not remove important meaning.
- Do not change task names.
- Do not ask new questions.
- Output only the corrected final answer.
- Keep it short: 2 to 4 sentences.
- Preserve the original meaning.`

	default:
		return `SYSTEM OVERRIDE — LANGUAGE LOCK: RUSSIAN ONLY.
You MUST rewrite the text below in Russian. No Kazakh. No English. No exceptions.

You are a strict Russian language editor.

Your task:
Rewrite the user's answer into грамотный, естественный, живой русский язык.

Rules:
- Reply ONLY in Russian.
- Do not add new facts.
- Do not remove important meaning.
- Do not change task names.
- Do not ask new questions.
- Do not use Kazakh or English.
- Output only the corrected final answer.
- Keep it short: 2 to 4 sentences.
- Preserve the original meaning.`
	}
}

// shouldAttemptLanguageRepair — жауап бұрыс тілде екенін анықтайды.
// Qwen кейде тіл аралас немесе мүлдем басқа тілде жазады,
// сондықтан тек forbidden fragments емес, тіл ratio-сын да тексереміз.
func shouldAttemptLanguageRepair(provider string, language string, reply string) bool {
	reply = strings.TrimSpace(reply)
	if reply == "" {
		return false
	}

	if strings.EqualFold(strings.TrimSpace(provider), "mock") {
		return false
	}

	language = normalizePromptLanguage(language)
	lower := strings.ToLower(reply)

	switch language {
	case "Kazakh":
		// 1. Жауапта қазақ арнайы әріптері мүлдем жоқ және кирилл ratio төмен — бұрыс тіл
		if !hasKazakhSpecificLetters(reply) && cyrillicRatio(reply) < 0.3 {
			return true
		}
		// 2. Орыс/ағылшын forbidden fragments бар
		return hasKazakhLanguageProblems(lower)

	case "Russian":
		// 1. Кирилл ratio тым төмен — орыс емес тілде жазылған
		if cyrillicRatio(reply) < 0.5 {
			return true
		}
		// 2. Қазақ арнайы әріптері немесе ағылшын fragments бар
		return hasRussianLanguageProblems(reply)

	case "English":
		// Кирилл ratio тым жоғары — ағылшын емес
		return hasEnglishLanguageProblems(reply)

	default:
		return false
	}
}

func hasKazakhLanguageProblems(lower string) bool {
	// Тапсырма атауларын тіркелмейміз ("отжимание", "Go", "React") —
	// олар орыс/ағылшын болса да task title ретінде сақталады.
	forbiddenFragments := []string{
		"начни",
		"сейчас",
		"сделай",
		"задача",
		"задачи",
		"план",
		"легко",
		"потом",
		"хорошо",
		"отлично",
		"нормально",
		"сегодня у тебя",
		"начни сейчас",
		"start now",
		"start small",
		"next step",
		"your plan",
	}

	brokenKazakhFragments := []string{
		"сүрөң",
		"мақалдау",
		"бірін-ikki",
		"кітептеріңізді",
		"атқарадыңыз",
		"қатысқаныз",
		"жасаң",
		"жасаныз",
		"дұрыс етіп келеді",
		"тақырыбыңызда",
		"көмектесу үшін білім керек",
		"келісі",
	}

	return aiContainsAnyFragment(lower, forbiddenFragments) ||
		aiContainsAnyFragment(lower, brokenKazakhFragments)
}

func hasRussianLanguageProblems(reply string) bool {
	lower := strings.ToLower(reply)

	englishFragments := []string{
		"start small",
		"next step",
		"push-ups",
		"your plan",
		"keep the rhythm",
	}

	return aiContainsAnyFragment(lower, englishFragments) || hasKazakhSpecificLetters(reply)
}

func hasEnglishLanguageProblems(reply string) bool {
	// Кирилл ratio 25%-дан жоғары болса — модель сбился
	return cyrillicRatio(reply) > 0.25
}

func isUsableRepairedReply(language string, reply string) bool {
	reply = normalizeAIReply(reply)
	if reply == "" {
		return false
	}

	runeCount := len([]rune(reply))
	if runeCount < 8 || runeCount > 1200 {
		return false
	}

	language = normalizePromptLanguage(language)
	lower := strings.ToLower(reply)

	switch language {
	case "Kazakh":
		return !hasKazakhLanguageProblems(lower)

	case "Russian":
		return !hasRussianLanguageProblems(reply)

	case "English":
		return !hasEnglishLanguageProblems(reply)

	default:
		return true
	}
}

func postProcessReply(language string, reply string) string {
	reply = normalizeAIReply(reply)

	switch normalizePromptLanguage(language) {
	case "Kazakh":
		return polishKazakhReply(reply)
	case "Russian":
		return polishRussianReply(reply)
	case "English":
		return polishEnglishReply(reply)
	default:
		return reply
	}
}

func polishKazakhReply(reply string) string {
	reply = strings.TrimSpace(reply)
	if reply == "" {
		return ""
	}

	replacements := []struct {
		old string
		new string
	}{
		{"Баста 2 отжимание жаса", "Қазір 2 рет отжимание жасаудан баста"},
		{"баста 2 отжимание жаса", "қазір 2 рет отжимание жасаудан баста"},
		{"Баста 2 рет отжимание жаса", "Қазір 2 рет отжимание жасаудан баста"},
		{"баста 2 рет отжимание жаса", "қазір 2 рет отжимание жасаудан баста"},
		{"Начни сейчас", "Қазір баста"},
		{"начни сейчас", "қазір баста"},
		{"начни", "баста"},
		{"сейчас", "қазір"},
		{"сделай", "жаса"},
		{"задача", "тапсырма"},
		{"задачи", "тапсырмалар"},
		{"план", "жоспар"},
		{"потом", "кейін"},
		{"хорошо", "жақсы"},
		{"Сізге", "Саған"},
		{"сізге", "саған"},
		{"жоспарыңыз", "жоспарың"},
		{"тапсырмаларыңыз", "тапсырмаларың"},
		{"алғаныңыз дұрыс", "алғаның дұрыс"},
		{"жасаңыз", "жаса"},
		{"бастаңыз", "баста"},
		{"тақырыбыңызда", "жоспарыңда"},
		{"дұрыс етіп келеді", "дұрыс болады"},
	}

	for _, replacement := range replacements {
		reply = strings.ReplaceAll(reply, replacement.old, replacement.new)
	}

	reply = cleanCommonPunctuation(reply)

	return reply
}

func polishRussianReply(reply string) string {
	reply = strings.TrimSpace(reply)
	if reply == "" {
		return ""
	}

	reply = cleanCommonPunctuation(reply)
	return reply
}

func polishEnglishReply(reply string) string {
	reply = strings.TrimSpace(reply)
	if reply == "" {
		return ""
	}

	reply = cleanCommonPunctuation(reply)
	return reply
}

func normalizeAIReply(reply string) string {
	reply = strings.TrimSpace(reply)
	if reply == "" {
		return ""
	}

	lines := strings.Split(reply, "\n")
	cleanLines := make([]string, 0, len(lines))

	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		cleanLines = append(cleanLines, line)
	}

	if len(cleanLines) == 0 {
		return ""
	}

	return strings.Join(cleanLines, "\n")
}

func cleanCommonPunctuation(text string) string {
	text = strings.TrimSpace(text)

	for strings.Contains(text, "  ") {
		text = strings.ReplaceAll(text, "  ", " ")
	}

	replacements := []struct {
		old string
		new string
	}{
		{" .", "."},
		{" ,", ","},
		{" !", "!"},
		{" ?", "?"},
		{" :", ":"},
		{" ;", ";"},
		{"..", "."},
		{" ,", ","},
	}

	for _, replacement := range replacements {
		text = strings.ReplaceAll(text, replacement.old, replacement.new)
	}

	return strings.TrimSpace(text)
}

func localizedTemporaryAIReply(language string) string {
	switch normalizePromptLanguage(language) {
	case "Kazakh":
		return "Қазір толық жауап құра алмадым. Бір кішкентай тапсырмадан бастап көр."
	case "English":
		return "I could not build a full answer right now. Start with one small task."
	default:
		return "Сейчас не получилось составить полный ответ. Начни с одной маленькой задачи."
	}
}

func aiContainsAnyFragment(text string, fragments []string) bool {
	text = strings.ToLower(text)

	for _, fragment := range fragments {
		fragment = strings.ToLower(strings.TrimSpace(fragment))
		if fragment == "" {
			continue
		}

		if strings.Contains(text, fragment) {
			return true
		}
	}

	return false
}

func hasKazakhSpecificLetters(text string) bool {
	for _, r := range strings.ToLower(text) {
		switch r {
		case 'ә', 'ғ', 'қ', 'ң', 'ө', 'ұ', 'ү', 'һ', 'і':
			return true
		}
	}

	return false
}

func cyrillicRatio(text string) float64 {
	var letters int
	var cyrillic int

	for _, r := range text {
		if !unicode.IsLetter(r) {
			continue
		}

		letters++
		if unicode.Is(unicode.Cyrillic, r) {
			cyrillic++
		}
	}

	if letters == 0 {
		return 0
	}

	return float64(cyrillic) / float64(letters)
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