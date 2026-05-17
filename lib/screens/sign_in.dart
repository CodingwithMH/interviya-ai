import 'package:flutter/material.dart';
import 'package:interviya/data/models/user_model.dart';
import 'package:interviya/data/providers/user_provider.dart';
import 'package:interviya/data/services/auth_service.dart';
import 'package:interviya/screens/forgot_password.dart';
import 'package:interviya/screens/setup.dart';
import 'package:interviya/screens/sign_up.dart';
import 'package:interviya/widgets/custom_text_field.dart';
import 'package:interviya/widgets/main_wrapper.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  bool isGoogleLoading = false;
  bool obsecure = true;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  void handleGoogleSignIn() async {
    if (isGoogleLoading) return;
    setState(() => isGoogleLoading = true);
    
    try {
      String? result = await AuthService().signInWithGoogle();

      if (!mounted) return;

      if (result == "success") {
        UserModel? userProfile = await AuthService().getUserData();

        if (!mounted) return;
        setState(() => isGoogleLoading = false);

        if (userProfile != null) {
          Provider.of<UserProvider>(context, listen: false).setUser(userProfile);

          if (userProfile.hasFinishedSetup == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainWrapper()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Setup()),
            );
          }
        }
      } else {
        setState(() => isGoogleLoading = false);
        if (result != "canceled") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result ?? "An error occurred during Google Sign-In"),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isGoogleLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Exception: $e")),
      );
    }
  }

  void handleSignIn() async {
    if (!_formkey.currentState!.validate()) return;
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      String? result = await AuthService().signInUser(
        email: email.text.trim(),
        password: password.text,
      );

      if (!mounted) return; 

      if (result == "success") {
        UserModel? userProfile = await AuthService().getUserData();

        if (!mounted) return;
        setState(() => isLoading = false);

        if (userProfile != null) {
          Provider.of<UserProvider>(context, listen: false).setUser(userProfile);

          if (userProfile.hasFinishedSetup == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainWrapper()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Setup()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to retrieve user profile configuration."),
            ),
          );
        }
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result ?? "An error occurred")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication process failed: $e")),
      );
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Stack(
            children: [
              Positioned(
                child: Image.asset("assets/images/wave.png", fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 30,
                  right: 30,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      "assets/images/login.png",
                      height: screenHeight * 0.20,
                    ),
                    const Text(
                      "Welcome Back!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: Color(0xff1E293B),
                      ),
                    ),
                    const Text(
                      "Login To Continue Your Prep",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff64748B)),
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      hintText: "Email Address",
                      icon: Icons.mail,
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(
                          r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$",
                        ).hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hintText: "Password",
                      icon: Icons.lock,
                      controller: password,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        },
                        child: Icon(
                          obsecure
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xff0A898D),
                        ),
                      ),
                      obscureText: obsecure,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8), 
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xff0A898D),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isLoading ? null : handleSignIn,
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: const Color(0xff0A898D),
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Sign In",
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "OR",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff64748B)),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: isGoogleLoading ? null : handleGoogleSignIn,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white70,
                      ),
                      icon: isGoogleLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xff0A898D),
                              ),
                            )
                          : Image.asset(
                              'assets/images/google_logo.png',
                              height: 22,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata),
                            ),
                      label: Text(
                        isGoogleLoading ? 'Connecting...' : 'Sign in with Google',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(color: Color(0xff0A898D)),
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
        ),
      ),
    );
  }
}
