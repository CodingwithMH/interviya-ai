class UserModel {
  String? uid;
  String? fullName;
  String? currentStatus;
  String? email;
  String? targetRole;
  String? experienceLevel;
  String? mainGoal;
  String? avatarPath;
  bool? hasFinishedSetup;
  String? role;
  String? createdAt;

  UserModel({
    this.uid,
    this.fullName,
    this.currentStatus,
    this.targetRole,
    this.experienceLevel,
    this.mainGoal,
    this.avatarPath,
    this.hasFinishedSetup,
    this.role,
    this.email,
    this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  factory UserModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return UserModel(
      uid: documentId ?? map['uid'],
      fullName: map['fullName'],
      currentStatus: map['currentStatus'],
      email: map['email'],
      targetRole: map['targetRole'],
      experienceLevel: map['experienceLevel'],
      mainGoal: map['mainGoal'],
      avatarPath: map['avatarPath'],
      hasFinishedSetup: map['hasFinishedSetup'] ?? false,
      role: map['role'] ?? 'user',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (uid != null) 'uid': uid,
      'fullName': fullName,
      'currentStatus': currentStatus,
      'email': email,
      'targetRole': targetRole,
      'experienceLevel': experienceLevel,
      'mainGoal': mainGoal,
      'avatarPath': avatarPath,
      'hasFinishedSetup': hasFinishedSetup ?? false,
      'role': role ?? 'user',
      'createdAt': createdAt ?? DateTime.now().toIso8601String(), 
    };
  }
}