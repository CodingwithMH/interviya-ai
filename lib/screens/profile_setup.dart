import 'package:flutter/material.dart';
import "dart:math" as math;

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});
  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final int currentIndex = 1;
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
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 30),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Step $currentIndex/3",
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
                          children: List.generate(
                            3,
                            (index) => buildLine(index + 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
        margin: EdgeInsets.symmetric( horizontal: 4 ),
        height: 4,
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
