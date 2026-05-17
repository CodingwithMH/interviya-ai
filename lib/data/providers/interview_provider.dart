import 'package:flutter/material.dart';
import 'package:interviya/data/models/user_model.dart';

class InterviewProvider extends ChangeNotifier {
  Map<String, dynamic> interviewData;
  String mode;
  String difficulty;
  UserModel? currentUser;
  String duration;
  String questionCount;

  List<String> questions = [];
  List<String> answers = [];
  int currentQuestionIndex = 0;

  InterviewProvider({
    required this.interviewData,
    required this.mode,
    required this.difficulty,
    this.currentUser,
    required this.questionCount,
    required this.duration,
  });

  void setQuestions(List<String> generatedQuestions) {
    questions = generatedQuestions;
    currentQuestionIndex = 0;
    answers = List<String>.filled(generatedQuestions.length, "");

    notifyListeners();
  }

  void updateCurrentAnswer(String transcribedText) {
    if (questions.isEmpty) return;

    final currentAnswer = answers[currentQuestionIndex];

    if (currentAnswer.isEmpty) {
      answers[currentQuestionIndex] = transcribedText;
    } else {
      answers[currentQuestionIndex] = "$currentAnswer $transcribedText";
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      notifyListeners();
    }
  }

  String get currentQuestionText =>
      questions.isNotEmpty ? questions[currentQuestionIndex] : "";

  String get currentAnswerText {
    if (answers.isEmpty || currentQuestionIndex >= answers.length) return "";
    return answers[currentQuestionIndex];
  }

  void updateSession({
    required Map<String, dynamic> data,
    required String mode,
    required String diff,
    UserModel? user,
    required String duration,
    required String questionCount,
  }) {
    this.interviewData = data;
    this.mode = mode;
    this.difficulty = diff;
    this.currentUser = user;
    this.duration = duration;
    this.questionCount = questionCount;

    notifyListeners();
  }
}
