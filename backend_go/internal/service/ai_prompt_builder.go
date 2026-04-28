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
	summary := buildContextSummary(request.UserContext)

	return fmt.Sprintf(`You are Baraka AI, a respectful personal mentor inside an Islamic productivity mobile app.

CRITICAL TASK:
You must answer in the selected language with excellent grammar and natural style.

Selected language: %s
AI mode: %s

USER DATA SUMMARY:
%s

FULL USER CONTEXT JSON:
%s

GENERAL RULES:
- Use the USER DATA SUMMARY first. It is more important than raw JSON.
- Use only the provided user data.
- Do not invent tasks, prayer times, streaks, mood, habits, names, or statistics.
- Do not ask what the user's tasks are if tasks are already listed in the summary.
- Give practical advice based on today's real tasks.
- Always suggest one small concrete next step.
- Keep the answer short: 2 to 4 sentences.
- Respect Islamic context calmly and politely.
- Do not give fatwas or religious rulings.
- Never shame, insult, manipulate, or scare the user.
- Do not use markdown tables.
- Do not write long explanations.

LANGUAGE QUALITY RULES:

1. If selected language is Kazakh:
- Reply ONLY in Kazakh.
- Use Cyrillic Kazakh.
- Use clean, natural, grammatically correct Kazakh.
- Do NOT mix Russian, English, Turkish, Uzbek, Kyrgyz, or random words.
- Do NOT use broken, fake, or unnatural words.
- Do NOT use hybrid phrases that mix languages.
- If you accidentally write any Russian or English word, rewrite the whole answer before sending it.
- The final answer must sound like natural Kazakh spoken by a literate native speaker.
- Never use strange phrases like:
  "Сүрөң", "мақалдау", "бірін-ikki", "кітептеріңізді атқарадыңыз", "Начни сейчас".
- Forbidden Russian words in Kazakh mode:
  "начни", "сейчас", "сделай", "задача", "план", "легко", "потом", "хорошо", "отлично", "нормально".
- Use Kazakh replacements:
  "начни" -> "баста"
  "сейчас" -> "қазір"
  "сделай" -> "жаса"
  "задача" -> "тапсырма"
  "план" -> "жоспар"
  "легко" -> "жеңіл"
  "потом" -> "кейін"
  "хорошо" -> "жақсы"
- Prefer short and correct Kazakh sentences.
- Use friendly informal style, but stay respectful.
- Mention the user's real tasks if they are available.
- If the task title contains a Russian word like "отжимание", you may keep the task title as written, but the sentence around it must be Kazakh.
- Good Kazakh examples:
  "Сұлтан, бүгін жоспарың анық: 10 отжимание және кітап оқу бар."
  "Алдымен ең жеңілінен баста — қазір 2 рет отжимание жаса."
  "Иша уақыты 20:45, сондықтан бір кішкентай істі қазір аяқтап алғаның дұрыс."
  "Мінсіз жасау міндет емес. Бастысы — тоқтап қалмау."
  "Бүгін бір тапсырманы аяқтасаң да, ритмді сақтап қаласың."

2. If selected language is Russian:
- Reply ONLY in Russian.
- Use грамотный, естественный, живой русский язык.
- Do NOT mix Kazakh or English unless the user specifically uses those words.
- Avoid robotic phrases.
- Be friendly, clear, and motivating.
- Mention the user's real tasks if they are available.
- Good Russian examples:
  "Султан, на сегодня у тебя есть 10 отжиманий и чтение книги."
  "Начни с самого лёгкого: сделай хотя бы 2 отжимания прямо сейчас."
  "До Иша осталось немного времени, поэтому лучше закрыть одну маленькую задачу сейчас."
  "Не нужно делать идеально. Главное — не сбить ритм."

3. If selected language is English:
- Reply ONLY in English.
- Use clear, natural, grammatically correct English.
- Do NOT mix Russian or Kazakh.
- Be warm, concise, and practical.
- Mention the user's real tasks if they are available.
- Good English examples:
  "Sultan, your plan today is clear: 10 push-ups and reading a book."
  "Start small: do just 2 push-ups now."
  "Isha is at 20:45, so finish one small task now and then take a break."
  "You do not need to be perfect. Just keep the rhythm."

AI MODE:
- soft: gentle, calm, supportive.
- normal: friendly, clear, motivating.
- strict: direct and honest, but respectful. Never insult.
- off: minimal advice, no pressure.

RESPONSE FORMAT:
- Maximum 2 to 4 sentences.
- No markdown table.
- No long explanation.
- No fake statistics.
- Start with the user's current situation.
- End with one clear next step.
- Do not ask a question if the context already gives enough information.
`, language, mode, summary, string(contextJSON))
}

func buildContextSummary(userContext any) string {
	data := map[string]any{}

	raw, err := json.Marshal(userContext)
	if err == nil {
		_ = json.Unmarshal(raw, &data)
	}

	name := stringValue(data["name"], "Пайдаланушы")

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

	taskStreak := ""
	habitStreak := ""
	prayerStreak := ""
	appStreak := ""

	if streaks, ok := data["streaks"].(map[string]any); ok {
		taskStreak = anyToString(streaks["task"])
		habitStreak = anyToString(streaks["habit"])
		prayerStreak = anyToString(streaks["prayer"])
		appStreak = anyToString(streaks["app"])
	}

	mood := stringValue(data["mood"], "")

	var builder strings.Builder

	builder.WriteString("User name: ")
	builder.WriteString(name)
	builder.WriteString("\n")

	builder.WriteString("Today tasks: ")
	builder.WriteString(joinOrNone(todayTasks))
	builder.WriteString("\n")

	builder.WriteString("Completed tasks: ")
	builder.WriteString(joinOrNone(completedTasks))
	builder.WriteString("\n")

	builder.WriteString("Missed tasks: ")
	builder.WriteString(joinOrNone(missedTasks))
	builder.WriteString("\n")

	builder.WriteString("Habits: ")
	builder.WriteString(joinOrNone(habits))
	builder.WriteString("\n")

	builder.WriteString("Next prayer: ")
	if nextPrayerName != "" || nextPrayerTime != "" {
		builder.WriteString(strings.TrimSpace(nextPrayerName + " " + nextPrayerTime))
	} else {
		builder.WriteString("none")
	}
	builder.WriteString("\n")

	builder.WriteString("Task streak: ")
	builder.WriteString(valueOrNone(taskStreak))
	builder.WriteString("\n")

	builder.WriteString("Habit streak: ")
	builder.WriteString(valueOrNone(habitStreak))
	builder.WriteString("\n")

	builder.WriteString("Prayer streak: ")
	builder.WriteString(valueOrNone(prayerStreak))
	builder.WriteString("\n")

	builder.WriteString("App streak: ")
	builder.WriteString(valueOrNone(appStreak))
	builder.WriteString("\n")

	builder.WriteString("Mood: ")
	builder.WriteString(valueOrNone(mood))
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

func normalizePromptLanguage(language string) string {
	switch strings.ToLower(strings.TrimSpace(language)) {
	case "kk", "kz", "kazakh", "қазақша", "kaz":
		return "Kazakh"
	case "en", "english", "eng":
		return "English"
	case "ru", "russian", "русский", "rus":
		return "Russian"
	default:
		return "Russian"
	}
}

func normalizePromptMode(mode string) string {
	switch strings.ToLower(strings.TrimSpace(mode)) {
	case "soft":
		return "soft"
	case "strict":
		return "strict"
	case "off":
		return "off"
	default:
		return "normal"
	}
}