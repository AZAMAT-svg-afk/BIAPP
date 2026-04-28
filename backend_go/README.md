# Baraka AI Backend

Go REST API for the Baraka AI / Niyyah / ImanFlow Flutter app.

The current backend uses in-memory storage for MVP development. The handler, service, model, and repository layers are separated so PostgreSQL can be added later without changing the Flutter API contract.

## Stack

- Go standard library HTTP server
- REST API
- In-memory repository
- CORS middleware
- JWT middleware for protected CRUD endpoints
- AI provider abstraction: `mock`, `openai`, `huggingface`, `qwen`
- PostgreSQL-ready repository boundary

## Structure

```text
backend_go/
  cmd/server/main.go
  internal/
    config/
    database/
    handler/
    middleware/
    model/
    repository/
    service/
      ai_service.go
      ai_provider_mock.go
      ai_provider_openai.go
      ai_provider_huggingface.go
      ai_prompt_builder.go
  pkg/
    response/
    token/
```

## Run

```powershell
cd C:\Users\user\Desktop\baraka_ai_mobile\backend_go
$env:AI_PROVIDER="mock"
$env:PORT="8080"
go run ./cmd/server
```

Default server:

```text
http://localhost:8080
```

Health check:

```powershell
curl.exe http://localhost:8080/health
```

## Test And Format

```powershell
gofmt -w .
go test ./...
```

## Environment

Copy `.env.example` values into your shell or local `.env` loader. Do not commit real keys.

```text
PORT=8080
AI_PROVIDER=mock
AI_MODEL=Qwen/Qwen3.6-35B-A3B
OPENAI_API_KEY=your_openai_key_here
HUGGINGFACE_API_KEY=your_huggingface_key_here
```

Other supported variables:

```text
HTTP_ADDR=:8080
JWT_SECRET=dev-change-me
DATABASE_URL=memory://local
CORS_ALLOWED_ORIGIN=*
APP_ENV=development
```

## AI Providers

Mock:

```powershell
$env:AI_PROVIDER="mock"
go run ./cmd/server
```

OpenAI:

```powershell
$env:AI_PROVIDER="openai"
$env:OPENAI_API_KEY="your_key_here"
$env:AI_MODEL="your_model_here"
go run ./cmd/server
```

Hugging Face:

```powershell
$env:AI_PROVIDER="huggingface"
$env:HUGGINGFACE_API_KEY="your_hf_key_here"
$env:AI_MODEL="provider/model-name"
go run ./cmd/server
```

Qwen through Hugging Face:

```powershell
$env:AI_PROVIDER="qwen"
$env:HUGGINGFACE_API_KEY="your_hf_key_here"
$env:AI_MODEL="Qwen/Qwen3.6-35B-A3B"
go run ./cmd/server
```

## Public Endpoints

- `GET /health`
- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/refresh`
- `POST /ai/chat`

## Protected Endpoints

Use `Authorization: Bearer <access_token>`.

- `GET /user/me`
- `PUT /user/me`
- `GET /tasks`
- `POST /tasks`
- `PUT /tasks/{id}`
- `DELETE /tasks/{id}`
- `PATCH /tasks/{id}/complete`
- `GET /habits`
- `POST /habits`
- `PUT /habits/{id}`
- `DELETE /habits/{id}`
- `PATCH /habits/{id}/check`
- `GET /notes`
- `POST /notes`
- `PUT /notes/{id}`
- `DELETE /notes/{id}`
- `GET /stats/today`
- `GET /stats/week`
- `GET /stats/month`
- `POST /ai/daily-summary`
- `POST /ai/motivation`
- `POST /ai/task-suggestions`
- `GET /settings`
- `PUT /settings`

## AI Chat Payload

```json
{
  "message": "Мне лень",
  "language": "ru",
  "aiMode": "normal",
  "userContext": {
    "name": "Sultan",
    "todayTasks": [],
    "completedTasks": [],
    "missedTasks": [],
    "habits": [],
    "streaks": {},
    "nextPrayer": {
      "name": "Maghrib",
      "time": "18:10"
    },
    "weeklyStats": {},
    "mood": null
  },
  "history": []
}
```

Response:

```json
{
  "reply": "...",
  "provider": "mock",
  "model": ""
}
```

## Dev Auth

Seeded test user:

```text
email: aza@example.com
password: password
```

Login:

```powershell
curl.exe -X POST http://localhost:8080/auth/login `
  -H "Content-Type: application/json" `
  -d "{\"email\":\"aza@example.com\",\"password\":\"password\"}"
```

## Next Backend Steps

- Add request validation per endpoint.
- Replace plaintext dev passwords with password hashing.
- Add PostgreSQL migrations and `PostgresRepository`.
- Add handler and repository tests.
- Add streaming AI responses if needed.
