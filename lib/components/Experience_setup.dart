import 'package:flutter/material.dart';

class ExperienceSetup extends StatefulWidget {
  final VoidCallback onContinue;
  const ExperienceSetup({super.key, required this.onContinue});

  @override
  State<ExperienceSetup> createState() => _ExperienceSetupState();
}

class _ExperienceSetupState extends State<ExperienceSetup> {
  final List<Map<String, dynamic>> experiences = [
    {
      "icon": Icons.eco,
      "heading": "Beginner / Student",
      "sub_heading": "0 - 1 years of experience",
    },
    {
      "icon": Icons.rocket_launch,
      "heading": "Intermediate",
      "sub_heading": "1 - 4 years of experience",
    },
    {
      "icon": Icons.workspace_premium,
      "heading": "Senior / Expert",
      "sub_heading": "5+ years of experience",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 15,
      children: [
        ...experiences.map((item)=>
        Card(
          elevation: 3,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              spacing: 20,
              children: [
                Icon(item["icon"], size: 50, color: Color(0xff0A898D),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 1,
                  children: [
                    Text(item["heading"]!, style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xff0A898D)),),
                    Text(item["sub_heading"]!, style: TextStyle( fontSize: 16, color: Color(0xff0A898D)),)
                  ],
                )
              ],
            ),
          ),

        )
      ),
                    Align(
                      alignment: AlignmentGeometry.center,
                    child: ElevatedButton(
                      onPressed: widget.onContinue,
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        backgroundColor: Color(0xff0A898D),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Continue", style: TextStyle(fontSize: 22)),
                    ),
                    ),
                    ]
    );
  }
}