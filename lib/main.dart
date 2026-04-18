import 'package:flutter/material.dart';
import 'package:flutter_project/screens/splash_screen.dart';

void main() {
  runApp(const FlutterProject());
}

class FlutterProject extends StatelessWidget {
  const FlutterProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const SplashScreen());
  }
}


