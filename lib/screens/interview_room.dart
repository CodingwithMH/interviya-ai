import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interviya/data/models/history_model.dart';
import 'package:interviya/data/providers/interview_provider.dart';
import 'package:interviya/data/providers/user_provider.dart';
import 'package:interviya/screens/interview_summary.dart';
import 'package:flutter/material.dart';
import 'package:interviya/widgets/circle_arcs.dart';
import 'package:interviya/widgets/voice_to_text.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class InterviewRoom extends StatefulWidget {
  const InterviewRoom({super.key});

  @override
  State<InterviewRoom> createState() => _InterviewRoomState();
}

class _InterviewRoomState extends State<InterviewRoom>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _startSeconds = 100;
  late AnimationController _rotationController;
  bool _isSubmitting = false;

  int getTotalSeconds(InterviewProvider provider) {
    int minutes = int.tryParse(provider.duration) ?? 0;
    return minutes * 60;
  }

  int getSecondsPerQuestion(InterviewProvider provider) {
    if (provider.questions.isEmpty) return 60;
    int total = getTotalSeconds(provider);
    if (total == 0) return 60;
    return total ~/ provider.questions.length;
  }

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<InterviewProvider>(context, listen: false);
    _startSeconds = getSecondsPerQuestion(provider);
    startTimer();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds <= 0) {
        final provider = Provider.of<InterviewProvider>(context, listen: false);
        if (provider.answers[provider.currentQuestionIndex].isEmpty) {
          provider.updateCurrentAnswer("No answer provided (Time out)");
        }
        nextQuestion();
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  void nextQuestion() {
    _timer?.cancel();
    final provider = Provider.of<InterviewProvider>(context, listen: false);

    if (provider.currentQuestionIndex < provider.questions.length - 1) {
      provider.nextQuestion();
      setState(() {
        _startSeconds = getSecondsPerQuestion(provider);
      });
      startTimer();
    } else {
      _goToSummary();
    }
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); // Critical: prevents background timer loops from running post-dispose
    _rotationController.dispose();
    super.dispose();
  }

  void _saveIncompleteSession() async {
    final provider = Provider.of<InterviewProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String currentUserId = userProvider.currentUser?.uid ?? '';
    debugPrint("currentUserId: $currentUserId");
    if (currentUserId.isEmpty) return; // Prevent empty writes

    List<String> rawQuestions = provider.questions
        .map((q) => q.toString())
        .toList();
    List<String> rawAnswers = provider.answers.map((ans) {
      return ans.trim().isEmpty
          ? "No answer recorded / Session abandoned"
          : ans.trim();
    }).toList();

    int answeredCount = provider.currentQuestionIndex;
    int percentage = ((answeredCount / rawQuestions.length) * 100).round();

    // FIX 1: Initializing HistoryModel parameters with clean sequential ordering syntax
    final historyItem = HistoryModel(
      userId: currentUserId,
      interviewData: const {'status': 'Incomplete Early Exit'},
      mode: provider.mode,
      difficulty: provider.difficulty,
      duration: getTotalSeconds(provider),
      questionCount: rawQuestions.length,
      questions: rawQuestions,
      userAnswers: rawAnswers,
      overallScore: '0',
      completionPercentage: percentage,
      interviewTitle: provider.interviewData["title"],
      timestamp: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('history')
          .add(historyItem.toMap());

      debugPrint("Successfully stored incomplete history item.");
    } catch (e) {
      debugPrint("Failed to log skipped workspace session: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InterviewProvider>(context);

    if (provider.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No questions available.")),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              // FIXED: Prevents premature popping without clearing state or asking confirmation
                              onPressed: _confirmEndSession,
                              icon: const Icon(
                                Icons.close,
                                color: Color(0xff94A3B8),
                                size: 28,
                              ),
                            ),
                            Text(
                              "Question ${provider.currentQuestionIndex + 1} of ${provider.questions.length}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff94A3B8),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formatTime(_startSeconds),
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _rotationController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle:
                                      _rotationController.value * 2 * math.pi,
                                  child: CustomPaint(
                                    size: const Size(220, 220),
                                    painter: CircleArcs(),
                                  ),
                                );
                              },
                            ),
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xFF0A898D,
                                ).withValues(alpha: 0.4),
                                border: Border.all(
                                  color: const Color(
                                    0xff0A898D,
                                  ).withValues(alpha: 0.5),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.smart_toy_outlined,
                                size: 60,
                                color: Color(0xff0A898D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Text(
                          provider.questions[provider.currentQuestionIndex],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff1E293B),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xff0A898D,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "AI is listening for Keywords",
                            style: TextStyle(
                              color: const Color(
                                0xff0A898D,
                              ).withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: _buildSideAction(
                                icon: Icons.skip_next_rounded,
                                label: "Skip Question",
                                color: const Color(0xff94A3B8),
                                onTap: nextQuestion,
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: VoiceToText(
                                onResponseRecorded: (String finalSpokenText) {
                                  final provider =
                                      Provider.of<InterviewProvider>(
                                        context,
                                        listen: false,
                                      );
                                  provider.updateCurrentAnswer(finalSpokenText);
                                  nextQuestion();
                                },
                              ),
                            ),
                            Expanded(
                              child: _buildSideAction(
                                icon: Icons.person_off_rounded,
                                label: "End Session",
                                color: Colors.redAccent,
                                onTap: _confirmEndSession,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _goToSummary() async {
    _timer?.cancel();
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF0A898D)),
      ),
    );

    final provider = Provider.of<InterviewProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<String> rawQuestions = provider.questions
        .map((q) => q.toString())
        .toList();
    List<String> rawAnswers = provider.answers.map((ans) {
      return ans.trim().isEmpty
          ? "No answer recorded / Question skipped"
          : ans.trim();
    }).toList();

    try {
      final url = Uri.parse(
        'https://codewithmh.pythonanywhere.com/submit-interview',
      );

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'questions': rawQuestions,
              'answers': rawAnswers,
            }),
          )
          .timeout(const Duration(seconds: 45));

      if (mounted) Navigator.pop(context); // Dismiss loading dialog

      if (response.statusCode == 200) {
        final Map<String, dynamic> evaluationMetrics = jsonDecode(
          response.body,
        );

        try {
          String currentUserId = userProvider.currentUser?.uid ?? '';
          if (currentUserId.isNotEmpty) {
            String? extractedScore =
                evaluationMetrics['overall_score']?.toString() ??
                evaluationMetrics['score']?.toString();

            final historyItem = HistoryModel(
              userId: currentUserId,
              interviewData: evaluationMetrics,
              mode: provider.mode,
              difficulty: provider.difficulty,
              duration: getTotalSeconds(provider),
              questionCount: rawQuestions.length,
              questions: rawQuestions,
              userAnswers: rawAnswers,
              overallScore: extractedScore,
              completionPercentage: 100,
              interviewTitle: provider.interviewData["title"],
              timestamp: DateTime.now(),
            );

            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUserId)
                .collection('history')
                .add(historyItem.toMap());

            debugPrint("Successfully stored completed history item.");
          }
        } catch (dbError) {
          debugPrint(
            "Failed to write document payload history entry: $dbError",
          );
        }

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: provider,
              child: InterviewSummaryScreen(evaluationData: evaluationMetrics),
            ),
          ),
        );
      } else {
        _showErrorSnackbar("Server Evaluation Error (${response.statusCode})");
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showErrorSnackbar("Failed to connect to evaluation engine.");
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _confirmEndSession() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("End Interview?"),
        content: const Text(
          "Are you sure you want to end this session prematurely? Your progress will be saved as incomplete.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0A898D),
            ),
            onPressed: () {
              _saveIncompleteSession();
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Widget _buildSideAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
