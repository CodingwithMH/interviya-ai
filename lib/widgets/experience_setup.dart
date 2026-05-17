import 'package:flutter/material.dart';
import 'package:interviya/widgets/next_previous.dart';

class ExperienceSetup extends StatefulWidget {
  final Function(String) onUpdate;
  final String? selectedExperience;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  const ExperienceSetup({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdate,
    required this.selectedExperience,
  });

  @override
  State<ExperienceSetup> createState() => _ExperienceSetupState();
}

class _ExperienceSetupState extends State<ExperienceSetup> {
  String? currentSelection;
  final List<Map<String, dynamic>> experiences = [
    {
      "icon": Icons.eco,
      "heading": "Beginner",
      "sub_heading": "0-1 years of experience",
    },
    {
      "icon": Icons.rocket_launch,
      "heading": "Intermediate",
      "sub_heading": "1-4 years of experience",
    },
    {
      "icon": Icons.workspace_premium,
      "heading": "Senior",
      "sub_heading": "5+ years of experience",
    },
  ];

  @override
  void initState() {
    super.initState();
    currentSelection = widget.selectedExperience;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 15,
      children: [
        ...experiences.map((item) {
          bool isSelected = currentSelection == item["heading"];
          return GestureDetector(
            onTap: () {
              setState(() => currentSelection = item["heading"]);
              widget.onUpdate(item["heading"]);
            },
            child: Card(
              elevation: isSelected ? 8 : 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? const Color(0xff0A898D) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  spacing: 20,
                  children: [
                    Icon(item["icon"], size: 50, color: const Color(0xff0A898D)),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 1,
                        children: [
                          Text(
                            item["heading"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xff0A898D),
                            ),
                          ),
                          Text(
                            item["sub_heading"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff0A898D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.center,
          child: NextPrevious(
            onPrevious: widget.onPrevious, 
            onNext: (widget.selectedExperience?.isNotEmpty ?? false)
                ? widget.onNext 
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select an experience level!")),
                    );
                  },
          ),
        ),
      ],
    );
  }
}