import 'dart:async';
import 'dart:math' as math;
import 'package:interviya/data/providers/interview_provider.dart';
import 'package:interviya/screens/interview_summary.dart';
import 'package:flutter/material.dart';
import 'package:interviya/widgets/circle_arcs.dart';
import 'package:interviya/widgets/voice_to_text.dart';
import 'package:provider/provider.dart';

class InterviewRoom extends StatefulWidget {
  final List<String> questions;
  final String? duration;
  const InterviewRoom({
    super.key,
    required this.questions,
    required this.duration,
  });

  @override
  State<InterviewRoom> createState() => _InterviewRoomState();
}

class _InterviewRoomState extends State<InterviewRoom>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  Timer? _timer;
  int _startSeconds = 100;
  late AnimationController _rotationController;

  int get totalSeconds {
    int minutes = int.tryParse(widget.duration ?? '0') ?? 0;
    return minutes * 60;
  }

  int get secondsPerQuestion {
    if (widget.questions.isEmpty || totalSeconds == 0) return 60;
    return totalSeconds ~/ widget.questions.length;
  }

  @override
  void initState() {
    super.initState();
    _startSeconds = secondsPerQuestion;
    startTimer();

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..repeat();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_startSeconds <= 0) {
        // Time for this question is up!
        nextQuestion();
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        // Reset timer to the per-question limit
        _startSeconds = secondsPerQuestion;
      });
    } else {
      _timer?.cancel();
      _goToSummary();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.close,
                                color: Color(0xff94A3B8),
                                size: 28,
                              ),
                            ),
                            Text(
                              "Question ${currentQuestionIndex + 1} of ${widget.questions.length}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff94A3B8),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  formatTime(_startSeconds),
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
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
                                    size: Size(220, 220),
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
                                color: Color(0xFF0A898D).withValues(alpha: 0.4),
                                border: Border.all(
                                  color: Color(
                                    0xff0A898D,
                                  ).withValues(alpha: 0.5),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            CircleAvatar(
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
                        SizedBox(height: 50),
                        Text(
                          widget.questions[currentQuestionIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff1E293B),
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff0A898D).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "AI is listening for Keywords",
                            style: TextStyle(
                              color: Color(0xff0A898D).withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Spacer(),
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
                            // Give the recording component the priority space
                            const Flexible(flex: 2, child: VoiceToText()),
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
                        SizedBox(height: 20),
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

  void _goToSummary() {
    _timer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: Provider.of<InterviewProvider>(context, listen: false),
          child: const InterviewSummaryScreen(),
        ),
      ),
    );
  }

  void _confirmEndSession() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("End Interview?"),
        content: Text("Are you sure you want to end this session?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xff0A898D)),
            onPressed: () {
              Navigator.pop(context);
              _goToSummary();
            },
            child: Text("Confirm"),
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
          SizedBox(height: 8),
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
