import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interviya/screens/setup.dart';
import 'package:interviya/screens/sign_in.dart';
import 'package:interviya/screens/steps.dart';
import 'package:interviya/widgets/main_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:interviya/data/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // 1. Start the visual delay countdown
    final delay = Future.delayed(const Duration(seconds: 4));

    // 2. Read local onboard preferences concurrently
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool seenSteps = prefs.getBool('seenSteps') ?? false;

    // 3. Check simple Firebase Auth state
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // 🚀 USER IS LOGGED IN: Fetch Firestore document details into global state
      // Use listen: false because we are calling this inside a background method
      await Provider.of<UserProvider>(context, listen: false).fetchUser();
    }

    // Wait for the remaining time of the 4-second splash screen window
    await delay;

    if (!mounted) return;

    // 4. Advanced Evaluation Matrix
    if (firebaseUser != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;

      if (currentUser != null && currentUser.hasFinishedSetup == false) {
        _navigate(const Setup()); 
      } else {
        _navigate(const MainWrapper());
      }
    } else if (seenSteps) {
      _navigate(const SignIn()); 
    } else {
      _navigate(const Steps());
    }
  }

  void _navigate(Widget destination) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF8FAFC), Color(0xFFF8FAFC)],
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF8FAFC),
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xFFF8FAFC),
                ],
                stops: [0.0, 0.20, 0.80, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: Image.asset(
              "assets/images/splash_bg.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Image(
                      image: AssetImage("assets/images/logo.png"),
                      height: 80,
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Intervya AI",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}