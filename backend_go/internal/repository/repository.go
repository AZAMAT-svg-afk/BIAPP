package repository

import "github.com/imanflow/baraka-ai/backend_go/internal/model"

type Repository interface {
	CreateUser(input model.RegisterRequest) (model.User, error)
	FindUserByEmail(email string) (model.User, string, bool)
	UserByID(userID string) (model.User, bool)
	UpdateUser(userID string, input model.UserUpdateRequest) (model.User, bool)

	ListTasks(userID string) []model.Task
	CreateTask(userID string, input model.Task) model.Task
	UpdateTask(userID string, taskID string, input model.Task) (model.Task, bool)
	DeleteTask(userID string, taskID string) bool
	CompleteTask(userID string, taskID string) (model.Task, bool)

	ListHabits(userID string) []model.Habit
	CreateHabit(userID string, input model.Habit) model.Habit
	UpdateHabit(userID string, habitID string, input model.Habit) (model.Habit, bool)
	DeleteHabit(userID string, habitID string) bool
	CheckHabit(userID string, habitID string) (model.Habit, bool)

	ListNotes(userID string) []model.Note
	CreateNote(userID string, input model.Note) model.Note
	UpdateNote(userID string, noteID string, input model.Note) (model.Note, bool)
	DeleteNote(userID string, noteID string) bool

	Settings(userID string) model.Settings
	UpdateSettings(userID string, patch model.SettingsPatch) model.Settings

	Stats(userID string, period string) model.Stats
}
