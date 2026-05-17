import 'package:flutter/material.dart';
import 'package:interviya/data/models/interview_model.dart';
import 'package:interviya/data/providers/interview_provider.dart';
import 'package:interviya/screens/interview_setup.dart';
import 'package:interviya/widgets/custom_appbar.dart';
import 'package:interviya/widgets/main_wrapper.dart';
import 'package:provider/provider.dart';

class InterviewSummaryScreen extends StatefulWidget {
  final Map<String, dynamic> evaluationData;
  const InterviewSummaryScreen({super.key, required this.evaluationData});
  @override
  State<InterviewSummaryScreen> createState() => _InterviewSummaryScreenState();
}

class _InterviewSummaryScreenState extends State<InterviewSummaryScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<InterviewProvider>(context);

    final int overallScore = widget.evaluationData['score_out_of_hundred'] ?? 0;

    final double confidence =
        (widget.evaluationData['confidence'] ?? 0.0) / 100.0;
    final double technical =
        (widget.evaluationData['technical_accuracy'] ?? 0.0) / 100.0;
    final double communication =
        (widget.evaluationData['communication'] ?? 0.0) / 100.0;

    final String insights =
        widget.evaluationData['ai_insights'] ?? "No evaluation details shared.";

    final List<dynamic> questionBreakdown =
        widget.evaluationData['question_wise_breakdown'] ?? [];

    final List<dynamic> displayedQuestions = isExpanded
        ? questionBreakdown
        : questionBreakdown.take(2).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: CustomAppbar(
        text: "Interview Summary",
        onBack: () => Navigator.pop(context),
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
                    "$overallScore/100",
                    style: TextStyle(
                      fontSize: 40,
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
                      size: 60,
                      color: Color(0xFF0A898D),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatCard("Confidence", confidence),
                  SizedBox(width: 12),
                  _buildStatCard("Technical Accuracy", technical),
                  SizedBox(width: 12),
                  _buildStatCard("Communication", communication),
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
                insights,
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
                Expanded(
                  child: Text(
                    "Question-wise Breakdown",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1E293B),
                    ),
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
                          builder: (context) => InterviewSetup(
                            interview: InterviewModel.fromMap(
                              session.interviewData,
                            ),
                          ),
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainWrapper()),
                        (route) => false,
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
                      "Back to Home",
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
