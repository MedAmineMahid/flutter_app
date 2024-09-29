class Meal {
  final String mealName;
  final List<String> ingredients;
  final int totalCalories;
  final DateTime? time; // Optional for saving, populated when fetched

  Meal({
    required this.mealName,
    required this.ingredients,
    required this.totalCalories,
    this.time, // Optional when saving
  });

  // Factory constructor to create a Meal instance from JSON
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealName: json['mealName'] ?? 'No name', // Provide default value if null
      ingredients: List<String>.from(json['ingredients'] ?? []), // Handle potential null
      totalCalories: json['totalCalories'] ?? 0, // Provide default value if null
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
    );
  }

  // Convert a Meal to JSON
  Map<String, dynamic> toJson() {
    return {
      'mealName': mealName,
      'ingredients': ingredients,
      'totalCalories': totalCalories,
      'time': time?.toIso8601String(), // Convert DateTime to ISO string
    };
  }
}
