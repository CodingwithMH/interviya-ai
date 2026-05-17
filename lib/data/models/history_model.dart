class HistoryModel {
  final String? id;
  final String userId;
  final Map<String, dynamic> interviewData;
  final String mode;
  final String difficulty;
  final int duration;
  final int questionCount;
  final List<String> questions;
  final List<String>? userAnswers;
  final String? overallScore;
  final DateTime timestamp;
  final int completionPercentage;
  final String interviewTitle;

  HistoryModel({
    this.id,
    required this.userId,
    required this.interviewData,
    required this.mode,
    required this.difficulty,
    required this.duration,
    required this.questionCount,
    required this.questions,
    this.userAnswers,
    this.overallScore,
    required this.completionPercentage,
    required this.timestamp,
    required this.interviewTitle,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return HistoryModel(
      id: documentId,
      userId: map['userId'] ?? '',
      interviewData: Map<String, dynamic>.from(map['interviewData'] ?? {}),
      mode: map['mode'] ?? '',
      difficulty: map['difficulty'] ?? '',
      duration: map['duration'] ?? 0,
      questionCount: map['questionCount'] ?? 0,
      questions: List<String>.from(map['questions'] ?? []),
      userAnswers: map['userAnswers'] != null
          ? List<String>.from(map['userAnswers'])
          : null,
      overallScore: map['overallScore'],
      completionPercentage: map['completionPercentage'] ?? 0,
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      interviewTitle: map['interviewTitle'] ?? '', 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'interviewData': interviewData,
      'mode': mode,
      'difficulty': difficulty,
      'duration': duration,
      'questionCount': questionCount,
      'questions': questions,
      'completionPercentage': completionPercentage,
      if (userAnswers != null) 'userAnswers': userAnswers,
      if (overallScore != null) 'overallScore': overallScore,
      'timestamp': timestamp.toIso8601String(),
      'interviewTitle': interviewTitle,
    };
  }
}