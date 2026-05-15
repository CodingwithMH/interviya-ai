class UserModel {
  String? fullName;
  String? currentStatus;
  String? targetRole;
  String? experienceLevel;
  String? mainGoal;
  String? avatarPath;
  bool? hasFinishedSetup;
  String? role;

  UserModel({
    this.fullName,
    this.currentStatus,
    this.targetRole,
    this.experienceLevel,
    this.mainGoal,
    this.avatarPath,
    this.hasFinishedSetup,
    this.role
  });

bool get isAdmin => role == 'admin';

factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'],
      currentStatus: map['currentStatus'],
      targetRole: map['targetRole'],
      experienceLevel: map['experienceLevel'],
      mainGoal: map['mainGoal'],
      avatarPath: map['avatarPath'],
      hasFinishedSetup: map['hasFinishedSetup'] ?? false,
      role: map['role'] ?? 'user'
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'currentStatus': currentStatus,
      'targetRole': targetRole,
      'experienceLevel': experienceLevel,
      'mainGoal': mainGoal,
      'avatarPath': avatarPath,
      'hasFinishedSetup': hasFinishedSetup ?? false,
      'role': role ?? 'user',
      'createdAt': DateTime.now().toIso8601String(),
    };
}
}