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

	reply = strings.TrimSpace(reply)

	// Qwen кейде қазақша режимде орысша/ағылшынша сөз араластырып жібереді.
	// Алдымен модельдің өзінен жауапты таңдаған тілге түзетуді сұраймыз.
	if needsLanguageRepair(request.Language, reply) {
		repaired, repairErr := s.repairLanguage(ctx, request, reply)
		if repairErr == nil && strings.TrimSpace(repaired) != "" {
			reply = strings.TrimSpace(repaired)
		}
	}

	// Егер қазақша жауап әлі де нашар немесе аралас болса,
	// backend өзі сауатты, қысқа қазақша жауап құрастырады.
	if normalizePromptLanguage(request.Language) == "Kazakh" && needsKazakhFallback(reply) {
		reply = buildKazakhFallbackReply(request)
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
		return `You are a strict Kazakh language editor.

Rewrite the user's answer into clean, natural, grammatically correct Kazakh.

Rules:
- Reply ONLY in Kazakh.
- Use Cyrillic Kazakh.
- Do not add new facts.
- Do not remove important meaning.
- Do not ask new questions.
- Do not use Russian, English, Turkish, Uzbek, Kyrgyz, or random words.
- If the original answer has a task title like "10 отжимание", keep the task title as written, but the sentence around it must be Kazakh.
- Replace mixed phrases:
  "Начни сейчас" -> "Қазір баста"
  "начни" -> "баста"
  "сейчас" -> "қазір"
  "сделай" -> "жаса"
  "задача" -> "тапсырма"
  "план" -> "жоспар"
  "потом" -> "кейін"
- Output only the corrected final answer.
- Keep it short: 2 to 4 sentences.`

	case "English":
		return `You are a strict English language editor.

Rewrite the user's answer into clear, natural, grammatically correct English.

Rules:
- Reply ONLY in English.
- Do not add new facts.
- Do not remove important meaning.
- Do not ask new questions.
- Do not use Russian or Kazakh.
- Output only the corrected final answer.
- Keep it short: 2 to 4 sentences.`

	default:
		return `You are a strict Russian language editor.

Rewrite the user's answer into грамотный, естественный, живой русский язык.

Rules:
- Reply ONLY in Russian.
- Do not add new facts.
- Do not remove important meaning.
- Do not ask new questions.
- Do not use Kazakh or English.
- Output only the corrected final answer.
- Keep it short: 2 to 4 sentences.`
	}
}

func needsLanguageRepair(language string, reply string) bool {
	text := strings.ToLower(strings.TrimSpace(reply))
	if text == "" {
		return false
	}

	switch normalizePromptLanguage(language) {
	case "Kazakh":
		return containsAny(text, []string{
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
			"start",
			"now",
			"task",
			"plan",
			"good",
			"next step",
		})

	case "Russian":
		return containsKazakhSpecificLetters(text) || containsAny(text, []string{
			"start small",
			"next step",
			"push-ups",
			"your plan",
		})

	case "English":
		return containsCyrillic(text)

	default:
		return false
	}
}

func needsKazakhFallback(reply string) bool {
	text := strings.ToLower(strings.TrimSpace(reply))
	if text == "" {
		return true
	}

	return containsAny(text, []string{
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
		"start",
		"now",
		"task",
		"plan",
		"next step",
		"тақырыбыңызда",
		"жасаң",
		"жасаныз",
		"дұрыс етіп келеді",
		"келісі",
		"мақалдау",
		"сүрөң",
		"бірін-ikki",
		"кітептеріңізді",
		"атқарадыңыз",
		"қатысқаныз",
		"көмектесу үшін білім керек",
	})
}

func buildKazakhFallbackReply(request model.ChatRequest) string {
	name := stringFromAny(request.UserContext["name"], "Сұлтан")
	name = strings.TrimSpace(name)
	if name == "" {
		name = "Сұлтан"
	}

	todayTasks := kazakhTaskTitles(request.UserContext["todayTasks"])
	completedTasks := kazakhTaskTitles(request.UserContext["completedTasks"])
	missedTasks := kazakhTaskTitles(request.UserContext["missedTasks"])

	nextPrayerName := ""
	nextPrayerTime := ""
	if prayer, ok := request.UserContext["nextPrayer"].(map[string]any); ok {
		nextPrayerName = stringFromAny(prayer["name"], "")
		nextPrayerTime = stringFromAny(prayer["time"], "")
	}

	taskStreak := ""
	if streaks, ok := request.UserContext["streaks"].(map[string]any); ok {
		taskStreak = anyToString(streaks["task"])
	}

	var sentences []string

	if len(todayTasks) > 0 {
		sentences = append(
			sentences,
			fmt.Sprintf("%s, бүгін жоспарың анық: %s бар.", name, joinKazakhList(todayTasks)),
		)
	} else {
		sentences = append(
			sentences,
			fmt.Sprintf("%s, бүгінге нақты тапсырма көріп тұрған жоқпын.", name),
		)
	}

	if len(completedTasks) > 0 {
		sentences = append(
			sentences,
			fmt.Sprintf("Жақсы бастама бар: %s орындалған.", joinKazakhList(completedTasks)),
		)
	}

	if len(missedTasks) > 0 {
		sentences = append(
			sentences,
			fmt.Sprintf("Өтіп кеткен тапсырмалар бар: %s.", joinKazakhList(missedTasks)),
		)
	}

	if nextPrayerName != "" || nextPrayerTime != "" {
		prayerText := strings.TrimSpace(nextPrayerName + " " + nextPrayerTime)
		if prayerText != "" {
			sentences = append(
				sentences,
				fmt.Sprintf("%s уақыты жақындаса, бір кішкентай істі қазір аяқтап алғаның дұрыс.", prayerText),
			)
		}
	}

	nextStep := buildKazakhNextStep(todayTasks)
	if taskStreak != "" && taskStreak != "0" && taskStreak != "<nil>" {
		sentences = append(
			sentences,
			fmt.Sprintf("Streak-ті сақтау үшін %s.", nextStep),
		)
	} else {
		sentences = append(sentences, capitalizeKazakh(nextStep)+".")
	}

	if len(sentences) > 4 {
		sentences = sentences[:4]
	}

	return strings.Join(sentences, " ")
}

func buildKazakhNextStep(tasks []string) string {
	if len(tasks) == 0 {
		return "қазір 2 минутқа ғана бір пайдалы іске кіріс"
	}

	first := strings.TrimSpace(tasks[0])
	lower := strings.ToLower(first)

	switch {
	case strings.Contains(lower, "отжим"):
		return "қазір 2 рет отжимание жасаудан баста"
	case strings.Contains(lower, "кітап") || strings.Contains(lower, "книга") || strings.Contains(lower, "оқу"):
		return "қазір кітаптан 1 бет оқудан баста"
	case strings.Contains(lower, "су") || strings.Contains(lower, "вода"):
		return "қазір бір стақан су ішуден баста"
	case strings.Contains(lower, "go") || strings.Contains(lower, "код") || strings.Contains(lower, "программ"):
		return "қазір 10 минут оқудан немесе код жазудан баста"
	default:
		return fmt.Sprintf("алдымен ең жеңіл тапсырмадан баста: %s", first)
	}
}

func kazakhTaskTitles(value any) []string {
	items, ok := value.([]any)
	if !ok {
		return nil
	}

	titles := make([]string, 0, len(items))
	for _, item := range items {
		task, ok := item.(map[string]any)
		if !ok {
			continue
		}

		title := stringFromAny(task["title"], "")
		if title == "" {
			title = stringFromAny(task["name"], "")
		}

		title = strings.TrimSpace(title)
		if title != "" {
			titles = append(titles, title)
		}
	}

	return titles
}

func joinKazakhList(items []string) string {
	if len(items) == 0 {
		return ""
	}

	if len(items) == 1 {
		return items[0]
	}

	if len(items) == 2 {
		return items[0] + " және " + items[1]
	}

	return strings.Join(items[:len(items)-1], ", ") + " және " + items[len(items)-1]
}

func capitalizeKazakh(text string) string {
	text = strings.TrimSpace(text)
	if text == "" {
		return text
	}

	runes := []rune(text)
	first := strings.ToUpper(string(runes[0]))
	runes[0] = []rune(first)[0]

	return string(runes)
}

func containsAny(text string, fragments []string) bool {
	for _, fragment := range fragments {
		if strings.Contains(text, strings.ToLower(fragment)) {
			return true
		}
	}
	return false
}

func containsCyrillic(text string) bool {
	for _, r := range text {
		if r >= 'А' && r <= 'я' {
			return true
		}
		if r == 'Ё' || r == 'ё' {
			return true
		}
	}
	return false
}

func containsKazakhSpecificLetters(text string) bool {
	kazakhLetters := []rune{'ә', 'ғ', 'қ', 'ң', 'ө', 'ұ', 'ү', 'һ', 'і'}

	for _, r := range text {
		for _, kazakh := range kazakhLetters {
			if r == kazakh {
				return true
			}
		}
	}

	return false
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
