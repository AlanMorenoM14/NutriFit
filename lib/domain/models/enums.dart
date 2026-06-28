/// Domain enums for NutriFit.
///
/// [UserGoal] represents the user's physical objective.
/// [MealType] represents the type of meal in the daily tracker.
library;

enum UserGoal {
  gainWeight('gain_weight', 'Subir de peso', '🏋️'),
  loseWeight('lose_weight', 'Bajar de peso', '🏃'),
  maintain('maintain', 'Mantenerse', '⚖️');

  const UserGoal(this.value, this.label, this.emoji);

  final String value;
  final String label;
  final String emoji;

  static UserGoal fromValue(String value) {
    return UserGoal.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserGoal.maintain,
    );
  }
}

enum MealType {
  breakfast('breakfast', 'Desayuno', '🌅'),
  lunch('lunch', 'Almuerzo', '☀️'),
  dinner('dinner', 'Cena', '🌙'),
  snack('snack', 'Snack', '🍎');

  const MealType(this.value, this.label, this.emoji);

  final String value;
  final String label;
  final String emoji;

  static MealType fromValue(String value) {
    return MealType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MealType.snack,
    );
  }
}
