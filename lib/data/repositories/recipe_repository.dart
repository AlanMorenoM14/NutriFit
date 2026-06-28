import '../models/recipe_model.dart';
import '../services/firestore_service.dart';
import '../services/recipe_seeder.dart';

/// Repository for recipe operations.
class RecipeRepository {
  static const _collection = 'recipes';
  final FirestoreService _firestoreService;

  RecipeRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  Future<void> _checkAndSeed() async {
    final checkSnapshot = await _firestoreService.queryCollection(_collection, limit: 1);
    if (checkSnapshot.docs.isEmpty) {
      await RecipeSeeder.seed(_firestoreService);
    }
  }

  /// Get recipes filtered by meal type and user goal.
  Future<List<RecipeModel>> getRecipes({
    required String mealType,
    required String goal,
  }) async {
    await _checkAndSeed();
    final snapshot = await _firestoreService.queryCollection(
      _collection,
      filters: [
        QueryFilter(
          field: 'mealType',
          operator: QueryOperator.isEqualTo,
          value: mealType,
        ),
        QueryFilter(
          field: 'goals',
          operator: QueryOperator.arrayContains,
          value: goal,
        ),
      ],
    );

    return snapshot.docs
        .map((doc) => RecipeModel.fromJson(doc.data(), docId: doc.id))
        .toList();
  }

  /// Get all recipes for a specific goal (any meal type).
  Future<List<RecipeModel>> getRecipesByGoal(String goal) async {
    await _checkAndSeed();
    final snapshot = await _firestoreService.queryCollection(
      _collection,
      filters: [
        QueryFilter(
          field: 'goals',
          operator: QueryOperator.arrayContains,
          value: goal,
        ),
      ],
    );

    return snapshot.docs
        .map((doc) => RecipeModel.fromJson(doc.data(), docId: doc.id))
        .toList();
  }

  /// Get a single recipe by ID.
  Future<RecipeModel?> getRecipe(String recipeId) async {
    final doc = await _firestoreService.getDocument(_collection, recipeId);
    if (!doc.exists || doc.data() == null) return null;
    return RecipeModel.fromJson(doc.data()!, docId: doc.id);
  }
}
