class UserModel {
  final String uid;
  final String name;
  final String email;
  final bool isPremium;
  final int aiCreditsUsed;
  final DateTime createdAt;
  final int totalXp;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.isPremium = false,
    this.aiCreditsUsed = 0,
    required this.createdAt,
    this.totalXp = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isPremium: map['isPremium'] ?? false,
      aiCreditsUsed: map['aiCreditsUsed'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      totalXp: map['totalXp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'isPremium': isPremium,
        'aiCreditsUsed': aiCreditsUsed,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'totalXp': totalXp,
      };

  UserModel copyWith({
    bool? isPremium,
    int? aiCreditsUsed,
    int? totalXp,
  }) {
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      isPremium: isPremium ?? this.isPremium,
      aiCreditsUsed: aiCreditsUsed ?? this.aiCreditsUsed,
      createdAt: createdAt,
      totalXp: totalXp ?? this.totalXp,
    );
  }
}
