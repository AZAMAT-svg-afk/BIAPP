package service

import (
	"encoding/json"
	"fmt"
	"strings"

	"github.com/imanflow/baraka-ai/backend_go/internal/model"
)

type AIPromptBuilder struct{}

func (AIPromptBuilder) Build(request model.ChatRequest) string {
	contextJSON, err := json.MarshalIndent(request.UserContext, "", "  ")
	if err != nil {
		contextJSON = []byte("{}")
	}

	language := normalizePromptLanguage(request.Language)
	mode := normalizePromptMode(request.AIMode)
	modePrompt := strings.TrimSpace(request.ModeSystemPrompt)
	if modePrompt == "" {
		modePrompt = defaultModePrompt(mode)
	}

	languageRule := strings.TrimSpace(request.ReplyLanguageRule)
	if languageRule == "" {
		languageRule = defaultLanguageRule(language)
	}

	summary := buildContextSummary(request.UserContext, language)

	return fmt.Sprintf(`%s

%s

You are Baraka AI, a respectful personal mentor inside an Islamic productivity mobile app.

Selected language: %s
AI mode: %s

USER DATA SUMMARY:
%s

FULL USER CONTEXT JSON:
%s

RULES:
- The language rule above overrides every other instruction.
- The mode prompt above overrides the default tone.
- Use only the provided user data.
- Do not invent tasks, prayer times, streaks, mood, habits, names, or statistics.
- Use the real user name from userContext.name. If it is missing, use a neutral address for the detected language.
- Give practical advice based on today's real tasks and habits.
- Mention prayer only if nextPrayer is present.
- Always suggest one small concrete next step.
- Keep the answer short: 2 to 4 sentences.
- Respect Islamic context calmly and politely.
- Do not give fatwas or religious rulings.
- Do not use markdown tables.
`, languageRule, modePrompt, language, mode, summary, string(contextJSON))
}

func defaultModePrompt(mode string) string {
	switch mode {
	case "soft":
		return "You are a very kind, gentle, supportive coach. Always encourage the user, use warm and motivating language. Never criticize. Celebrate small wins. Be like a caring friend who believes in the user."
	case "strict", "hard":
		return "You are a strict, no-nonsense drill sergeant coach. Be direct and demanding. Call out excuses immediately. Push the user hard. Do not sugarcoat anything. Discipline and results are everything."
	default:
		return "You are a balanced productivity coach. Give honest but constructive feedback. Mix encouragement with accountability. Point out what needs improvement while staying respectful and motivating."
	}
}

func defaultLanguageRule(language string) string {
	return fmt.Sprintf("CRITICAL RULE: The user is writing in %s. You MUST respond ONLY in %s. Never switch to any other language under any circumstances. Match the user's language in every single response.", language, language)
}

func buildContextSummary(userContext any, language string) string {
	data := map[string]any{}
	raw, err := json.Marshal(userContext)
	if err == nil {
		_ = json.Unmarshal(raw, &data)
	}

	name := stringValue(data["name"], neutralName(language))
	todayTasks := taskTitles(data["todayTasks"])
	completedTasks := taskTitles(data["completedTasks"])
	missedTasks := taskTitles(data["missedTasks"])
	habits := habitNames(data["habits"])

	nextPrayerName := ""
	nextPrayerTime := ""
	if prayer, ok := data["nextPrayer"].(map[string]any); ok {
		nextPrayerName = stringValue(prayer["name"], "")
		nextPrayerTime = stringValue(prayer["time"], "")
	}

	var builder strings.Builder
	builder.WriteString("User name: ")
	builder.WriteString(name)
	builder.WriteString("\nToday tasks: ")
	builder.WriteString(joinOrNone(todayTasks))
	builder.WriteString("\nCompleted tasks: ")
	builder.WriteString(joinOrNone(completedTasks))
	builder.WriteString("\nMissed tasks: ")
	builder.WriteString(joinOrNone(missedTasks))
	builder.WriteString("\nHabits: ")
	builder.WriteString(joinOrNone(habits))
	builder.WriteString("\nNext prayer: ")
	if nextPrayerName != "" || nextPrayerTime != "" {
		builder.WriteString(strings.TrimSpace(nextPrayerName + " " + nextPrayerTime))
	} else {
		builder.WriteString("none")
	}

	if streaks, ok := data["streaks"].(map[string]any); ok {
		builder.WriteString("\nTask streak: ")
		builder.WriteString(valueOrNone(anyToString(streaks["task"])))
		builder.WriteString("\nHabit streak: ")
		builder.WriteString(valueOrNone(anyToString(streaks["habit"])))
		builder.WriteString("\nPrayer streak: ")
		builder.WriteString(valueOrNone(anyToString(streaks["prayer"])))
		builder.WriteString("\nApp streak: ")
		builder.WriteString(valueOrNone(anyToString(streaks["app"])))
	}

	builder.WriteString("\nMood: ")
	builder.WriteString(valueOrNone(stringValue(data["mood"], "")))
	builder.WriteString("\n")
	return builder.String()
}

func taskTitles(value any) []string {
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
		title := stringValue(task["title"], "")
		if title == "" {
			title = stringValue(task["name"], "")
		}
		if title != "" {
			titles = append(titles, title)
		}
	}
	return titles
}

func habitNames(value any) []string {
	items, ok := value.([]any)
	if !ok {
		return nil
	}

	names := make([]string, 0, len(items))
	for _, item := range items {
		habit, ok := item.(map[string]any)
		if !ok {
			continue
		}
		name := stringValue(habit["name"], "")
		if name == "" {
			name = stringValue(habit["title"], "")
		}
		if name != "" {
			names = append(names, name)
		}
	}
	return names
}

func joinOrNone(items []string) string {
	if len(items) == 0 {
		return "none"
	}
	return strings.Join(items, ", ")
}

func valueOrNone(value string) string {
	value = strings.TrimSpace(value)
	if value == "" || strings.EqualFold(value, "<nil>") {
		return "none"
	}
	return value
}

func stringValue(value any, fallback string) string {
	text := strings.TrimSpace(anyToString(value))
	if text == "" {
		return fallback
	}
	return text
}

func anyToString(value any) string {
	switch typed := value.(type) {
	case nil:
		return ""
	case string:
		return typed
	case float64:
		if typed == float64(int64(typed)) {
			return fmt.Sprintf("%d", int64(typed))
		}
		return fmt.Sprintf("%.2f", typed)
	case int:
		return fmt.Sprintf("%d", typed)
	case int64:
		return fmt.Sprintf("%d", typed)
	case bool:
		if typed {
			return "true"
		}
		return "false"
	default:
		return fmt.Sprintf("%v", typed)
	}
}

func neutralName(language string) string {
	switch language {
	case "Kazakh":
		return "Сіз"
	case "English":
		return "You"
	default:
		return "Вы"
	}
}

func normalizePromptLanguage(language string) string {
	switch strings.ToLower(strings.TrimSpace(language)) {
	case "kk", "kz", "kazakh", "kaz":
		return "Kazakh"
	case "en", "english", "eng":
		return "English"
	default:
		return "Russian"
	}
}

func normalizePromptMode(mode string) string {
	switch strings.ToLower(strings.TrimSpace(mode)) {
	case "soft":
		return "soft"
	case "strict", "hard":
		return "strict"
	default:
		return "normal"
	}
}
