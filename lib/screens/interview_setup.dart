import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/data/models/user_model.dart';
import 'package:flutter_project/data/providers/interview_provider.dart';
import 'package:flutter_project/screens/interview_room.dart';
import 'package:provider/provider.dart';

class InterviewSetup extends StatefulWidget {
  final Map<String, dynamic> interview;
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Color(0xFF0A898D),
          elevation: 0,
          centerTitle: false,
          leading: Padding(
            padding: EdgeInsets.only(top: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Setup Interview",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
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
                      widget.interview['icon'],
                      color: Color(0xFF0A898D),
                      size: 30,
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: Text(
                        widget.interview['title'],
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
                      child: modeCard(
                        "Full Mock\nInterview",
                        Icons.emoji_events_outlined,
                        selectedMode == "Full Mock",
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => selectedMode = "Focused Practice"),
                      child: modeCard(
                        "Focused\nPractice",
                        Icons.track_changes,
                        selectedMode == "Focused Practice",
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
                    print(loggedInUser?.mainGoal);

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

                    provider.updateSession(
                      data: widget.interview,
                      mode: selectedMode,
                      diff: difficulty,
                      user: loggedInUser,
                      duration: settings['time']!,
                      questionCount: settings['questions']!,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InterviewRoom(),
                      ),
                    );
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

  Widget modeCard(String title, IconData icon, bool isSelected) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? Color(0xFF0A898D) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E293B).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: isSelected ? Color(0xFF0A898D) : Colors.grey,
          ),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Color(0xFF0A898D) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
