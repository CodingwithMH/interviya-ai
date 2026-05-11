import 'package:flutter/material.dart';
import 'package:flutter_project/components/next_previous.dart';

class GoalSetup extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onUpdate;
  final String? selectedGoal;
  const GoalSetup({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdate,
    this.selectedGoal,
  });
  @override
  State<GoalSetup> createState() => _GoalSetupState();
}

class _GoalSetupState extends State<GoalSetup> {
  String? currentGoal;
  final List<Map<String, dynamic>> goals = [
    {"icon": Icons.ads_click, "heading": "Crack a Specific Interview"},
    {"icon": Icons.record_voice_over, "heading": "Improve Communication"},
    {"icon": Icons.computer, "heading": "Master Technical Round"},
    {"icon": Icons.bar_chart_rounded, "heading": "Get Performance Insights"},
  ];
  @override
  void initState() {
    super.initState();
    currentGoal = widget.selectedGoal;
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: goals.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLandscape ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isLandscape ? 1.1 : 0.9,
              ),
              itemBuilder: (context, index) {
                final item = goals[index];
                bool isSelected = currentGoal == item["heading"];
                return GestureDetector(
                  onTap: () {
                    setState(() => currentGoal = item["heading"]);
                    widget.onUpdate(item["heading"]);
                  },
                  child: Card(
                    elevation: isSelected ? 8 : 2,
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xff0A898D)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item["icon"],
                            size: isLandscape ? 30 : 40,
                            color: const Color(0xff0A898D),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item["heading"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff0A898D),
                              fontSize: isLandscape ? 13 : 15,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 30),
        NextPrevious(
          onPrevious: widget.onPrevious,
          onNext: (widget.selectedGoal?.isNotEmpty ?? false)
              ? widget.onNext
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a goal!")),
                  );
                },
        ),
        // ElevatedButton(
        //   onPressed: widget.onContinue,
        //   style: ElevatedButton.styleFrom(
        //     elevation: 5,
        //     backgroundColor: const Color(0xff0A898D),
        //     foregroundColor: Colors.white,
        //     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(30),
        //     ),
        //   ),
        //   child: const Text(
        //     "Explore Dashboard",
        //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //   ),
        // ),
      ],
    );
  }
}
