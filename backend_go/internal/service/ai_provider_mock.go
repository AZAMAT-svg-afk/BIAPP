package service

import (
	"context"
	"fmt"
	"strings"
)

type MockAIProvider struct{}

func (MockAIProvider) Name() string {
	return "mock"
}

func (MockAIProvider) Chat(ctx context.Context, request AIProviderRequest) (string, error) {
	select {
	case <-ctx.Done():
		return "", ctx.Err()
	default:
	}

	todayTasks := listLen(request.UserContext["todayTasks"])
	completedTasks := listLen(request.UserContext["completedTasks"])
	habits := listLen(request.UserContext["habits"])
	nextPrayerName := nestedString(request.UserContext, "nextPrayer", "name")
	nextPrayerTime := nestedString(request.UserContext, "nextPrayer", "time")
	name := stringFromAny(request.UserContext["name"], neutralName(normalizePromptLanguage(request.Language)))
	message := strings.ToLower(request.UserMessage)

	if strings.Contains(message, "лень") ||
		strings.Contains(message, "lazy") ||
		strings.Contains(message, "жалқау") {
		return lazyReply(request.Language, request.Mode, name, nextPrayerName, nextPrayerTime), nil
	}

	return contextReply(
		request.Language,
		request.Mode,
		name,
		todayTasks,
		completedTasks,
		habits,
		nextPrayerName,
		nextPrayerTime,
	), nil
}

func localizedAIOff(language string) string {
	switch normalizePromptLanguage(language) {
	case "Kazakh":
		return "AI тәлімгер әрқашан қосулы режимге ауыстырылды. Кеңес керек болса, жаза беріңіз."
	case "English":
		return "AI mentor is always enabled now. Send a message whenever you want coaching."
	default:
		return "AI-наставник теперь всегда включен. Напишите сообщение, когда нужна подсказка."
	}
}

func lazyReply(language string, mode string, name string, prayer string, prayerTime string) string {
	switch normalizePromptLanguage(language) {
	case "Kazakh":
		if mode == "strict" {
			return fmt.Sprintf("%s, сылтау тоқтады: мінсіз емес, тек 2 минут жаса. Келесі намаз: %s %s.", name, safePrayer(prayer), safePrayerTime(prayerTime))
		}
		return fmt.Sprintf("%s, түсінемін. Бәрін емес, ең кішкентай қадамды жаса: 2 минут немесе бір бет. Келесі намаз: %s %s.", name, safePrayer(prayer), safePrayerTime(prayerTime))
	case "English":
		if mode == "strict" {
			return fmt.Sprintf("%s, excuses stop here: do two focused minutes, not a perfect session. Next prayer: %s %s.", name, safePrayer(prayer), safePrayerTime(prayerTime))
		}
		return fmt.Sprintf("%s, I get it. Do the smallest version: two minutes or one page. Next prayer: %s %s.", name, safePrayer(prayer), safePrayerTime(prayerTime))
	default:
		if mode == "strict" {
			return fmt.Sprintf("%s, хватит откладывать: сделайте 2 минуты, не идеально, а сейчас. Следующий намаз: %s %s.", name, safePrayer(prayer), safePrayerTime(prayerTime))
		}
		return fmt.Sprintf("%s, понимаю. Сделайте минимальную версию: 2 минуты дела или 1 страницу. Следующий намаз: %s %s.", name, safePrayer(prayer), safePrayerTime(prayerTime))
	}
}

func contextReply(language string, mode string, name string, total int, completed int, habits int, prayer string, prayerTime string) string {
	switch normalizePromptLanguage(language) {
	case "Kazakh":
		if mode == "strict" {
			return fmt.Sprintf("%s, жоспар өзіңіз үшін. Бүгін %d/%d тапсырма дайын. Біреуін 2 минутқа бастап, нәтижені бекітіңіз.", name, completed, total)
		}
		return fmt.Sprintf("%s, бүгін %d/%d тапсырма орындалды, әдеттер: %d. %s %s. Енді бір кішкентай қадам таңдаңыз.", name, completed, total, habits, safePrayer(prayer), safePrayerTime(prayerTime))
	case "English":
		if mode == "strict" {
			return fmt.Sprintf("%s, you set this goal for yourself. %d/%d tasks are done. Start one for two minutes and finish the point.", name, completed, total)
		}
		return fmt.Sprintf("%s, you have completed %d/%d tasks, habits tracked: %d. %s %s. Pick one small next step.", name, completed, total, habits, safePrayer(prayer), safePrayerTime(prayerTime))
	default:
		if mode == "strict" {
			return fmt.Sprintf("%s, вы сами поставили эту цель. Выполнено %d/%d задач. Начните одну на 2 минуты и закройте вопрос.", name, completed, total)
		}
		return fmt.Sprintf("%s, сегодня выполнено %d/%d задач, привычек в фокусе: %d. %s %s. Выберите один маленький следующий шаг.", name, completed, total, habits, safePrayer(prayer), safePrayerTime(prayerTime))
	}
}

func safePrayer(value string) string {
	if strings.TrimSpace(value) == "" {
		return "намаз"
	}
	return value
}

func safePrayerTime(value string) string {
	if strings.TrimSpace(value) == "" {
		return "скоро"
	}
	return value
}
