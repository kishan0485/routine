# Routine — AI-Powered Daily Life Assistant

A modern Flutter app for Indian users combining habits, AI coaching, health tracking, and focus tools.

## Features
- **AI Life Coach** — Gemini-powered chat for diet, fitness, study & motivation
- **Habit Tracker** — Streaks, XP gamification, daily completion
- **Food Scanner** — AI-powered calorie & nutrition detection for Indian meals
- **Pomodoro Focus** — Deep work timer with session tracking
- **Morning/Night Routines** — Step-by-step checklist templates

## Tech Stack
| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Material 3) |
| State Management | Riverpod |
| Navigation | go_router |
| Backend | Firebase (Auth, Firestore, FCM) |
| AI | Google Gemini API |
| Payments | Razorpay |

## Setup

### 1. Flutter & Dependencies
```bash
flutter pub get
```

### 2. Firebase Setup
1. Create a Firebase project at console.firebase.google.com
2. Add Android app with package ID `com.routineapp.routine`
3. Download `google-services.json` → place in `android/app/`
4. Run: `dart pub global activate flutterfire_cli && flutterfire configure`

### 3. Gemini API Key
Open `lib/services/gemini_service.dart` and replace:
```dart
static const String _apiKey = 'YOUR_GEMINI_API_KEY';
```
Get your key at: aistudio.google.com

### 4. Run
```bash
flutter run
```

## Pricing
| Plan | Price |
|------|-------|
| Free | ₹0 — 5 AI chats/day, basic features |
| Premium | ₹49/month — Unlimited AI, all features |
| Yearly | ₹399/year — Best value (save 32%) |

## Project Structure
```
lib/
├── core/          # Theme, router, shared widgets
├── features/      # Home, AI Chat, Health, Routine, Focus
├── models/        # Data models
└── services/      # Gemini, Auth, Notifications
```
