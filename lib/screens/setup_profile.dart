import 'package:flutter/material.dart';
import 'package:flutter_project/navigation_menu.dart';
import 'dart:math' as math;

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  String fullName = "";
  String targetRole = "";
  String? selectedStatus;
  String? selectedExperienceTitle;
  String? selectedGoalTitle;
  int? selectedExperienceIndex;
  int? selectedGoalIndex;

  void _printSavedData() {
    print("""
      --- User Profile Data ---
      Name: $fullName
      Status: $selectedStatus
      Role: $targetRole
      Experience: $selectedExperienceTitle
      Goal: $selectedGoalTitle
    """);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.height < 700;

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
                width: size.width * 0.7,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.06),
                Text(
                  "Step ${_currentStep + 1}/3",
                  style: TextStyle(
                    color: Color(0xff0A898D),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return _buildStepBar(
                      isActive: index <= _currentStep,
                      width: size.width * 0.2,
                    );
                  }),
                ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) =>
                        setState(() => _currentStep = index),
                    children: [
                      _buildStep1Content(size, isSmallScreen),
                      _buildStep2Content(size),
                      _buildStep3Content(size),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: SizedBox(
                    width: size.width * 0.6,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep < 2) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _printSavedData();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainWrapper(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0A898D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentStep == 2 ? "Explore Dashboard" : "Continue",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Content(Size size, bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),
          Text(
            "Setup Your Profile",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff1E293B),
            ),
          ),
          SizedBox(height: 30),

          Center(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xff0A898D), width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xff0A898D),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(0xff0A898D),
                    child: Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          _buildTextField("Full Name", Icons.person, (val) => fullName = val),
          SizedBox(height: 15),
          _buildDropdown(),
          SizedBox(height: 15),
          _buildTextField(
            "Target Role",
            Icons.track_changes,
            (val) => targetRole = val,
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildStep2Content(Size size) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.07),
          Text(
            "What is your\nexperience level?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xff1E293B),
            ),
          ),
          SizedBox(height: 30),
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
        ],
      ),
    );
  }

  Widget _buildStep3Content(Size size) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),
          Text(
            "What’s your main\ngoal?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xff1E293B),
            ),
          ),
          SizedBox(height: 30),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 20,
            childAspectRatio: 1.1,
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
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStepBar({required bool isActive, required double width}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: width,
      decoration: BoxDecoration(
        color: isActive ? Color(0xff0A898D) : Color(0xffCBD5E1),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon,
    Function(String) onChanged,
  ) {
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
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xff94A3B8), fontSize: 14),
          prefixIcon: Icon(icon, color: Color(0xff0A898D)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.only(right: 10),
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
      child: DropdownButtonFormField<String>(
        value: selectedStatus,
        hint: Text(
          "Current Status",
          style: TextStyle(color: Color(0xff94A3B8), fontSize: 14),
        ),

        decoration: InputDecoration(
          prefixIcon: Icon(Icons.work, color: Color(0xff0A898D)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildExperienceCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = selectedExperienceIndex == index;
    return GestureDetector(
      onTap: () => setState(() {
        selectedExperienceIndex = index;
        selectedExperienceTitle = title;
      }),
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
              color: Color(0xff1E293B).withValues(alpha: 0.1),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xff0A898D), size: 30),
            SizedBox(width: 15),
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

  Widget _buildGoalCard(int index, IconData icon, String title) {
    bool isSelected = selectedGoalIndex == index;
    return GestureDetector(
      onTap: () => setState(() {
        selectedGoalIndex = index;
        selectedGoalTitle = title.replaceAll('\n', ' ');
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Color(0xff0A898D) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xff1E293B).withValues(alpha: 0.1),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xff0A898D)),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xff0A898D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
