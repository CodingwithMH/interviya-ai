class UserModel {
  String? fullName;
  String? currentStatus;
  String? targetRole;
  String? experienceLevel;
  String? mainGoal;
  String? avatarPath;
  bool? hasFinishedSetup;

  UserModel({
    this.fullName,
    this.currentStatus,
    this.targetRole,
    this.experienceLevel,
    this.mainGoal,
    this.avatarPath,
    this.hasFinishedSetup
  });

factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'],
      currentStatus: map['currentStatus'],
      targetRole: map['targetRole'],
      experienceLevel: map['experienceLevel'],
      mainGoal: map['mainGoal'],
      avatarPath: map['avatarPath'],
      hasFinishedSetup: map['hasFinishedSetup'] ?? false,
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
      'createdAt': DateTime.now().toIso8601String(),
    };
}
}