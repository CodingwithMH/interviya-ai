import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class InterviewRoom extends StatefulWidget {
  const InterviewRoom({super.key});

  @override
  State<InterviewRoom> createState() => _InterviewRoomState();
}

class _InterviewRoomState extends State<InterviewRoom>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  Timer? _timer;
  int _startSeconds = 900;
  late AnimationController _rotationController;

  final List<String> questions = [
    "Can you explain the difference between a State and a Widget in Flutter?",
    "What is the difference between Hot Reload and Hot Restart?",
    "Explain the lifecycle of a StatefulWidget.",
    "What are Keys in Flutter and why are they important?",
    "How does InheritedWidget work?",
    "What is the difference between main() and runApp()?",
    "Can you explain what a Future is in Dart?",
    "What is the purpose of a Scaffold widget?",
    "How do you handle state management in large apps?",
    "What are streams and how do they differ from futures?",
  ];

  @override
  void initState() {
    super.initState();
    startTimer();

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..repeat();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        _timer?.cancel();
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _showFinishDialog();
    }
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Session Completed"),
        content: Text("Great job! You have answered all the questions."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Finish", style: TextStyle(color: Color(0xff0A898D))),
          ),
        ],
      ),
    );
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Color(0xff94A3B8), size: 28),
                  ),
                  Text(
                    "Question ${currentQuestionIndex + 1} of ${questions.length}",
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
                        angle: _rotationController.value * 2 * math.pi,
                        child: CustomPaint(
                          size: Size(220, 220),
                          painter: CircleArcsPainter(),
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
                        color: Color(0xff0A898D).withValues(alpha: 0.5),
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
                questions[currentQuestionIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff1E293B),
                  height: 1.3,
                ),
              ),

              SizedBox(height: 30),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  _buildSideAction(
                    icon: Icons.skip_next_rounded,
                    label: "Skip Question",
                    color: Color(0xff94A3B8),
                    onTap: nextQuestion,
                  ),

                  Column(
                    children: [
                      Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xff0A898D), Color(0xff0CBABF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff0A898D).withValues(alpha: 0.35),
                              blurRadius: 20,
                              spreadRadius: 4,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(Icons.mic, color: Colors.white, size: 42),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Tap to Speak",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1E293B),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  _buildSideAction(
                    icon: Icons.person_off_rounded,
                    label: "End Session",
                    color: Colors.redAccent,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
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

class CircleArcsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = Color(0xff0A898D)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2 - 20),
      0,
      math.pi * 1,
      false,
      paint,
    );

    final innerPaint = Paint()
      ..color = Color(0xff0A898D)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2 - 33),
      math.pi * 0.9,
      math.pi * 1.2,
      false,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

