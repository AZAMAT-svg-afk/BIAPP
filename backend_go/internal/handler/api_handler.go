package handler

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"

	"github.com/imanflow/baraka-ai/backend_go/internal/middleware"
	"github.com/imanflow/baraka-ai/backend_go/internal/model"
	"github.com/imanflow/baraka-ai/backend_go/internal/service"
	"github.com/imanflow/baraka-ai/backend_go/pkg/response"
)

type APIHandler struct {
	services service.Container
}

func NewAPIHandler(services service.Container) APIHandler {
	return APIHandler{services: services}
}

func (h APIHandler) Routes() http.Handler {
	mux := http.NewServeMux()

	mux.HandleFunc("GET /health", h.health)
	mux.HandleFunc("POST /auth/register", h.register)
	mux.HandleFunc("POST /auth/login", h.login)
	mux.HandleFunc("POST /auth/refresh", h.refresh)

	mux.Handle("GET /user/me", h.protected(h.userMe))
	mux.Handle("PUT /user/me", h.protected(h.updateUser))

	mux.Handle("GET /tasks", h.protected(h.listTasks))
	mux.Handle("POST /tasks", h.protected(h.createTask))
	mux.Handle("PUT /tasks/{id}", h.protected(h.updateTask))
	mux.Handle("DELETE /tasks/{id}", h.protected(h.deleteTask))
	mux.Handle("PATCH /tasks/{id}/complete", h.protected(h.completeTask))

	mux.Handle("GET /habits", h.protected(h.listHabits))
	mux.Handle("POST /habits", h.protected(h.createHabit))
	mux.Handle("PUT /habits/{id}", h.protected(h.updateHabit))
	mux.Handle("DELETE /habits/{id}", h.protected(h.deleteHabit))
	mux.Handle("PATCH /habits/{id}/check", h.protected(h.checkHabit))

	mux.Handle("GET /notes", h.protected(h.listNotes))
	mux.Handle("POST /notes", h.protected(h.createNote))
	mux.Handle("PUT /notes/{id}", h.protected(h.updateNote))
	mux.Handle("DELETE /notes/{id}", h.protected(h.deleteNote))

	mux.Handle("GET /stats/today", h.protected(h.statsToday))
	mux.Handle("GET /stats/week", h.protected(h.statsWeek))
	mux.Handle("GET /stats/month", h.protected(h.statsMonth))

	mux.HandleFunc("POST /ai/chat", h.aiChat)
	mux.Handle("POST /ai/daily-summary", h.protected(h.aiDailySummary))
	mux.Handle("POST /ai/motivation", h.protected(h.aiMotivation))
	mux.Handle("POST /ai/task-suggestions", h.protected(h.aiTaskSuggestions))

	mux.Handle("GET /settings", h.protected(h.settings))
	mux.Handle("PUT /settings", h.protected(h.updateSettings))

	return mux
}

func (h APIHandler) protected(fn http.HandlerFunc) http.Handler {
	return middleware.JWTAuth(h.services.Config.JWTSecret, fn)
}

func (h APIHandler) health(w http.ResponseWriter, r *http.Request) {
	response.JSON(w, http.StatusOK, map[string]any{
		"ok":          true,
		"service":     "baraka-ai-backend",
		"environment": h.services.Config.Environment,
	})
}

func (h APIHandler) register(w http.ResponseWriter, r *http.Request) {
	input, ok := decodeJSON[model.RegisterRequest](w, r)
	if !ok {
		return
	}

	auth, err := h.services.Auth.Register(input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusCreated, auth)
}

func (h APIHandler) login(w http.ResponseWriter, r *http.Request) {
	input, ok := decodeJSON[model.LoginRequest](w, r)
	if !ok {
		return
	}

	auth, err := h.services.Auth.Login(input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, auth)
}

func (h APIHandler) refresh(w http.ResponseWriter, r *http.Request) {
	input, ok := decodeJSON[model.RefreshRequest](w, r)
	if !ok {
		return
	}

	auth, err := h.services.Auth.Refresh(input.RefreshToken)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, auth)
}

func (h APIHandler) userMe(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}

	user, err := h.services.Users.Me(userID)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, user)
}

func (h APIHandler) updateUser(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	input, ok := decodeJSON[model.UserUpdateRequest](w, r)
	if !ok {
		return
	}

	user, err := h.services.Users.Update(userID, input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, user)
}

func (h APIHandler) listTasks(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	response.JSON(w, http.StatusOK, h.services.Tasks.List(userID))
}

func (h APIHandler) createTask(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	input, ok := decodeJSON[model.Task](w, r)
	if !ok {
		return
	}

	task, err := h.services.Tasks.Create(userID, input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusCreated, task)
}

func (h APIHandler) updateTask(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	input, ok := decodeJSON[model.Task](w, r)
	if !ok {
		return
	}

	task, err := h.services.Tasks.Update(userID, r.PathValue("id"), input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, task)
}

func (h APIHandler) deleteTask(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	if err := h.services.Tasks.Delete(userID, r.PathValue("id")); err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, map[string]bool{"ok": true})
}

func (h APIHandler) completeTask(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	task, err := h.services.Tasks.Complete(userID, r.PathValue("id"))
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, task)
}

func (h APIHandler) listHabits(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	response.JSON(w, http.StatusOK, h.services.Habits.List(userID))
}

func (h APIHandler) createHabit(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	input, ok := decodeJSON[model.Habit](w, r)
	if !ok {
		return
	}

	habit, err := h.services.Habits.Create(userID, input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusCreated, habit)
}

func (h APIHandler) updateHabit(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	input, ok := decodeJSON[model.Habit](w, r)
	if !ok {
		return
	}

	habit, err := h.services.Habits.Update(userID, r.PathValue("id"), input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, habit)
}

func (h APIHandler) deleteHabit(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	if err := h.services.Habits.Delete(userID, r.PathValue("id")); err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, map[string]bool{"ok": true})
}

func (h APIHandler) checkHabit(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	habit, err := h.services.Habits.Check(userID, r.PathValue("id"))
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, habit)
}

func (h APIHandler) listNotes(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	response.JSON(w, http.StatusOK, h.services.Notes.List(userID))
}

func (h APIHandler) createNote(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	input, ok := decodeJSON[model.Note](w, r)
	if !ok {
		return
	}

	note, err := h.services.Notes.Create(userID, input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusCreated, note)
}

func (h APIHandler) updateNote(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	input, ok := decodeJSON[model.Note](w, r)
	if !ok {
		return
	}

	note, err := h.services.Notes.Update(userID, r.PathValue("id"), input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, note)
}

func (h APIHandler) deleteNote(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	if err := h.services.Notes.Delete(userID, r.PathValue("id")); err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, map[string]bool{"ok": true})
}

func (h APIHandler) statsToday(w http.ResponseWriter, r *http.Request) {
	h.writeStats(w, r, "today")
}

func (h APIHandler) statsWeek(w http.ResponseWriter, r *http.Request) {
	h.writeStats(w, r, "week")
}

func (h APIHandler) statsMonth(w http.ResponseWriter, r *http.Request) {
	h.writeStats(w, r, "month")
}

func (h APIHandler) writeStats(w http.ResponseWriter, r *http.Request, period string) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	response.JSON(w, http.StatusOK, h.services.Stats.Snapshot(userID, period))
}

func (h APIHandler) aiChat(w http.ResponseWriter, r *http.Request) {
	input, ok := decodeJSON[model.ChatRequest](w, r)
	if !ok {
		return
	}
	output, err := h.services.AI.Chat(r.Context(), input)
	if err != nil {
		writeServiceError(w, err)
		return
	}
	response.JSON(w, http.StatusOK, output)
}

func (h APIHandler) aiDailySummary(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	response.JSON(w, http.StatusOK, h.services.AI.DailySummary(userID))
}

func (h APIHandler) aiMotivation(w http.ResponseWriter, r *http.Request) {
	response.JSON(w, http.StatusOK, h.services.AI.Motivation())
}

func (h APIHandler) aiTaskSuggestions(w http.ResponseWriter, r *http.Request) {
	response.JSON(w, http.StatusOK, h.services.AI.TaskSuggestions())
}

func (h APIHandler) settings(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	response.JSON(w, http.StatusOK, h.services.Settings.Get(userID))
}

func (h APIHandler) updateSettings(w http.ResponseWriter, r *http.Request) {
	userID, ok := requireUserID(w, r)
	if !ok {
		return
	}
	input, ok := decodeJSON[model.SettingsPatch](w, r)
	if !ok {
		return
	}
	response.JSON(w, http.StatusOK, h.services.Settings.Update(userID, input))
}

func decodeJSON[T any](w http.ResponseWriter, r *http.Request) (T, bool) {
	var input T
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&input); err != nil {
		response.Error(w, http.StatusBadRequest, "invalid json")
		return input, false
	}
	return input, true
}

func requireUserID(w http.ResponseWriter, r *http.Request) (string, bool) {
	userID, ok := middleware.UserIDFromContext(r.Context())
	if !ok {
		response.Error(w, http.StatusUnauthorized, "missing user context")
		return "", false
	}
	return userID, true
}

func writeServiceError(w http.ResponseWriter, err error) {
	log.Printf("service error: %v", err)

	switch {
	case errors.Is(err, service.ErrInvalidCredentials):
		response.Error(w, http.StatusUnauthorized, "invalid credentials")
	case errors.Is(err, service.ErrInvalidInput):
		response.Error(w, http.StatusBadRequest, "invalid input")
	case errors.Is(err, service.ErrConflict):
		response.Error(w, http.StatusConflict, "resource already exists")
	case errors.Is(err, service.ErrNotFound):
		response.Error(w, http.StatusNotFound, "not found")
	case errors.Is(err, service.ErrProviderConfig):
		response.JSON(w, http.StatusServiceUnavailable, map[string]any{
			"error":   "ai_provider_not_configured",
			"message": err.Error(),
		})
	case errors.Is(err, service.ErrProviderFailure):
		response.JSON(w, http.StatusBadGateway, map[string]any{
			"error":   "ai_provider_request_failed",
			"message": err.Error(),
		})
	default:
		response.JSON(w, http.StatusInternalServerError, map[string]any{
			"error":   "internal_server_error",
			"message": err.Error(),
		})
	}
}
