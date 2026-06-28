import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/enums.dart';

/// Firestore model for a recipe.
class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final MealType mealType;
  final List<String> goals;
  final int calories;
  final int prepTimeMinutes;
  final List<String> ingredients;
  final List<String> steps;
  final String difficulty;
  final DateTime createdAt;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.mealType,
    required this.goals,
    required this.calories,
    required this.prepTimeMinutes,
    required this.ingredients,
    required this.steps,
    required this.difficulty,
    required this.createdAt,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return RecipeModel(
      id: docId ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      mealType: MealType.fromValue(json['mealType'] as String? ?? 'breakfast'),
      goals: List<String>.from(json['goals'] ?? []),
      calories: json['calories'] as int? ?? 0,
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      difficulty: json['difficulty'] as String? ?? 'easy',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'mealType': mealType.value,
      'goals': goals,
      'calories': calories,
      'prepTimeMinutes': prepTimeMinutes,
      'ingredients': ingredients,
      'steps': steps,
      'difficulty': difficulty,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
