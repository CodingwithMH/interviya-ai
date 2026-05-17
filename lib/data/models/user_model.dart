import 'package:cloud_firestore/cloud_firestore.dart';

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
    String? parsedDate;
    
    if (map['createdAt'] is Timestamp) {
      parsedDate = (map['createdAt'] as Timestamp).toDate().toIso8601String();
    } else if (map['createdAt'] != null) {
      parsedDate = map['createdAt'].toString();
    } else {
      parsedDate = DateTime.now().toIso8601String();
    }

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
      createdAt: parsedDate,
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
  UserModel copyWith({
    String? uid,
    String? fullName,
    String? currentStatus,
    String? email,
    String? targetRole,
    String? experienceLevel,
    String? mainGoal,
    String? avatarPath,
    bool? hasFinishedSetup,
    String? role,
    String? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      currentStatus: currentStatus ?? this.currentStatus,
      email: email ?? this.email,
      targetRole: targetRole ?? this.targetRole,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      mainGoal: mainGoal ?? this.mainGoal,
      avatarPath: avatarPath ?? this.avatarPath,
      hasFinishedSetup: hasFinishedSetup ?? this.hasFinishedSetup,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}