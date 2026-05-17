import 'package:flutter/material.dart';
import 'package:interviya/data/models/user_model.dart';
import 'package:interviya/data/providers/user_provider.dart';
import 'package:interviya/data/services/auth_service.dart';
import 'package:interviya/screens/setup.dart';
import 'package:interviya/screens/sign_in.dart';
import 'package:interviya/widgets/custom_text_field.dart';
import 'package:interviya/widgets/main_wrapper.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  bool isGoogleLoading = false;
  bool obsecure = true;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

void handleGoogleSignIn() async {
    setState(() => isGoogleLoading = true);
    String? result = await AuthService().signInWithGoogle();
    
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
      if (!mounted) return;
      setState(() => isGoogleLoading = false);
      if (result != "canceled") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result ?? "An error occurred during Google Sign-In"),
          ),
        );
      }
    }
  }

  void handleSignUp() async {
    if (!_formkey.currentState!.validate()) return;

    setState(() => isLoading = true);

    String? result = await AuthService().signUpUser(
      email: email.text,
      password: password.text,
      username: username.text,
    );
    
    if (!mounted) return;
    
    if (result == "success") {
      UserModel? userProfile = await AuthService().getUserData();
      
      if (!mounted) return;
      setState(() => isLoading = false);

      if (userProfile != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(userProfile);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created!"),
          duration: Duration(seconds: 2),
        ),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Setup()),
      );
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? "An error occurred"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Stack(
            children: [
              Positioned(
                child: Image.asset("assets/images/wave.png", fit: BoxFit.cover),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 100,
                  left: 30,
                  right: 30,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      "assets/images/signup.png",
                      height: screenHeight * 0.20,
                    ),
                    Text(
                      "Create Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: Color(0xff1E293B),
                      ),
                    ),
                    Text(
                      "Join us to ace your next interview",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff64748B)),
                    ),
                    SizedBox(height: 25),
                    CustomTextField(
                      hintText: "Username",
                      icon: Icons.person,
                      controller: username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a username!";}
                        if (value.length < 3) {
                          return "Username must be at least 3 characters long!";}
                        final usernameRegex = RegExp(r'^[A-Za-z\d@$!%*#?&^._+-]+$');
                        if (!usernameRegex.hasMatch(value)) {
                          return "Must contain letters, numbers, and special characters!";}
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
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
                    SizedBox(height: 10),
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
                          color: Color(0xff0A898D),
                        ),
                      ),
                      obscureText: obsecure,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isLoading ? null : handleSignUp,
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Color(0xff0A898D),
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign Up",
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "OR",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff64748B)),
                    ),
                    SizedBox(height: 15),
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
                            ),
                      label: Text(
                        isLoading ? 'Connecting...' : 'Sign in with Google',
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? "),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Color(0xff0A898D)),
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
