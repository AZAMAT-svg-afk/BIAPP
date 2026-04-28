package service

import (
	"errors"
	"strings"
	"time"

	"github.com/imanflow/baraka-ai/backend_go/internal/config"
	"github.com/imanflow/baraka-ai/backend_go/internal/model"
	"github.com/imanflow/baraka-ai/backend_go/internal/repository"
	"github.com/imanflow/baraka-ai/backend_go/pkg/token"
)

var (
	ErrInvalidCredentials = errors.New("invalid credentials")
	ErrInvalidInput       = errors.New("invalid input")
	ErrNotFound           = errors.New("not found")
	ErrConflict           = errors.New("conflict")
	ErrProviderConfig     = errors.New("ai provider configuration error")
	ErrProviderFailure    = errors.New("ai provider failure")
)

type Container struct {
	Auth     AuthService
	Users    UserService
	Tasks    TaskService
	Habits   HabitService
	Notes    NoteService
	Stats    StatsService
	AI       AIService
	Settings SettingsService
	Config   config.Config
}

func NewContainer(repo repository.Repository, cfg config.Config) Container {
	return Container{
		Auth:     AuthService{cfg: cfg, repo: repo},
		Users:    UserService{repo: repo},
		Tasks:    TaskService{repo: repo},
		Habits:   HabitService{repo: repo},
		Notes:    NoteService{repo: repo},
		Stats:    StatsService{repo: repo},
		AI:       NewAIService(cfg),
		Settings: SettingsService{repo: repo},
		Config:   cfg,
	}
}

type AuthService struct {
	cfg  config.Config
	repo repository.Repository
}

func (s AuthService) Register(input model.RegisterRequest) (model.AuthResponse, error) {
	input.Email = strings.TrimSpace(strings.ToLower(input.Email))
	if input.Email == "" || input.Password == "" {
		return model.AuthResponse{}, ErrInvalidInput
	}

	user, err := s.repo.CreateUser(input)
	if err != nil {
		if errors.Is(err, repository.ErrEmailExists) {
			return model.AuthResponse{}, ErrConflict
		}
		return model.AuthResponse{}, err
	}
	return s.tokenPair(user)
}

func (s AuthService) Login(input model.LoginRequest) (model.AuthResponse, error) {
	user, password, ok := s.repo.FindUserByEmail(input.Email)
	if !ok || password != input.Password {
		return model.AuthResponse{}, ErrInvalidCredentials
	}
	return s.tokenPair(user)
}

func (s AuthService) Refresh(refreshToken string) (model.AuthResponse, error) {
	claims, err := token.Validate(s.cfg.JWTSecret, refreshToken)
	if err != nil || claims.Type != "refresh" {
		return model.AuthResponse{}, ErrInvalidCredentials
	}
	user, ok := s.repo.UserByID(claims.Subject)
	if !ok {
		return model.AuthResponse{}, ErrInvalidCredentials
	}
	return s.tokenPair(user)
}

func (s AuthService) tokenPair(user model.User) (model.AuthResponse, error) {
	accessToken, err := token.Generate(s.cfg.JWTSecret, user.ID, "access", 15*time.Minute)
	if err != nil {
		return model.AuthResponse{}, err
	}
	refreshToken, err := token.Generate(s.cfg.JWTSecret, user.ID, "refresh", 30*24*time.Hour)
	if err != nil {
		return model.AuthResponse{}, err
	}
	return model.AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		TokenType:    "Bearer",
		ExpiresIn:    int64((15 * time.Minute).Seconds()),
		User:         user,
	}, nil
}

type UserService struct {
	repo repository.Repository
}

func (s UserService) Me(userID string) (model.User, error) {
	user, ok := s.repo.UserByID(userID)
	if !ok {
		return model.User{}, ErrNotFound
	}
	return user, nil
}

func (s UserService) Update(userID string, input model.UserUpdateRequest) (model.User, error) {
	user, ok := s.repo.UpdateUser(userID, input)
	if !ok {
		return model.User{}, ErrNotFound
	}
	return user, nil
}

type TaskService struct {
	repo repository.Repository
}

func (s TaskService) List(userID string) []model.Task {
	return s.repo.ListTasks(userID)
}

func (s TaskService) Create(userID string, input model.Task) (model.Task, error) {
	if strings.TrimSpace(input.Title) == "" {
		return model.Task{}, ErrInvalidInput
	}
	return s.repo.CreateTask(userID, input), nil
}

func (s TaskService) Update(userID string, taskID string, input model.Task) (model.Task, error) {
	if strings.TrimSpace(input.Title) == "" {
		return model.Task{}, ErrInvalidInput
	}
	task, ok := s.repo.UpdateTask(userID, taskID, input)
	if !ok {
		return model.Task{}, ErrNotFound
	}
	return task, nil
}

func (s TaskService) Delete(userID string, taskID string) error {
	if !s.repo.DeleteTask(userID, taskID) {
		return ErrNotFound
	}
	return nil
}

func (s TaskService) Complete(userID string, taskID string) (model.Task, error) {
	task, ok := s.repo.CompleteTask(userID, taskID)
	if !ok {
		return model.Task{}, ErrNotFound
	}
	return task, nil
}

type HabitService struct {
	repo repository.Repository
}

func (s HabitService) List(userID string) []model.Habit {
	return s.repo.ListHabits(userID)
}

func (s HabitService) Create(userID string, input model.Habit) (model.Habit, error) {
	if strings.TrimSpace(input.Name) == "" {
		return model.Habit{}, ErrInvalidInput
	}
	return s.repo.CreateHabit(userID, input), nil
}

func (s HabitService) Update(userID string, habitID string, input model.Habit) (model.Habit, error) {
	if strings.TrimSpace(input.Name) == "" {
		return model.Habit{}, ErrInvalidInput
	}
	habit, ok := s.repo.UpdateHabit(userID, habitID, input)
	if !ok {
		return model.Habit{}, ErrNotFound
	}
	return habit, nil
}

func (s HabitService) Delete(userID string, habitID string) error {
	if !s.repo.DeleteHabit(userID, habitID) {
		return ErrNotFound
	}
	return nil
}

func (s HabitService) Check(userID string, habitID string) (model.Habit, error) {
	habit, ok := s.repo.CheckHabit(userID, habitID)
	if !ok {
		return model.Habit{}, ErrNotFound
	}
	return habit, nil
}

type NoteService struct {
	repo repository.Repository
}

func (s NoteService) List(userID string) []model.Note {
	return s.repo.ListNotes(userID)
}

func (s NoteService) Create(userID string, input model.Note) (model.Note, error) {
	if strings.TrimSpace(input.Title) == "" && strings.TrimSpace(input.Content) == "" {
		return model.Note{}, ErrInvalidInput
	}
	return s.repo.CreateNote(userID, input), nil
}

func (s NoteService) Update(userID string, noteID string, input model.Note) (model.Note, error) {
	if strings.TrimSpace(input.Title) == "" && strings.TrimSpace(input.Content) == "" {
		return model.Note{}, ErrInvalidInput
	}
	note, ok := s.repo.UpdateNote(userID, noteID, input)
	if !ok {
		return model.Note{}, ErrNotFound
	}
	return note, nil
}

func (s NoteService) Delete(userID string, noteID string) error {
	if !s.repo.DeleteNote(userID, noteID) {
		return ErrNotFound
	}
	return nil
}

type StatsService struct {
	repo repository.Repository
}

func (s StatsService) Snapshot(userID string, period string) model.Stats {
	return s.repo.Stats(userID, period)
}

type SettingsService struct {
	repo repository.Repository
}

func (s SettingsService) Get(userID string) model.Settings {
	return s.repo.Settings(userID)
}

func (s SettingsService) Update(userID string, patch model.SettingsPatch) model.Settings {
	return s.repo.UpdateSettings(userID, patch)
}
