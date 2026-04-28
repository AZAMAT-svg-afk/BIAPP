# Baraka AI / Niyyah / ImanFlow

Mobile-first Flutter MVP for prayer-aware productivity: tasks, notes, habits, reminders, streaks, stats, Kazakhstan prayer times, and an AI mentor connected through a Go backend.

This project lives in a separate Desktop folder and does not modify the existing React project.

## Stack

- Flutter + Dart
- Riverpod
- Drift + SQLite local storage
- Flutter localization with Russian, English, and Kazakh ARB files
- `flutter_local_notifications` for local reminders
- `adhan_dart` for local prayer-time calculation
- `http` for backend API calls
- `flutter_animate` for lightweight motion
- `flutter_native_splash` and `flutter_launcher_icons`
- Go REST backend with in-memory storage and AI provider abstraction

## Structure

```text
lib/
  l10n/
  src/
    app/
    core/
      config/
      database/
      services/
      theme/
      widgets/
    features/
      active_mentor/
      ai/
      habits/
      home/
      notes/
      onboarding/
      prayer/
      settings/
      stats/
      streak/
      tasks/
backend_go/
  cmd/server/
  internal/config/
  internal/handler/
  internal/model/
  internal/repository/
  internal/service/
docs/
assets/branding/
```

## Run Flutter

```powershell
cd C:\Users\user\Desktop\baraka_ai_mobile
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze
flutter run
```

Android emulator uses the default backend URL:

```text
http://10.0.2.2:8080
```

Real phone on the same Wi-Fi:

```powershell
flutter run -d DEVICE_ID --dart-define=API_BASE_URL=http://YOUR_PC_IP:8080
```

## Run Go Backend

```powershell
cd C:\Users\user\Desktop\baraka_ai_mobile\backend_go
$env:AI_PROVIDER="mock"
$env:PORT="8080"
go run ./cmd/server
```

Backend health:

```powershell
curl.exe http://localhost:8080/health
```

## AI Providers

Flutter never stores AI keys. Flutter calls only:

```text
POST /ai/chat
```

The Go backend selects the provider via environment variables.

Mock:

```powershell
$env:AI_PROVIDER="mock"
go run ./cmd/server
```

OpenAI-compatible:

```powershell
$env:AI_PROVIDER="openai"
$env:OPENAI_API_KEY="your_key_here"
$env:AI_MODEL="your_model_here"
go run ./cmd/server
```

Hugging Face / Qwen:

```powershell
$env:AI_PROVIDER="qwen"
$env:HUGGINGFACE_API_KEY="your_hf_key_here"
$env:AI_MODEL="Qwen/Qwen3.6-35B-A3B"
go run ./cmd/server
```

Do not commit real keys. Use `backend_go/.env.example` as a template only.

## Branding, Splash, And Icons

Temporary branding assets live in `assets/branding/`:

- `app_icon.png`
- `app_icon_foreground.png`
- `splash_logo.png`

Regenerate launcher icons:

```powershell
dart run flutter_launcher_icons
```

Regenerate native splash:

```powershell
dart run flutter_native_splash:create
```

To replace the placeholder icon, put your final PNG assets into `assets/branding/`, keep the same names or update `pubspec.yaml`, then rerun both commands.

## Ready Now

- Premium app shell with fixed 5-item bottom navigation
- Tasks CRUD with local SQLite, premium cards, and safe bottom-sheet add/edit flow
- Notes, habits, settings, streaks, and stats on local storage
- Notifications service for tasks, habits, prayer, motivation, daily summary, and AI reminders
- AI chat screen with backend `AiService`, `AiContextBuilder`, loading/error states, and AI mode settings
- Active AI mentor policy skeleton with quiet hours and max reminder limits
- Kazakhstan prayer city aliases and local `adhan_dart` calculation with Hanafi/Shafi Asr support
- Go backend endpoints for auth, tasks, habits, notes, stats, AI, and settings
- AI providers: `mock`, `openai`, `huggingface`, `qwen`

## Android Notification Permissions

The app includes Android manifest setup for:

- `POST_NOTIFICATIONS`
- `VIBRATE`
- `RECEIVE_BOOT_COMPLETED`
- `SCHEDULE_EXACT_ALARM`
- scheduled notification receivers

Current MVP uses inexact scheduling. Before exact alarms, request exact alarm permission in `NotificationService.requestExactAlarmPermission()` and test on Android 12+.

## Quality Commands

```powershell
flutter pub get
flutter gen-l10n
dart format lib test
flutter analyze
flutter test
```

```powershell
cd backend_go
gofmt -w .
go test ./...
go run ./cmd/server
```

## Roadmap

See [docs/ROADMAP.md](docs/ROADMAP.md).
