import 'package:flutter/material.dart';
import 'package:flutter_project/data/models/user_model.dart';

class InterviewProvider extends ChangeNotifier {
  Map<String, dynamic> interviewData;
  String mode;
  String difficulty;
  UserModel? currentUser;
  String duration;
  String questionCount;

  InterviewProvider({
    required this.interviewData,
    required this.mode,
    required this.difficulty,
    this.currentUser,
    required this.questionCount,
    required this.duration,
  });

  void updateSession({required Map<String, dynamic> data, required String mode, required String diff, UserModel? user, required String duration, required String questionCount}) {
    this.interviewData = data;
    this.mode = mode;
    this.difficulty = diff;
    this.currentUser = user;
    this.duration = duration;
    this.questionCount = questionCount;

    notifyListeners();
  }
}