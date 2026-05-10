import 'package:flutter/material.dart';
import 'package:flutter_project/components/Experience_setup.dart';
import 'package:flutter_project/components/goal_setup.dart';
import 'package:flutter_project/components/profile_setup.dart';
import "dart:math" as math;

import 'package:flutter_project/data/models/user_model.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});
  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  UserModel user = UserModel();
  int currentIndex = 0;
  final List<String> stepHeadings = [
    "Setup Your Profile",
    "What's your experience level?",
    "What's your main goal?",
  ];
  void handleSteps() {
    setState(() {
      // currentIndex = (currentIndex + 1) % 3;
      if (currentIndex < 2) {
        currentIndex++;
      } else {
        print("Final User Data: ${user.fullName}, ${user.currentStatus}");
      }
    });
  }

  Widget getStepComponent() {
    switch (currentIndex) {
      case 0:
        return ProfileSetup(
          currentUser: user,
          onUpdate: (updatedData) => user = updatedData,
          onContinue: handleSteps,
        );
      case 1:
        return ExperienceSetup(
          selectedExperience: user.experienceLevel,
          onUpdate: (val) => setState(() => user.experienceLevel = val),
          onContinue: handleSteps,
        );
      case 2:
        return GoalSetup(
          selectedGoal: user.mainGoal,
          onUpdate: (val) => setState(() => user.mainGoal = val),
          onContinue: handleSteps,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Transform.rotate(
              angle: math.pi,
              child: Image(
                image: AssetImage("assets/images/wave.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      "Step ${currentIndex + 1}/3",
                      style: TextStyle(
                        color: Color(0xff0A898D),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) => buildLine(index)),
                      ),
                    ),
                    Text(
                      stepHeadings[currentIndex],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: Color(0xff1E293B),
                      ),
                    ),
                    Spacer(),
                    Center(child: getStepComponent()),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLine(int index) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: index == currentIndex ? 7 : 4,
        decoration: BoxDecoration(
          color: index <= currentIndex
              ? const Color(0xff0A898D)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
