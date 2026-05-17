import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interviya/data/models/history_model.dart';
import 'package:interviya/data/services/auth_service.dart';

class CategorizedHistory {
  final List<HistoryModel> thisWeek;
  final List<HistoryModel> lastMonth;
  final List<HistoryModel> older;
  final int totalFilteredCount;

  CategorizedHistory({
    required this.thisWeek,
    required this.lastMonth,
    required this.older,
    required this.totalFilteredCount,
  });
}

class HistoryProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  StreamSubscription<List<HistoryModel>>? _historySubscription;

  List<HistoryModel> _allTasks = [];
  bool _isCompletedTab = true;
  bool _showAll = false;
  bool _isLoading = true;
  String? _errorMessage;

  bool get isCompletedTab => _isCompletedTab;
  bool get showAll => _showAll;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HistoryProvider() {
    _initHistoryStream();
  }

  void _initHistoryStream() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _historySubscription = _authService.getUserHistoryStream().listen(
      (data) {
        _allTasks = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  void setTab(bool isCompleted) {
    _isCompletedTab = isCompleted;
    _showAll = false;
    notifyListeners();
  }

  void toggleShowAll() {
    _showAll = !_showAll;
    notifyListeners();
  }

  String _calculatePeriod(DateTime date) {
    DateTime now = DateTime.now();
    int differenceInDays = now.difference(date).inDays;
    
    if (differenceInDays <= 7) {
      return "This Week";
    } else if (differenceInDays <= 30) {
      return "Last Month";
    } else {
      return "Older Tasks";
    }
  }

  CategorizedHistory getCategorizedHistory() {
    final List<HistoryModel> thisWeek = [];
    final List<HistoryModel> lastMonth = [];
    final List<HistoryModel> older = [];

    for (final task in _allTasks) {
      final int score = task.completionPercentage;
      final bool matchesTab = _isCompletedTab ? (score == 100) : (score < 100);

      if (matchesTab) {
        final period = _calculatePeriod(task.timestamp);
        if (period == "This Week") {
          thisWeek.add(task);
        } else if (period == "Last Month") {
          lastMonth.add(task);
        } else {
          older.add(task);
        }
      }
    }

    final int totalCount = thisWeek.length + lastMonth.length + older.length;

    return CategorizedHistory(
      thisWeek: _showAll ? thisWeek : thisWeek.take(2).toList(),
      lastMonth: _showAll ? lastMonth : lastMonth.take(2).toList(),
      older: _showAll ? older : older.take(2).toList(),
      totalFilteredCount: totalCount,
    );
  }

int get currentReadiness {
  final completedInterviews = _allTasks.where((task) => task.completionPercentage == 100).toList();

  if (completedInterviews.isEmpty) {
    return 0;
  }

  double totalScore = 0;
  int scoredCount = 0;

  for (var task in completedInterviews) {
    final int? rawScore = task.interviewData['score_out_of_hundred'] as int?;
    
    if (rawScore != null) {
      totalScore += rawScore;
      scoredCount++;
    }
  }

  if (scoredCount == 0) {
    return 75;
  }

  return (totalScore / scoredCount).round().clamp(0, 100);
}

  @override
  void dispose() {
    _historySubscription?.cancel();
    super.dispose();
  }
}