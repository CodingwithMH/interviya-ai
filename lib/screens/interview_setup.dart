import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interviya/data/models/user_model.dart';
import 'package:interviya/data/models/interview_model.dart';
import 'package:interviya/data/providers/interview_provider.dart';
import 'package:interviya/screens/interview_room.dart';
import 'package:interviya/widgets/custom_appbar.dart';
import 'package:interviya/widgets/mode_card.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InterviewSetup extends StatefulWidget {
  final InterviewModel interview;
  const InterviewSetup({super.key, required this.interview});

  @override
  State<InterviewSetup> createState() => _InterviewSetupState();
}

class _InterviewSetupState extends State<InterviewSetup> {
  double _difficultyValue = 1;
  String selectedMode = "Full Mock";
  Map<String, String> getSessionSettings() {
    if (_difficultyValue == 0) {
      return {"time": "10", "questions": "5"};
    } else if (_difficultyValue == 1) {
      return {"time": "20", "questions": "10"};
    } else {
      return {"time": "35", "questions": "15"};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: CustomAppbar(
        text: "Setup Interview",
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff1E293B).withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.interview.icon,
                      color: Color(0xFF0A898D),
                      size: 30,
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: Text(
                        widget.interview.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A898D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 55),
              Text(
                "Select Interview Mode",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1E293B),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedMode = "Full Mock"),
                      child: ModeCard(
                        title: "Full Mock\nInterview",
                        icon: Icons.emoji_events_outlined,
                        isSelected: selectedMode == "Full Mock",
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => selectedMode = "Focused Practice"),
                      child: ModeCard(
                        title: "Focused\nPractice",
                        icon: Icons.track_changes,
                        isSelected: selectedMode == "Focused Practice",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 55),
              Text(
                "Select Difficulty",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1E293B),
                ),
              ),
              SizedBox(height: 15),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Color(0xFF0A898D),
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: Color(0xFF0A898D),
                  overlayColor: Color(0xFF0A898D).withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: _difficultyValue,
                  min: 0,
                  max: 2,
                  divisions: 2,
                  onChanged: (value) {
                    setState(() {
                      _difficultyValue = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Beginner",
                      style: TextStyle(
                        color: _difficultyValue == 0
                            ? Color(0xFF0A898D)
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      "Intermediate",
                      style: TextStyle(
                        color: _difficultyValue == 1
                            ? Color(0xFF0A898D)
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      "Expert",
                      style: TextStyle(
                        color: _difficultyValue == 2
                            ? Color(0xFF0A898D)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 55),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF0A898D).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "${getSessionSettings()['time']} Mins | ${getSessionSettings()['questions']} Questions",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 55),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A898D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0A898D),
                        ),
                      ),
                    );

                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    UserModel? loggedInUser;

                    if (userId != null) {
                      var doc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get();
                      if (doc.exists) {
                        loggedInUser = UserModel.fromMap(doc.data()!);
                      }
                    }

                    String difficulty = _difficultyValue == 0
                        ? "Beginner"
                        : _difficultyValue == 1
                        ? "Intermediate"
                        : "Expert";

                    final provider = Provider.of<InterviewProvider>(
                      context,
                      listen: false,
                    );

                    final settings = getSessionSettings();
                    List<String> fetchedQuestions = [];
                    bool isSuccess = false;

                    try {
                      // Note: Use 10.0.2.2 instead of localhost if using an Android Emulator
                      var url = Uri.parse(
                        'https://codewithmh.pythonanywhere.com/get-questions',
                      );
                      Map<String, dynamic> cleanInterviewData = {
                  "title": widget.interview.title,
                  "categoryId": widget.interview.categoryId, // 3. FIXED: Never returns null now
                  "description": widget.interview.description,
                };
                      print("$cleanInterviewData + $selectedMode ");
                      var response = await http
                          .post(
                            url,
                            headers: {"Content-Type": "application/json"},
                            body: jsonEncode({
                              "interviewData": cleanInterviewData,
                              "mode": selectedMode,
                              "difficulty": difficulty,
                              "duration": settings['time'],
                              "questionCount": settings['questions'],
                              "user": loggedInUser?.toMap(),
                            }),
                          )
                          .timeout(const Duration(seconds: 30));

                      if (response.statusCode == 200) {
                        var decodedData = jsonDecode(response.body);
                        List<dynamic> questionsRaw = decodedData['questions'];

                        fetchedQuestions = questionsRaw
                            .map((item) => item['question'].toString())
                            .toList();

                        isSuccess = true;
                      } else {
                        print("Server Error: ${response.statusCode}");
                      }
                    } catch (e) {
                      print("Connection Error: $e");
                    } finally {
                      if (mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    }

                    if (!isSuccess || fetchedQuestions.isEmpty) {
                      return;
                    }

                    provider.updateSession(
                      data: widget.interview.toMap(),
                      mode: selectedMode,
                      diff: difficulty,
                      user: loggedInUser,
                      duration: settings['time']!,
                      questionCount: settings['questions']!,
                    );
                    provider.setQuestions(fetchedQuestions);

                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InterviewRoom(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Start Interview Now",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
