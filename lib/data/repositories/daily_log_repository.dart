import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/enums.dart';
import '../models/daily_log_model.dart';
import '../services/firestore_service.dart';

/// Repository for daily log (meal tracker) operations.
class DailyLogRepository {
  static const _collection = 'daily_logs';
  final FirestoreService _firestoreService;
  final _uuid = const Uuid();

  DailyLogRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  /// Get or create today's daily log for a user.
  /// Creates a new log with 3 default meals if none exists for today.
  Future<DailyLogModel> getOrCreateTodayLog(String userId, String date) async {
    final snapshot = await _firestoreService.queryCollection(
      _collection,
      filters: [
        QueryFilter(
          field: 'userId',
          operator: QueryOperator.isEqualTo,
          value: userId,
        ),
        QueryFilter(
          field: 'date',
          operator: QueryOperator.isEqualTo,
          value: date,
        ),
      ],
      limit: 1,
    );

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return DailyLogModel.fromJson(doc.data(), docId: doc.id);
    }

    // Create new daily log with default meals
    final now = DateTime.now();
    final newLog = DailyLogModel(
      userId: userId,
      date: date,
      meals: [
        MealEntry(
          id: _uuid.v4(),
          mealType: MealType.breakfast,
          label: 'Desayuno',
        ),
        MealEntry(
          id: _uuid.v4(),
          mealType: MealType.lunch,
          label: 'Almuerzo',
        ),
        MealEntry(
          id: _uuid.v4(),
          mealType: MealType.dinner,
          label: 'Cena',
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );

    // Save and return with the generated doc ID
    final docRef = await FirebaseFirestore.instance
        .collection(_collection)
        .add(newLog.toJson());

    return newLog.copyWith(docId: docRef.id);
  }

  /// Toggle a meal's completed status.
  Future<DailyLogModel> toggleMealCompleted(
    DailyLogModel log,
    String mealId,
  ) async {
    final updatedMeals = log.meals.map((meal) {
      if (meal.id == mealId) {
        return meal.copyWith(
          completed: !meal.completed,
          completedAt: !meal.completed ? DateTime.now() : null,
        );
      }
      return meal;
    }).toList();

    final updatedLog = log.copyWith(meals: updatedMeals);

    if (log.docId != null) {
      await _firestoreService.updateDocument(
        _collection,
        log.docId!,
        {
          'meals': updatedMeals.map((m) => m.toJson()).toList(),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        },
      );
    }

    return updatedLog;
  }

  /// Add a custom meal (snack, merienda, etc.) to the daily log.
  Future<DailyLogModel> addMeal(
    DailyLogModel log, {
    required String label,
    required MealType mealType,
  }) async {
    final newMeal = MealEntry(
      id: _uuid.v4(),
      mealType: mealType,
      label: label,
    );

    final updatedMeals = [...log.meals, newMeal];
    final updatedLog = log.copyWith(meals: updatedMeals);

    if (log.docId != null) {
      await _firestoreService.updateDocument(
        _collection,
        log.docId!,
        {
          'meals': updatedMeals.map((m) => m.toJson()).toList(),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        },
      );
    }

    return updatedLog;
  }

  /// Link a recipe to a meal entry.
  Future<DailyLogModel> linkRecipeToMeal(
    DailyLogModel log,
    String mealId,
    String recipeId,
  ) async {
    final updatedMeals = log.meals.map((meal) {
      if (meal.id == mealId) {
        return meal.copyWith(recipeId: recipeId);
      }
      return meal;
    }).toList();

    final updatedLog = log.copyWith(meals: updatedMeals);

    if (log.docId != null) {
      await _firestoreService.updateDocument(
        _collection,
        log.docId!,
        {
          'meals': updatedMeals.map((m) => m.toJson()).toList(),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        },
      );
    }

    return updatedLog;
  }
}
