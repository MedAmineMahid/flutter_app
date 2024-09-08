class Meal {
  final String mealName;
  final List<String> ingredients;
  final int totalCalories;

  Meal({
    required this.mealName,
    required this.ingredients,
    required this.totalCalories,
  });

  Map<String, dynamic> toJson() {
    return {
      'mealName': mealName,
      'ingredients': ingredients,
      'totalCalories': totalCalories,
    };
  }
}
