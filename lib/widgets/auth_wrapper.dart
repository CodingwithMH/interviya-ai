import 'package:flutter/material.dart';
import 'package:interviya/screens/home.dart';
import 'package:interviya/screens/setup.dart';
import 'package:interviya/screens/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:interviya/data/providers/user_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0A898D)),
        ),
      );
    }

    final user = userProvider.currentUser;

    if (user == null) {
      return const SignIn();
    }

    if (user.hasFinishedSetup == false) {
      return const Setup(); 
    }

    return const Home();
  }
}