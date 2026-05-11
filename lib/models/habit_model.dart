class HabitModel {
  final String id;
  final String name;
  final String icon;
  final int streak;
  final int xpValue;
  final String color;
  final DateTime? lastCompletedAt;

  const HabitModel({
    required this.id,
    required this.name,
    required this.icon,
    this.streak = 0,
    this.xpValue = 10,
    this.color = '#7C3AED',
    this.lastCompletedAt,
  });

  bool get isCompletedToday {
    if (lastCompletedAt == null) return false;
    final now = DateTime.now();
    return lastCompletedAt!.day == now.day &&
        lastCompletedAt!.month == now.month &&
        lastCompletedAt!.year == now.year;
  }

  factory HabitModel.fromMap(Map<String, dynamic> map, String id) {
    return HabitModel(
      id: id,
      name: map['name'] ?? '',
      icon: map['icon'] ?? '⭐',
      streak: map['streak'] ?? 0,
      xpValue: map['xpValue'] ?? 10,
      color: map['color'] ?? '#7C3AED',
      lastCompletedAt: map['lastCompletedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastCompletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon,
        'streak': streak,
        'xpValue': xpValue,
        'color': color,
        'lastCompletedAt': lastCompletedAt?.millisecondsSinceEpoch,
      };
}
