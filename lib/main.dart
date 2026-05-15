import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:interviya/data/providers/interview_provider.dart';
import 'package:interviya/data/providers/user_provider.dart'; // 👈 Import your new UserProvider
import 'package:interviya/screens/sign_in.dart';
import 'package:interviya/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => InterviewProvider(
            interviewData: {},
            mode: "", 
            difficulty: "",
            duration: "",
            questionCount: ""
          ),
        ),
      ],
      child: const FlutterProject(),
    ),
  );
}

class FlutterProject extends StatelessWidget {
  const FlutterProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signin': (context) => const SignIn(),
      },
    );
  }
}