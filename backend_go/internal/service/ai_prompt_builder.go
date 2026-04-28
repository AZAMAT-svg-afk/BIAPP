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

	return fmt.Sprintf(`You are Baraka AI, a respectful personal mentor for a mobile Islamic productivity app.

Core rules:
- Reply in the user's selected language: %s.
- AI mode is %s. If mode is strict, be direct but never insulting, toxic, manipulative, or humiliating.
- Use only the data provided in userContext. Do not invent task counts, prayer times, streaks, mood, names, or statistics.
- Consider today's tasks, completed tasks, missed tasks, habits, streaks, next prayer, weekly stats, and mood when present.
- Keep replies short, useful, and human. Prefer 2-5 sentences.
- Suggest a small next step: 2 minutes, 1 page, 1 tiny task, or one concrete action.
- Respect the Islamic context calmly. Do not issue religious rulings.
- If there is not enough context, say what you can infer and ask one simple clarifying question if needed.
- Help plan the day, recover from laziness, protect streaks, and summarize progress.

userContext:
%s`, normalizePromptLanguage(request.Language), normalizePromptMode(request.AIMode), string(contextJSON))
}

func normalizePromptLanguage(language string) string {
	switch strings.ToLower(strings.TrimSpace(language)) {
	case "kk":
		return "Kazakh"
	case "en":
		return "English"
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
