import 'package:flutter/material.dart';
import 'package:flutter_project/screens/interview_setup.dart';
import 'package:flutter_project/navigation_menu.dart';

class InterviewSummaryScreen extends StatefulWidget {
  const InterviewSummaryScreen({super.key});

  @override
  State<InterviewSummaryScreen> createState() => _InterviewSummaryScreenState();
}

class _InterviewSummaryScreenState extends State<InterviewSummaryScreen> {
  bool isExpanded = false;

  final List<Map<String, dynamic>> allQuestions = [
    {"q": "Q1: What is a Widget?", "isCorrect": true},
    {"q": "Q2: Explaining State...", "isCorrect": false},
    {"q": "Q3: Hot Reload vs Hot Restart", "isCorrect": true},
    {"q": "Q4: Lifecycle of StatefulWidget", "isCorrect": true},
    {"q": "Q5: What are Keys?", "isCorrect": false},
    {"q": "Q6: InheritedWidget use case", "isCorrect": true},
    {"q": "Q7: Main vs RunApp", "isCorrect": true},
    {"q": "Q8: What is a Future?", "isCorrect": true},
    {"q": "Q9: Purpose of Scaffold", "isCorrect": false},
    {"q": "Q10: State Management", "isCorrect": true},
    {"q": "Q11: Streams in Dart", "isCorrect": false},
    {"q": "Q12: Dependency Injection", "isCorrect": true},
    {"q": "Q13: Flutter Architecture", "isCorrect": true},
    {"q": "Q14: Performance Profiling", "isCorrect": false},
    {"q": "Q15: Testing in Flutter", "isCorrect": true},
  ];

  @override
  Widget build(BuildContext context) {
    final displayedQuestions = isExpanded
        ? allQuestions
        : allQuestions.take(2).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Color(0xFF0A898D),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(top: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Interview Summary",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff1E293B).withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "82/100",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A898D),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF0A898D).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.stars,
                      size: 70,
                      color: Color(0xFF0A898D),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, 
                children: [
                  _buildStatCard("Confidence", 0.7),
                  SizedBox(width: 12),
                  _buildStatCard("Technical Accuracy", 0.85),
                  SizedBox(width: 12),
                  _buildStatCard("Communication", 0.6),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              "AI Insights and Suggestions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff1E293B),
              ),
            ),
            SizedBox(height: 26),
            Container(
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Color(0xFF0A898D).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff1E293B).withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "You explain State management well, but try to use more real-world examples in technical answers",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question-wise Breakdown",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1E293B),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? "View Less" : "View All",
                    style: TextStyle(
                      color: Color(0xFF0A898D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff1E293B).withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: displayedQuestions.length,
                separatorBuilder: (context, index) => Divider(height: 30),
                itemBuilder: (context, index) {
                  return _buildQuestionRow(
                    displayedQuestions[index]["q"],
                    displayedQuestions[index]["isCorrect"],
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InterviewSetup(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Color(0xFF0A898D), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Retake Interview",
                      style: TextStyle(color: Color(0xFF0A898D)),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainWrapper()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0A898D),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Back to Dashboard",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, double progress) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xff1E293B).withValues(alpha: 0.1),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0A898D),
              ),
            ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Color(0xFF94A3B8).withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0CBABF)),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionRow(String question, bool isCorrect) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff1E293B),
            ),
          ),
        ),
        Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.error,
              color: isCorrect ? Colors.green : Colors.redAccent,
              size: 20,
            ),
            SizedBox(width: 4),
            Text(
              isCorrect ? "Correct" : "Incorrect",
              style: TextStyle(
                color: isCorrect ? Colors.green : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

