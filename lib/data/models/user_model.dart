class UserModel {
  String? fullName;
  String? currentStatus;
  String? targetRole;
  String? experienceLevel;
  String? mainGoal;
  String? avatarPath;

  UserModel({
    this.fullName,
    this.currentStatus,
    this.targetRole,
    this.experienceLevel,
    this.mainGoal,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'currentStatus': currentStatus,
      'targetRole': targetRole,
      'experienceLevel': experienceLevel,
      'mainGoal': mainGoal,
      'avatarPath': avatarPath,
      'createdAt': DateTime.now(),
    };
}
}