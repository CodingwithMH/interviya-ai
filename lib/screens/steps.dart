import 'package:flutter/material.dart';
import 'package:flutter_project/screens/login.dart';

class Steps extends StatefulWidget {
  const Steps({super.key});

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  int currentIndex = 0;
  bool isNavigating = false;
  final List<Map<String, String>> steps = [
    {
      "image": "interview.png",
      "heading": "Master Your Next Interview",
      "description":
          "Practice with AI-powered mock interviews and get instant feedback",
    },
    {
      "image": "speaker.png",
      "heading": "AI Voice Analysis",
      "description":
          "Get real-time feedback on your tone, confidence level, and use of filler words like 'umm' or 'like'",
    },
    {
      "image": "track_growth.png",
      "heading": "Track Your Growth",
      "description":
          "Identify your weak spots with detailed analytics and improve with every mock interview",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8FAFC),
    body: Stack(
      children: [
        Positioned(child: Image.asset("assets/images/wave.png")),
        Padding(
          padding: EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Login()));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xff0A898D),
                    ),
                    child: Text(
                      "skip",
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xff0A898D),
                        decorationThickness: 2,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0A898D),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/${steps[currentIndex]['image']!}",
                    height: 300,
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              Expanded(child: Container()),
              Text(
                steps[currentIndex]["heading"]!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                  color: Color(0xff1E293B),
                ),
              ),
              Text(
                steps[currentIndex]["description"]!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff64748B),fontSize: 20),
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: List.generate(3, (index) => buildDot(index))),
                  Material(
                    color: const Color(0xff0A898D),
                    shape: const CircleBorder(),
                    elevation: 8,
                    child: IconButton( 
                      onPressed: () {
                          if (currentIndex < steps.length - 1) {
                               setState(() {
                                   currentIndex++;
                               });
                               } else {
                                  if (isNavigating) return;
                                  isNavigating = true;
                                  if (!mounted) return;
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Login()),
                          );
                        }
                       },                      
                      padding: EdgeInsets.all(16),
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }

  Widget buildDot(int index) {
    bool isActive = index == currentIndex;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff0A898D) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}