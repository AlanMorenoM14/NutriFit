import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/daily_log_model.dart';
import '../../../../data/repositories/daily_log_repository.dart';
import '../../../../domain/models/enums.dart';
import '../../../features/auth/providers/auth_provider.dart';

// ─── Repository Provider ───────────────────────────────────────
final dailyLogRepositoryProvider = Provider<DailyLogRepository>((ref) {
  return DailyLogRepository(
    firestoreService: ref.watch(firestoreServiceProvider),
  );
});

// ─── Today's Date ──────────────────────────────────────────────
final todayDateProvider = Provider<String>((ref) {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
});

// ─── Daily Log State ───────────────────────────────────────────
/// Async provider that fetches or creates today's daily log.
final dailyLogProvider =
    AsyncNotifierProvider<DailyLogNotifier, DailyLogModel?>(
  DailyLogNotifier.new,
);

class DailyLogNotifier extends AsyncNotifier<DailyLogModel?> {
  @override
  Future<DailyLogModel?> build() async {
    final authState = ref.watch(authStateProvider);
    final date = ref.read(todayDateProvider);

    return authState.when(
      data: (user) async {
        if (user == null) return null;
        final repo = ref.read(dailyLogRepositoryProvider);
        return await repo.getOrCreateTodayLog(user.uid, date);
      },
      loading: () => null,
      error: (_, _) => null,
    );
  }

  /// Toggle meal completed status.
  Future<void> toggleMeal(String mealId) async {
    final currentLog = state.value;
    if (currentLog == null) return;

    final repo = ref.read(dailyLogRepositoryProvider);
    state = AsyncData(await repo.toggleMealCompleted(currentLog, mealId));
  }

  /// Add a custom meal to today's log.
  Future<void> addMeal({
    required String label,
    required MealType mealType,
  }) async {
    final currentLog = state.value;
    if (currentLog == null) return;

    final repo = ref.read(dailyLogRepositoryProvider);
    state = AsyncData(
      await repo.addMeal(currentLog, label: label, mealType: mealType),
    );
  }

  /// Link a recipe to a meal.
  Future<void> linkRecipe(String mealId, String recipeId) async {
    final currentLog = state.value;
    if (currentLog == null) return;

    final repo = ref.read(dailyLogRepositoryProvider);
    state = AsyncData(
      await repo.linkRecipeToMeal(currentLog, mealId, recipeId),
    );
  }

  /// Refresh today's log from Firestore.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
