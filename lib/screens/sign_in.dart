import 'package:flutter/material.dart';
import 'package:flutter_project/data/models/user_model.dart';
import 'package:flutter_project/data/services/auth_service.dart';
import 'package:flutter_project/screens/setup.dart';
import 'package:flutter_project/screens/sign_up.dart';
import 'package:flutter_project/widgets/custom_text_field.dart';
import 'package:flutter_project/widgets/main_wrapper.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  bool obsecure = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  void handleSignIn() async {
  if (!_formkey.currentState!.validate()) return;

  setState(() => isLoading = true);

  String? result = await AuthService().signInUser(
    email: email.text,
    password: password.text,
  );

  if (result == "success") {
    UserModel? userProfile = await AuthService().getUserData(); 

    setState(() => isLoading = false);

    if (mounted) {
      if (userProfile != null && userProfile.hasFinishedSetup == true) {
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
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result ?? "An error occurred")),
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
                      "assets/images/login.png",
                      height: screenHeight * 0.20,
                    ),
                    Text(
                      "Welcome Back!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: Color(0xff1E293B),
                      ),
                    ),
                    Text(
                      "Login To Continue Your Prep",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff64748B)),
                    ),
                    SizedBox(height: 25),
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
                        onTap: (){setState(() {
                          obsecure = !obsecure;
                        });},
                      child: Icon(
                        obsecure ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,
                        color: Color(0xff0A898D),
                      ),
                      ), 
                      obscureText: obsecure,
                      validator: (value) {
                        if (value == null) {
                          return "Password must be valid";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isLoading ? null : handleSignIn,
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Color(0xff0A898D),
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign In",
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.white,
                      ),
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        height: 22,
                      ),
                      label: Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          child: Text(
                            "Sign Up",
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
