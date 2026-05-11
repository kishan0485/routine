class MealModel {
  final String id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String? imageUrl;
  final DateTime timestamp;

  const MealModel({
    required this.id,
    required this.name,
    required this.calories,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.imageUrl,
    required this.timestamp,
  });

  factory MealModel.fromMap(Map<String, dynamic> map, String id) {
    return MealModel(
      id: id,
      name: map['name'] ?? '',
      calories: map['calories'] ?? 0,
      protein: map['protein'] ?? 0,
      carbs: map['carbs'] ?? 0,
      fat: map['fat'] ?? 0,
      imageUrl: map['imageUrl'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'imageUrl': imageUrl,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };
}
