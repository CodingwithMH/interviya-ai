import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/components/Experience_setup.dart';
import 'package:flutter_project/components/goal_setup.dart';
import 'package:flutter_project/components/profile_setup.dart';
import "dart:math" as math;

import 'package:flutter_project/data/models/user_model.dart';
import 'package:flutter_project/data/services/auth_service.dart';
import 'package:flutter_project/data/services/cloudinary_service.dart';
import 'package:flutter_project/widgets/main_wrapper.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});
  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  File? localImageFile;
  bool isUploading = false;
  UserModel user = UserModel();
  int currentIndex = 0;
  final List<String> stepHeadings = [
    "Setup Your Profile",
    "What's your experience level?",
    "What's your main goal?",
  ];
  void handleNext() async {
    if (currentIndex < 2) {
      setState(() {
        // currentIndex = (currentIndex + 1) % 3;
        currentIndex++;
      });
    } else {
      await _finalizeProfile();
    }
  }

  void handlePrevious() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        Navigator.pop(context);
      }
    });
  }

  Future<void> _finalizeProfile() async {
  setState(() => isUploading = true);

  try {
    if (localImageFile != null) {
      String? uploadedUrl = await CloudinaryService.uploadImage(
        localImageFile!,
      );
      if (uploadedUrl != null) {
        user.avatarPath = uploadedUrl;
      }
    }

    UserModel finalUser = UserModel(
      fullName: user.fullName,
      currentStatus: user.currentStatus,
      targetRole: user.targetRole,
      experienceLevel: user.experienceLevel,
      mainGoal: user.mainGoal,
      avatarPath: user.avatarPath,
      hasFinishedSetup: true,
    );

    String? result = await AuthService().updateUserProfile(finalUser);

    if (result == "success") {
      print("Profile successfully updated in Firestore");
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save profile: $result")),
        );
      }
    }
  } catch (e) {
    print("Error during finalization: $e");
  } finally {
    if (mounted) setState(() => isUploading = false);
  }
}

  Widget getStepComponent() {
    switch (currentIndex) {
      case 0:
        return ProfileSetup(
          currentUser: user,
          localImageFile: localImageFile,
          onFileChanged: (File file) => setState(() => localImageFile = file),
          onUpdate: (updatedData) => user = updatedData,
          onNext: handleNext,
          onPrevious: handlePrevious,
        );
      case 1:
        return ExperienceSetup(
          selectedExperience: user.experienceLevel,
          onUpdate: (val) => setState(() => user.experienceLevel = val),
          onNext: handleNext,
          onPrevious: handlePrevious,
        );
      case 2:
        return GoalSetup(
          selectedGoal: user.mainGoal,
          onUpdate: (val) => setState(() => user.mainGoal = val),
          onNext: handleNext,
          onPrevious: handlePrevious,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: SafeArea(
        child: Stack(
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
            Center(
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
                        fontSize: 30,
                        color: Color(0xff1E293B),
                      ),
                    ),
                    Expanded(child: Center(child: getStepComponent())),
                  ],
                ),
              ),
            ),
            if (isUploading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xff0A898D)),
                ),
              ),
          ],
        ),
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
