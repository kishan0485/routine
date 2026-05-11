class AppConstants {
  AppConstants._();

  static const String appName = 'Routine';
  static const String geminiModel = 'gemini-1.5-flash';
  static const String geminiVisionModel = 'gemini-1.5-flash';

  // Free tier limits
  static const int freeAiChatsPerDay = 5;

  // Pricing
  static const int monthlyPricePaise = 4900; // ₹49
  static const int yearlyPricePaise = 39900;  // ₹399

  // Gamification
  static const int habitCompleteXp = 10;
  static const int taskCompleteXp = 5;
  static const int streakBonusXp = 20;

  // Pomodoro defaults (minutes)
  static const int pomodoroWork = 25;
  static const int pomodoroShortBreak = 5;
  static const int pomodoroLongBreak = 15;

  // Water goal
  static const int dailyWaterGoalMl = 2500;
  static const int waterPerGlassMl = 250;

  // Step goal
  static const int dailyStepGoal = 8000;
}
