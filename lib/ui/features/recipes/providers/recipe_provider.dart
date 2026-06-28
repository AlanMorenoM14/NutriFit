import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/recipe_model.dart';
import '../../../../data/repositories/recipe_repository.dart';
import '../../../features/auth/providers/auth_provider.dart';

// ─── Repository Provider ───────────────────────────────────────
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository(
    firestoreService: ref.watch(firestoreServiceProvider),
  );
});

// ─── Recipes by Meal Type + Goal ───────────────────────────────
/// Fetches recipes filtered by meal type and the current user's goal.
final recipesProvider = FutureProvider.family<List<RecipeModel>, String>(
  (ref, mealType) async {
    final userAsync = ref.watch(currentUserProvider);
    final repo = ref.read(recipeRepositoryProvider);

    return userAsync.when(
      data: (user) async {
        if (user == null) return [];
        return await repo.getRecipes(
          mealType: mealType,
          goal: user.goal.value,
        );
      },
      loading: () => [],
      error: (_, _) => [],
    );
  },
);

// ─── Single Recipe Detail ──────────────────────────────────────
final recipeDetailProvider = FutureProvider.family<RecipeModel?, String>(
  (ref, recipeId) async {
    final repo = ref.read(recipeRepositoryProvider);
    return await repo.getRecipe(recipeId);
  },
);
