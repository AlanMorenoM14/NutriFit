/// NutriFit design constants.
class AppConstants {
  AppConstants._();

  // ─── App Info ────────────────────────────────────────────────
  static const String appName = 'NutriFit';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Tu diario de alimentación inteligente';

  // ─── Firestore Collections ───────────────────────────────────
  static const String usersCollection = 'users';
  static const String recipesCollection = 'recipes';
  static const String dailyLogsCollection = 'daily_logs';

  // ─── Animation Durations ─────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animVerySlow = Duration(milliseconds: 800);

  // ─── Content Constraints ─────────────────────────────────────
  static const double maxContentWidth = 600.0;
  static const double maxCardWidth = 400.0;
}
