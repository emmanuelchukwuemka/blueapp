class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String accountType; // 'user' or 'partner'
  final String? profilePicture;
  final int totalPoints;
  final int lifetimeEarned;
  final int lifetimeRedeemed;
  final int tasksCompleted;
  final DateTime createdAt;
  final bool hasBankDetails;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.accountType,
    this.profilePicture,
    required this.totalPoints,
    required this.lifetimeEarned,
    required this.lifetimeRedeemed,
    required this.tasksCompleted,
    required this.createdAt,
    this.hasBankDetails = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      accountType: json['account_type'] ?? 'user',
      profilePicture: json['profile_picture'],
      totalPoints: json['total_points'] ?? 0,
      lifetimeEarned: json['lifetime_earned'] ?? 0,
      lifetimeRedeemed: json['lifetime_redeemed'] ?? 0,
      tasksCompleted: json['tasks_completed'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      hasBankDetails: json['has_bank_details'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'account_type': accountType,
      'profile_picture': profilePicture,
      'total_points': totalPoints,
      'lifetime_earned': lifetimeEarned,
      'lifetime_redeemed': lifetimeRedeemed,
      'tasks_completed': tasksCompleted,
      'created_at': createdAt.toIso8601String(),
      'has_bank_details': hasBankDetails,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? accountType,
    String? profilePicture,
    int? totalPoints,
    int? lifetimeEarned,
    int? lifetimeRedeemed,
    int? tasksCompleted,
    DateTime? createdAt,
    bool? hasBankDetails,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      accountType: accountType ?? this.accountType,
      profilePicture: profilePicture ?? this.profilePicture,
      totalPoints: totalPoints ?? this.totalPoints,
      lifetimeEarned: lifetimeEarned ?? this.lifetimeEarned,
      lifetimeRedeemed: lifetimeRedeemed ?? this.lifetimeRedeemed,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      createdAt: createdAt ?? this.createdAt,
      hasBankDetails: hasBankDetails ?? this.hasBankDetails,
    );
  }
}
