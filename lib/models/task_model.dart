class TaskModel {
  final String id;
  final String title;
  final String icon;
  final String dueTime;
  final bool isCompleted;
  final DateTime date;

  const TaskModel({
    required this.id,
    required this.title,
    this.icon = '✅',
    this.dueTime = '',
    this.isCompleted = false,
    required this.date,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      icon: map['icon'] ?? '✅',
      dueTime: map['dueTime'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      date: DateTime.fromMillisecondsSinceEpoch(
          map['date'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'icon': icon,
        'dueTime': dueTime,
        'isCompleted': isCompleted,
        'date': date.millisecondsSinceEpoch,
      };

  TaskModel copyWith({bool? isCompleted}) => TaskModel(
        id: id,
        title: title,
        icon: icon,
        dueTime: dueTime,
        isCompleted: isCompleted ?? this.isCompleted,
        date: date,
      );
}
