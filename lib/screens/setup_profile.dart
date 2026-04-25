import 'package:flutter/material.dart';
import 'package:app_projects/navigation_menu.dart';

import 'dart:math' as math;

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  String? selectedStatus;
  final PageController _pageController = PageController();
  int _currentStep = 0;
  int? selectedExperience;
  int? selectedGoalIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              angle: math.pi,
              child: Image.asset(
                "assets/images/wave.png",
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 100, left: 50, right: 50, bottom: 30),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Step ${_currentStep + 1}/3",
                    style: TextStyle(
                      color: Color(0xff0A898D),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: _buildStepBar(isActive: index <= _currentStep),
                    );
                  }),
                ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [
                      _buildStep1Content(),

                      _buildStep2Content(),

                      _buildStep3Content(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 120),
              child: SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentStep < 2) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainWrapper()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0A898D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentStep == 2 ? "Explore Dashboard" : "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Content() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "Setup Your Profile",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 45),

          Center(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xff0A898D), width: 4),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xff0A898D),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(0, 10),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(0xff0A898D),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 55),

          _buildTextField("Full Name", Icons.person),
          SizedBox(height: 20),
          _buildDropdown(),
          SizedBox(height: 20),
          _buildTextField("Target Role", Icons.track_changes),

          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildStep2Content() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "What is your\nexperience level?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xff1E293B),
            ),
          ),
          SizedBox(height: 40),

          _buildExperienceCard(
            index: 0,
            icon: Icons.grass_rounded,
            title: "Beginner / Student",
            subtitle: "0 - 1 years of experience",
          ),
          _buildExperienceCard(
            index: 1,
            icon: Icons.rocket_launch_rounded,
            title: "Intermediate",
            subtitle: "1 - 4 years of experience",
          ),
          _buildExperienceCard(
            index: 2,
            icon: Icons.workspace_premium_rounded,
            title: "Senior / Expert",
            subtitle: "5+ years of experience",
          ),

          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildStep3Content() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "What’s your main\ngoal?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xff1E293B),
            ),
          ),
          SizedBox(height: 40),

          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.9,
            children: [
              _buildGoalCard(
                0,
                Icons.track_changes_rounded,
                "Crack a\nSpecific\nInterview",
              ),
              _buildGoalCard(
                1,
                Icons.record_voice_over_rounded,
                "Improve\nCommunication",
              ),
              _buildGoalCard(
                2,
                Icons.computer_rounded,
                "Master\nTechnical\nRound",
              ),
              _buildGoalCard(
                3,
                Icons.bar_chart_rounded,
                "Get\nPerformance\nInsights",
              ),
            ],
          ),

          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildStepBar({required bool isActive}) {
    return Container(
      height: 6,
      width: 60,
      decoration: BoxDecoration(
        color: isActive ? Color(0xff0A898D) : Color(0xff94A3B8),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon) {
    return Container(
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
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xff94A3B8)),
          prefixIcon: Icon(icon, color: Color(0xff0A898D)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
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
      child: DropdownButtonFormField(
        initialValue: selectedStatus,
        hint: Text("Current Status"),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.work, color: Color(0xff0A898D)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
        items: [
          "Student",
          "Professional",
          "Seeking Job",
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) => setState(() => selectedStatus = val),
      ),
    );
  }

  Widget _buildGoalCard(int index, IconData icon, String title) {
    bool isSelected = selectedGoalIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoalIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Color(0xff0A898D) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xff1E293B).withValues(alpha: .06),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Color(0xff0A898D)),
            SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff0A898D),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = selectedExperience == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedExperience = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected ? Color(0xff0A898D) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xff1E293B).withValues(alpha: 0.08),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xff0A898D).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xff0A898D), size: 30),
            ),
            SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff0A898D),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Color(0xff94A3B8), fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
