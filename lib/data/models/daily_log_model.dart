import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/enums.dart';

/// A single meal entry within a daily log.
class MealEntry {
  final String id;
  final MealType mealType;
  final String label;
  final bool completed;
  final String? recipeId;
  final DateTime? completedAt;

  const MealEntry({
    required this.id,
    required this.mealType,
    required this.label,
    this.completed = false,
    this.recipeId,
    this.completedAt,
  });

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'] as String? ?? '',
      mealType: MealType.fromValue(json['mealType'] as String? ?? 'snack'),
      label: json['label'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      recipeId: json['recipeId'] as String?,
      completedAt: (json['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealType': mealType.value,
      'label': label,
      'completed': completed,
      'recipeId': recipeId,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  MealEntry copyWith({
    String? id,
    MealType? mealType,
    String? label,
    bool? completed,
    String? recipeId,
    DateTime? completedAt,
  }) {
    return MealEntry(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      label: label ?? this.label,
      completed: completed ?? this.completed,
      recipeId: recipeId ?? this.recipeId,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Firestore model for a daily log (one per user per day).
class DailyLogModel {
  final String? docId;
  final String userId;
  final String date; // ISO format "yyyy-MM-dd"
  final List<MealEntry> meals;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyLogModel({
    this.docId,
    required this.userId,
    required this.date,
    required this.meals,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyLogModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return DailyLogModel(
      docId: docId,
      userId: json['userId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      meals: (json['meals'] as List<dynamic>?)
              ?.map((m) => MealEntry.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'meals': meals.map((m) => m.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  DailyLogModel copyWith({
    String? docId,
    String? userId,
    String? date,
    List<MealEntry>? meals,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyLogModel(
      docId: docId ?? this.docId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      meals: meals ?? this.meals,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Percentage of meals completed (0.0 - 1.0).
  double get completionProgress {
    if (meals.isEmpty) return 0.0;
    final completedCount = meals.where((m) => m.completed).length;
    return completedCount / meals.length;
  }
}
