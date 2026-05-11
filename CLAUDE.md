# Routine App — Claude Code Guide

## Project Overview
AI-powered daily life assistant Flutter app targeting Indian users (16–30: students, gym beginners, young professionals).

**GitHub:** github.com/kishan0485/routine  
**Package ID:** `com.routineapp.routine`  
**Flutter:** 3.41.9 (installed at `~/development/flutter/`)

## Running the App

```bash
# Web preview (hot reload active)
cd ~/routine && flutter run -d chrome --web-port 8080

# Android/iOS (after Firebase setup)
flutter run

# Analyze
flutter analyze

# Install packages after pubspec changes
flutter pub get
```

## Architecture

**Pattern:** Feature-based, no generated code (no build_runner needed for features)  
**State:** Riverpod (`flutter_riverpod`)  
**Navigation:** go_router with ShellRoute (5-tab bottom nav)  
**AI:** Gemini API via `google_generative_ai` package

```
lib/
├── core/
│   ├── theme/          # AppColors, AppTextStyles, AppTheme
│   ├── router/         # app_router.dart — all routes defined here
│   ├── constants/      # app_constants.dart, api_keys.dart (gitignored)
│   └── widgets/        # GlassCard, GradientButton, AppShell, StreakBadge
├── features/
│   ├── auth/           # splash, onboarding (3 slides), login
│   ├── home/           # HomeScreen + TaskCard, WaterWidget, StatChip, AISuggestionCard
│   ├── ai_chat/        # AIChatScreen + MessageBubble
│   ├── health/         # HealthScreen (CalorieTab + FoodScannerTab)
│   ├── routine/        # RoutineScreen (HabitsTab + Morning/Night tabs) + HabitCard
│   └── focus/          # FocusScreen (Pomodoro timer)
├── models/             # UserModel, HabitModel, TaskModel, MealModel
├── services/           # GeminiService (text + vision)
└── main.dart
```

## Design System

**Theme:** Material 3, dark mode default  
**Primary:** `#7C3AED` (violet) — `AppColors.primary`  
**Accent:** `#06B6D4` (cyan) — `AppColors.accent`  
**Background:** `#0F0F1A` — `AppColors.bgDark`  
**Surface:** `#1A1A2E` — `AppColors.surfaceDark`  
**Success:** `#10B981` — `AppColors.success`

**Fonts:** `GoogleFonts.plusJakartaSans()` for headings, `GoogleFonts.inter()` for body  
**Cards:** Always use `GlassCard` widget (glassmorphism with backdrop blur)  
**Buttons:** Use `GradientButton` for primary CTAs  
**Animations:** `animate_do` package (`FadeInDown`, `FadeInUp`, `FadeIn`)

All colors are in `lib/core/theme/app_colors.dart`.  
All text styles are in `lib/core/theme/app_text_styles.dart`.

## Key Conventions

- **`withOpacity` is deprecated** — always use `.withValues(alpha: x)` instead
- **No hardcoded colors** — use `AppColors.*` constants only
- **No hardcoded text styles** — use `AppTextStyles.*` only
- **Gradients:** `AppColors.primaryGradient`, `accentGradient`, `greenGradient`, `orangeGradient`
- **Icons:** Use `Icons.*_rounded` variants for consistency
- Never import `package:flutter/material.dart` in router — not needed there

## API Keys & Secrets

```
lib/core/constants/api_keys.dart   ← GITIGNORED, never commit
android/app/google-services.json   ← GITIGNORED, add after Firebase setup
```

Gemini key is in `ApiKeys.gemini` (imported by `GeminiService`).

## Free vs Premium Gates

```dart
// lib/core/constants/app_constants.dart
static const int freeAiChatsPerDay = 5;  // AI tab credit limit

// Pricing
// ₹49/month, ₹399/year, ₹999 lifetime (early access)
```

Premium upsell shows as a bottom sheet (`_showPremiumSheet()` in `AIChatScreen`).

## Firestore Schema

```
users/{uid}
  name, email, isPremium, aiCreditsUsed, totalXp, createdAt
  habits/{habitId}    → name, icon, streak, xpValue, color, lastCompletedAt
  tasks/{taskId}      → title, icon, dueTime, isCompleted, date
  meals/{mealId}      → name, calories, protein, carbs, fat, imageUrl, timestamp
  ai_chats/{chatId}   → messages: [{role, content, timestamp}]
  routines/{routineId}→ name, type (morning/night), steps: [String], isActive
```

## Firebase Setup (not done yet)

1. console.firebase.google.com → create project `routine`
2. Add Android app → package `com.routineapp.routine`
3. Download `google-services.json` → place at `android/app/google-services.json`
4. Run: `dart pub global activate flutterfire_cli && flutterfire configure`
5. Add `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` to `main()`

## App Constants

| Constant | Value | Location |
|---|---|---|
| Pomodoro work | 25 min | `AppConstants.pomodoroWork` |
| Pomodoro short break | 5 min | `AppConstants.pomodoroShortBreak` |
| Pomodoro long break | 15 min | `AppConstants.pomodoroLongBreak` |
| Daily water goal | 2500 ml | `AppConstants.dailyWaterGoalMl` |
| Water per glass | 250 ml | `AppConstants.waterPerGlassMl` |
| Daily step goal | 8000 | `AppConstants.dailyStepGoal` |
| Habit XP | 10 XP | `AppConstants.habitCompleteXp` |
| Task XP | 5 XP | `AppConstants.taskCompleteXp` |

## Navigation Routes

| Route | Screen |
|---|---|
| `/splash` | SplashScreen (auto-navigates to `/onboarding`) |
| `/onboarding` | OnboardingScreen (3 slides) |
| `/login` | LoginScreen |
| `/home` | HomeScreen (tab 0) |
| `/ai` | AIChatScreen (tab 1) |
| `/health` | HealthScreen (tab 2) |
| `/routine` | RoutineScreen (tab 3) |
| `/focus` | FocusScreen (tab 4) |

## Git & GitHub

```bash
# SSH key configured at ~/.ssh/routine_github
# Remote: git@github.com:kishan0485/routine.git
git push origin main
```
