package repository

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/imanflow/baraka-ai/backend_go/internal/database"
	"github.com/imanflow/baraka-ai/backend_go/internal/model"
)

var ErrEmailExists = errors.New("email already exists")

type MemoryRepository struct {
	db *database.DB

	mu             sync.RWMutex
	users          map[string]model.User
	userIDsByEmail map[string]string
	passwords      map[string]string
	tasks          map[string]map[string]model.Task
	habits         map[string]map[string]model.Habit
	notes          map[string]map[string]model.Note
	settings       map[string]model.Settings
}

func NewMemoryRepository(db *database.DB) *MemoryRepository {
	repo := &MemoryRepository{
		db:             db,
		users:          map[string]model.User{},
		userIDsByEmail: map[string]string{},
		passwords:      map[string]string{},
		tasks:          map[string]map[string]model.Task{},
		habits:         map[string]map[string]model.Habit{},
		notes:          map[string]map[string]model.Note{},
		settings:       map[string]model.Settings{},
	}
	repo.seed()
	return repo
}

func (r *MemoryRepository) CreateUser(input model.RegisterRequest) (model.User, error) {
	r.mu.Lock()
	defer r.mu.Unlock()

	email := normalizeEmail(input.Email)
	if _, exists := r.userIDsByEmail[email]; exists {
		return model.User{}, ErrEmailExists
	}

	now := time.Now().UTC()
	user := model.User{
		ID:        newID("user"),
		Name:      fallback(input.Name, "New User"),
		Email:     email,
		Language:  fallback(input.Language, "ru"),
		City:      "Qyzylorda",
		CreatedAt: now,
		UpdatedAt: now,
	}

	r.users[user.ID] = user
	r.userIDsByEmail[email] = user.ID
	r.passwords[user.ID] = input.Password
	r.settings[user.ID] = defaultSettings(user.ID, user.Language)
	return user, nil
}

func (r *MemoryRepository) FindUserByEmail(email string) (model.User, string, bool) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	userID, ok := r.userIDsByEmail[normalizeEmail(email)]
	if !ok {
		return model.User{}, "", false
	}
	user, ok := r.users[userID]
	return user, r.passwords[userID], ok
}

func (r *MemoryRepository) UserByID(userID string) (model.User, bool) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	user, ok := r.users[userID]
	return user, ok
}

func (r *MemoryRepository) UpdateUser(userID string, input model.UserUpdateRequest) (model.User, bool) {
	r.mu.Lock()
	defer r.mu.Unlock()

	user, ok := r.users[userID]
	if !ok {
		return model.User{}, false
	}
	if input.Name != nil {
		user.Name = *input.Name
	}
	if input.Language != nil {
		user.Language = *input.Language
	}
	if input.City != nil {
		user.City = *input.City
	}
	user.UpdatedAt = time.Now().UTC()
	r.users[userID] = user
	return user, true
}

func (r *MemoryRepository) ListTasks(userID string) []model.Task {
	r.mu.RLock()
	defer r.mu.RUnlock()

	items := make([]model.Task, 0, len(r.tasks[userID]))
	for _, task := range r.tasks[userID] {
		items = append(items, task)
	}
	sort.Slice(items, func(i, j int) bool {
		if items[i].Date == items[j].Date {
			return items[i].Time < items[j].Time
		}
		return items[i].Date < items[j].Date
	})
	return items
}

func (r *MemoryRepository) CreateTask(userID string, input model.Task) model.Task {
	r.mu.Lock()
	defer r.mu.Unlock()

	now := time.Now().UTC()
	input.ID = fallback(input.ID, newID("task"))
	input.UserID = userID
	input.Priority = fallback(input.Priority, "medium")
	input.RepeatType = fallback(input.RepeatType, "none")
	input.Date = fallback(input.Date, now.Format(time.DateOnly))
	input.CreatedAt = now
	input.UpdatedAt = now

	ensureMap(r.tasks, userID)
	r.tasks[userID][input.ID] = input
	return input
}

func (r *MemoryRepository) UpdateTask(userID string, taskID string, input model.Task) (model.Task, bool) {
	r.mu.Lock()
	defer r.mu.Unlock()

	task, ok := r.tasks[userID][taskID]
	if !ok {
		return model.Task{}, false
	}
	createdAt := task.CreatedAt
	completedAt := task.CompletedAt
	input.ID = taskID
	input.UserID = userID
	input.CreatedAt = createdAt
	input.UpdatedAt = time.Now().UTC()
	if input.CompletedAt == nil {
		input.CompletedAt = completedAt
	}
	input.Priority = fallback(input.Priority, "medium")
	input.RepeatType = fallback(input.RepeatType, "none")
	r.tasks[userID][taskID] = input
	return input, true
}

func (r *MemoryRepository) DeleteTask(userID string, taskID string) bool {
	r.mu.Lock()
	defer r.mu.Unlock()

	if _, ok := r.tasks[userID][taskID]; !ok {
		return false
	}
	delete(r.tasks[userID], taskID)
	return true
}

func (r *MemoryRepository) CompleteTask(userID string, taskID string) (model.Task, bool) {
	r.mu.Lock()
	defer r.mu.Unlock()

	task, ok := r.tasks[userID][taskID]
	if !ok {
		return model.Task{}, false
	}
	now := time.Now().UTC()
	task.IsCompleted = true
	task.CompletedAt = &now
	task.UpdatedAt = now
	r.tasks[userID][taskID] = task
	return task, true
}

func (r *MemoryRepository) ListHabits(userID string) []model.Habit {
	r.mu.RLock()
	defer r.mu.RUnlock()

	items := make([]model.Habit, 0, len(r.habits[userID]))
	for _, habit := range r.habits[userID] {
		items = append(items, habit)
	}
	sort.Slice(items, func(i, j int) bool {
		return items[i].CreatedAt.Before(items[j].CreatedAt)
	})
	return items
}

func (r *MemoryRepository) CreateHabit(userID string, input model.Habit) model.Habit {
	r.mu.Lock()
	defer r.mu.Unlock()

	now := time.Now().UTC()
	input.ID = fallback(input.ID, newID("habit"))
	input.UserID = userID
	input.TargetPerDay = max(input.TargetPerDay, 1)
	input.CreatedAt = now
	input.UpdatedAt = now

	ensureMap(r.habits, userID)
	r.habits[userID][input.ID] = input
	return input
}

func (r *MemoryRepository) UpdateHabit(userID string, habitID string, input model.Habit) (model.Habit, bool) {
	r.mu.Lock()
	defer r.mu.Unlock()

	habit, ok := r.habits[userID][habitID]
	if !ok {
		return model.Habit{}, false
	}
	input.ID = habitID
	input.UserID = userID
	input.CreatedAt = habit.CreatedAt
	input.UpdatedAt = time.Now().UTC()
	if input.TargetPerDay <= 0 {
		input.TargetPerDay = habit.TargetPerDay
	}
	if input.Streak == 0 {
		input.Streak = habit.Streak
	}
	if input.LastCheckedAt == nil {
		input.LastCheckedAt = habit.LastCheckedAt
	}
	r.habits[userID][habitID] = input
	return input, true
}

func (r *MemoryRepository) DeleteHabit(userID string, habitID string) bool {
	r.mu.Lock()
	defer r.mu.Unlock()

	if _, ok := r.habits[userID][habitID]; !ok {
		return false
	}
	delete(r.habits[userID], habitID)
	return true
}

func (r *MemoryRepository) CheckHabit(userID string, habitID string) (model.Habit, bool) {
	r.mu.Lock()
	defer r.mu.Unlock()

	habit, ok := r.habits[userID][habitID]
	if !ok {
		return model.Habit{}, false
	}
	now := time.Now().UTC()
	alreadyCheckedToday := habit.LastCheckedAt != nil && habit.LastCheckedAt.Format(time.DateOnly) == now.Format(time.DateOnly)
	habit.CompletedToday = true
	habit.CompletedCount = min(habit.CompletedCount+1, max(habit.TargetPerDay, 1))
	if !alreadyCheckedToday {
		habit.Streak++
	}
	habit.LastCheckedAt = &now
	habit.UpdatedAt = now
	r.habits[userID][habitID] = habit
	return habit, true
}

func (r *MemoryRepository) ListNotes(userID string) []model.Note {
	r.mu.RLock()
	defer r.mu.RUnlock()

	items := make([]model.Note, 0, len(r.notes[userID]))
	for _, note := range r.notes[userID] {
		items = append(items, note)
	}
	sort.Slice(items, func(i, j int) bool {
		if items[i].IsPinned != items[j].IsPinned {
			return items[i].IsPinned
		}
		return items[i].UpdatedAt.After(items[j].UpdatedAt)
	})
	return items
}

func (r *MemoryRepository) CreateNote(userID string, input model.Note) model.Note {
	r.mu.Lock()
	defer r.mu.Unlock()

	now := time.Now().UTC()
	input.ID = fallback(input.ID, newID("note"))
	input.UserID = userID
	input.Tags = normalizeTags(input.Tags)
	input.CreatedAt = now
	input.UpdatedAt = now

	ensureMap(r.notes, userID)
	r.notes[userID][input.ID] = input
	return input
}

func (r *MemoryRepository) UpdateNote(userID string, noteID string, input model.Note) (model.Note, bool) {
	r.mu.Lock()
	defer r.mu.Unlock()

	note, ok := r.notes[userID][noteID]
	if !ok {
		return model.Note{}, false
	}
	input.ID = noteID
	input.UserID = userID
	input.Tags = normalizeTags(input.Tags)
	input.CreatedAt = note.CreatedAt
	input.UpdatedAt = time.Now().UTC()
	r.notes[userID][noteID] = input
	return input, true
}

func (r *MemoryRepository) DeleteNote(userID string, noteID string) bool {
	r.mu.Lock()
	defer r.mu.Unlock()

	if _, ok := r.notes[userID][noteID]; !ok {
		return false
	}
	delete(r.notes[userID], noteID)
	return true
}

func (r *MemoryRepository) Settings(userID string) model.Settings {
	r.mu.Lock()
	defer r.mu.Unlock()

	settings, ok := r.settings[userID]
	if !ok {
		settings = defaultSettings(userID, "ru")
		r.settings[userID] = settings
	}
	return settings
}

func (r *MemoryRepository) UpdateSettings(userID string, patch model.SettingsPatch) model.Settings {
	r.mu.Lock()
	defer r.mu.Unlock()

	settings, ok := r.settings[userID]
	if !ok {
		settings = defaultSettings(userID, "ru")
	}
	if patch.Language != nil {
		settings.Language = *patch.Language
	}
	if patch.Theme != nil {
		settings.Theme = *patch.Theme
	}
	if patch.City != nil {
		settings.City = *patch.City
	}
	if patch.CalculationMethod != nil {
		settings.CalculationMethod = *patch.CalculationMethod
	}
	if patch.Madhhab != nil {
		settings.Madhhab = *patch.Madhhab
	}
	if patch.AIMode != nil {
		settings.AIMode = *patch.AIMode
	}
	if patch.ActiveMentorMode != nil {
		settings.ActiveMentorMode = *patch.ActiveMentorMode
	}
	if patch.Notifications != nil {
		settings.Notifications = *patch.Notifications
	}
	if patch.TaskNotifications != nil {
		settings.TaskNotifications = *patch.TaskNotifications
	}
	if patch.HabitNotifications != nil {
		settings.HabitNotifications = *patch.HabitNotifications
	}
	if patch.PrayerNotifications != nil {
		settings.PrayerNotifications = *patch.PrayerNotifications
	}
	if patch.SoundEnabled != nil {
		settings.SoundEnabled = *patch.SoundEnabled
	}
	if patch.VibrationEnabled != nil {
		settings.VibrationEnabled = *patch.VibrationEnabled
	}
	if patch.QuietHoursEnabled != nil {
		settings.QuietHoursEnabled = *patch.QuietHoursEnabled
	}
	if patch.QuietHoursStart != nil {
		settings.QuietHoursStart = *patch.QuietHoursStart
	}
	if patch.QuietHoursEnd != nil {
		settings.QuietHoursEnd = *patch.QuietHoursEnd
	}
	if patch.MaxAIRemindersPerItem != nil {
		settings.MaxAIRemindersPerItem = *patch.MaxAIRemindersPerItem
	}
	r.settings[userID] = settings
	return settings
}

func (r *MemoryRepository) Stats(userID string, period string) model.Stats {
	r.mu.RLock()
	defer r.mu.RUnlock()

	today := time.Now().UTC().Format(time.DateOnly)
	tasksDone := 0
	tasksMissed := 0
	totalToday := 0
	mostMissedTask := ""

	for _, task := range r.tasks[userID] {
		if task.Date == today {
			totalToday++
			if task.IsCompleted {
				tasksDone++
			}
		}
		if task.Date < today && !task.IsCompleted {
			tasksMissed++
			if mostMissedTask == "" {
				mostMissedTask = task.Title
			}
		}
	}

	habitStreak := 0
	mostStableHabit := ""
	for _, habit := range r.habits[userID] {
		if habit.Streak > habitStreak {
			habitStreak = habit.Streak
			mostStableHabit = habit.Name
		}
	}

	completionRate := 0.0
	if totalToday > 0 {
		completionRate = float64(tasksDone) / float64(totalToday)
	}

	return model.Stats{
		Period:           fallback(period, "today"),
		TasksDoneToday:   tasksDone,
		TasksMissed:      tasksMissed,
		CompletionRate:   completionRate,
		WeeklyActivity:   []int{1, 2, 1, 3, tasksDone, 0, 0},
		TaskStreak:       simpleTaskStreak(r.tasks[userID]),
		HabitStreak:      habitStreak,
		PrayerStreak:     0,
		AppStreak:        max(tasksDone+habitStreak, 1),
		PerfectDayStreak: boolToInt(totalToday > 0 && tasksDone == totalToday),
		BestWeekday:      "Friday",
		MostStableHabit:  fallback(mostStableHabit, "No habit yet"),
		MostMissedTask:   fallback(mostMissedTask, "No missed task"),
	}
}

func (r *MemoryRepository) seed() {
	now := time.Now().UTC()
	userID := "user-dev"
	email := "aza@example.com"
	user := model.User{
		ID:        userID,
		Name:      "Aza",
		Email:     email,
		Language:  "ru",
		City:      "Qyzylorda",
		CreatedAt: now,
		UpdatedAt: now,
	}
	r.users[userID] = user
	r.userIDsByEmail[email] = userID
	r.passwords[userID] = "password"
	r.settings[userID] = defaultSettings(userID, "ru")
	r.tasks[userID] = map[string]model.Task{}
	r.habits[userID] = map[string]model.Habit{}
	r.notes[userID] = map[string]model.Note{}

	r.tasks[userID]["task-quran"] = model.Task{
		ID:              "task-quran",
		UserID:          userID,
		Title:           "Read Quran",
		Description:     "Read one page with focus.",
		Date:            now.Format(time.DateOnly),
		Time:            "07:30",
		IsCompleted:     false,
		Priority:        "high",
		Category:        "worship",
		ReminderEnabled: true,
		ReminderTime:    "07:20",
		RepeatType:      "daily",
		CreatedAt:       now,
		UpdatedAt:       now,
	}
	r.habits[userID]["habit-water"] = model.Habit{
		ID:              "habit-water",
		UserID:          userID,
		Name:            "Drink water",
		Description:     "Keep basic energy stable.",
		Category:        "health",
		Streak:          5,
		TargetPerDay:    1,
		CompletedToday:  false,
		ReminderEnabled: true,
		ReminderTime:    "09:00",
		CreatedAt:       now,
		UpdatedAt:       now,
	}
	r.notes[userID]["note-plan"] = model.Note{
		ID:         "note-plan",
		UserID:     userID,
		Title:      "Morning plan",
		Content:    "Close one worship task before noon.",
		Category:   "planning",
		Tags:       []string{"mvp"},
		IsPinned:   true,
		IsFavorite: false,
		CreatedAt:  now,
		UpdatedAt:  now,
	}
}

func defaultSettings(userID string, language string) model.Settings {
	return model.Settings{
		UserID:                userID,
		Language:              fallback(language, "ru"),
		Theme:                 "system",
		City:                  "Qyzylorda",
		CalculationMethod:     "Muslim World League",
		Madhhab:               "hanafi",
		AIMode:                "normal",
		ActiveMentorMode:      "normal",
		Notifications:         true,
		TaskNotifications:     true,
		HabitNotifications:    true,
		PrayerNotifications:   true,
		SoundEnabled:          true,
		VibrationEnabled:      true,
		QuietHoursEnabled:     false,
		QuietHoursStart:       "22:00",
		QuietHoursEnd:         "07:00",
		MaxAIRemindersPerItem: 2,
	}
}

func ensureMap[T any](storage map[string]map[string]T, userID string) {
	if _, ok := storage[userID]; !ok {
		storage[userID] = map[string]T{}
	}
}

func normalizeEmail(email string) string {
	return strings.ToLower(strings.TrimSpace(email))
}

func normalizeTags(tags []string) []string {
	result := make([]string, 0, len(tags))
	seen := map[string]struct{}{}
	for _, tag := range tags {
		tag = strings.TrimSpace(tag)
		if tag == "" {
			continue
		}
		key := strings.ToLower(tag)
		if _, ok := seen[key]; ok {
			continue
		}
		seen[key] = struct{}{}
		result = append(result, tag)
	}
	return result
}

func newID(prefix string) string {
	return fmt.Sprintf("%s_%d", prefix, time.Now().UnixNano())
}

func fallback(value string, fallbackValue string) string {
	if strings.TrimSpace(value) == "" {
		return fallbackValue
	}
	return strings.TrimSpace(value)
}

func max(a int, b int) int {
	if a > b {
		return a
	}
	return b
}

func min(a int, b int) int {
	if a < b {
		return a
	}
	return b
}

func boolToInt(value bool) int {
	if value {
		return 1
	}
	return 0
}

func simpleTaskStreak(tasks map[string]model.Task) int {
	if len(tasks) == 0 {
		return 0
	}
	byDate := map[string]bool{}
	for _, task := range tasks {
		if task.IsCompleted {
			byDate[task.Date] = true
		}
	}
	streak := 0
	cursor := time.Now().UTC()
	for {
		if !byDate[cursor.Format(time.DateOnly)] {
			return streak
		}
		streak++
		cursor = cursor.AddDate(0, 0, -1)
	}
}
