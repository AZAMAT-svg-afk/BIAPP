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
	message := strings.ToLower(request.UserMessage)

	if strings.Contains(message, "лень") || strings.Contains(message, "lazy") || strings.Contains(message, "жалқау") {
		return lazyReply(request.Language, nextPrayerName, nextPrayerTime), nil
	}

	return contextReply(
		request.Language,
		request.Mode,
		todayTasks,
		completedTasks,
		habits,
		nextPrayerName,
		nextPrayerTime,
	), nil
}

func localizedAIOff(language string) string {
	switch language {
	case "kk":
		return "AI тәлімгер өшірулі. Кеңес керек болса, баптаулардан қос."
	case "en":
		return "AI mentor is off. Enable it in settings when you want coaching."
	default:
		return "AI-наставник выключен. Включи его в настройках, когда захочешь подсказки."
	}
}

func lazyReply(language string, prayer string, prayerTime string) string {
	switch language {
	case "kk":
		return fmt.Sprintf("Түсінемін. Бәрін емес, ең кішкентай қадамды жаса: 2 минут немесе бір бет. Келесі намаз: %s %s.", safePrayer(prayer), safePrayerTime(prayerTime))
	case "en":
		return fmt.Sprintf("I get it. Do the smallest version: two minutes or one page. Next prayer: %s %s.", safePrayer(prayer), safePrayerTime(prayerTime))
	default:
		return fmt.Sprintf("Понимаю. Тогда сделай минимальную версию: 2 минуты дела или 1 страницу. Следующий намаз: %s %s.", safePrayer(prayer), safePrayerTime(prayerTime))
	}
}

func contextReply(language string, mode string, total int, completed int, habits int, prayer string, prayerTime string) string {
	switch language {
	case "kk":
		if mode == "strict" {
			return fmt.Sprintf("Бро, жоспар өзің үшін. Бүгін %d/%d тапсырма дайын. Біреуін 2 минутқа баста, сосын демал.", completed, total)
		}
		return fmt.Sprintf("Бүгін %d/%d тапсырма орындалды, әдеттер: %d. %s %s. Енді бір кішкентай қадам таңда.", completed, total, habits, safePrayer(prayer), safePrayerTime(prayerTime))
	case "en":
		if mode == "strict" {
			return fmt.Sprintf("You set this goal for yourself. %d/%d tasks are done. Start one for two minutes, then rest.", completed, total)
		}
		return fmt.Sprintf("You have completed %d/%d tasks, habits tracked: %d. %s %s. Pick one small next step.", completed, total, habits, safePrayer(prayer), safePrayerTime(prayerTime))
	default:
		if mode == "strict" {
			return fmt.Sprintf("Бро, ты сам поставил эту цель. Выполнено %d/%d задач. Начни одну на 2 минуты и закрой вопрос.", completed, total)
		}
		return fmt.Sprintf("Сегодня выполнено %d/%d задач, привычек в фокусе: %d. %s %s. Выбери один маленький следующий шаг.", completed, total, habits, safePrayer(prayer), safePrayerTime(prayerTime))
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
