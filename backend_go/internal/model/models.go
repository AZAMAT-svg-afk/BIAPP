package model

import "time"

type User struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Language  string    `json:"language"`
	City      string    `json:"city"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type RegisterRequest struct {
	Name     string `json:"name"`
	Email    string `json:"email"`
	Password string `json:"password"`
	Language string `json:"language"`
}

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RefreshRequest struct {
	RefreshToken string `json:"refresh_token"`
}

type UserUpdateRequest struct {
	Name     *string `json:"name,omitempty"`
	Language *string `json:"language,omitempty"`
	City     *string `json:"city,omitempty"`
}

type AuthResponse struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	TokenType    string `json:"token_type"`
	ExpiresIn    int64  `json:"expires_in"`
	User         User   `json:"user"`
}

type Task struct {
	ID              string     `json:"id"`
	UserID          string     `json:"-"`
	Title           string     `json:"title"`
	Description     string     `json:"description"`
	Date            string     `json:"date"`
	Time            string     `json:"time,omitempty"`
	IsCompleted     bool       `json:"is_completed"`
	Priority        string     `json:"priority"`
	Category        string     `json:"category"`
	ReminderEnabled bool       `json:"reminder_enabled"`
	ReminderTime    string     `json:"reminder_time,omitempty"`
	RepeatType      string     `json:"repeat_type"`
	CompletedAt     *time.Time `json:"completed_at,omitempty"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`
}

type Habit struct {
	ID              string     `json:"id"`
	UserID          string     `json:"-"`
	Name            string     `json:"name"`
	Description     string     `json:"description"`
	Category        string     `json:"category"`
	Streak          int        `json:"streak"`
	TargetPerDay    int        `json:"target_per_day"`
	CompletedCount  int        `json:"completed_count"`
	CompletedToday  bool       `json:"completed_today"`
	ReminderEnabled bool       `json:"reminder_enabled"`
	ReminderTime    string     `json:"reminder_time,omitempty"`
	LastCheckedAt   *time.Time `json:"last_checked_at,omitempty"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`
}

type Note struct {
	ID         string    `json:"id"`
	UserID     string    `json:"-"`
	Title      string    `json:"title"`
	Content    string    `json:"content"`
	Category   string    `json:"category"`
	Tags       []string  `json:"tags"`
	IsPinned   bool      `json:"is_pinned"`
	IsFavorite bool      `json:"is_favorite"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}

type Settings struct {
	UserID                string `json:"-"`
	Language              string `json:"language"`
	Theme                 string `json:"theme"`
	City                  string `json:"city"`
	CalculationMethod     string `json:"calculation_method"`
	Madhhab               string `json:"madhhab"`
	AIMode                string `json:"ai_mode"`
	ActiveMentorMode      string `json:"active_mentor_mode"`
	Notifications         bool   `json:"notifications"`
	TaskNotifications     bool   `json:"task_notifications"`
	HabitNotifications    bool   `json:"habit_notifications"`
	PrayerNotifications   bool   `json:"prayer_notifications"`
	SoundEnabled          bool   `json:"sound_enabled"`
	VibrationEnabled      bool   `json:"vibration_enabled"`
	QuietHoursEnabled     bool   `json:"quiet_hours_enabled"`
	QuietHoursStart       string `json:"quiet_hours_start"`
	QuietHoursEnd         string `json:"quiet_hours_end"`
	MaxAIRemindersPerItem int    `json:"max_ai_reminders_per_item"`
}

type SettingsPatch struct {
	Language              *string `json:"language,omitempty"`
	Theme                 *string `json:"theme,omitempty"`
	City                  *string `json:"city,omitempty"`
	CalculationMethod     *string `json:"calculation_method,omitempty"`
	Madhhab               *string `json:"madhhab,omitempty"`
	AIMode                *string `json:"ai_mode,omitempty"`
	ActiveMentorMode      *string `json:"active_mentor_mode,omitempty"`
	Notifications         *bool   `json:"notifications,omitempty"`
	TaskNotifications     *bool   `json:"task_notifications,omitempty"`
	HabitNotifications    *bool   `json:"habit_notifications,omitempty"`
	PrayerNotifications   *bool   `json:"prayer_notifications,omitempty"`
	SoundEnabled          *bool   `json:"sound_enabled,omitempty"`
	VibrationEnabled      *bool   `json:"vibration_enabled,omitempty"`
	QuietHoursEnabled     *bool   `json:"quiet_hours_enabled,omitempty"`
	QuietHoursStart       *string `json:"quiet_hours_start,omitempty"`
	QuietHoursEnd         *string `json:"quiet_hours_end,omitempty"`
	MaxAIRemindersPerItem *int    `json:"max_ai_reminders_per_item,omitempty"`
}

type Stats struct {
	Period           string         `json:"period"`
	TasksDoneToday   int            `json:"tasks_done_today"`
	TasksMissed      int            `json:"tasks_missed"`
	CompletionRate   float64        `json:"completion_rate"`
	WeeklyActivity   []int          `json:"weekly_activity"`
	TaskStreak       int            `json:"task_streak"`
	HabitStreak      int            `json:"habit_streak"`
	PrayerStreak     int            `json:"prayer_streak"`
	AppStreak        int            `json:"app_streak"`
	PerfectDayStreak int            `json:"perfect_day_streak"`
	BestWeekday      string         `json:"best_weekday"`
	MostStableHabit  string         `json:"most_stable_habit"`
	MostMissedTask   string         `json:"most_missed_task"`
	Additional       map[string]any `json:"additional,omitempty"`
}
