import 'package:flutter/material.dart';
import 'package:flutter_project/data/services/auth_service.dart';
import 'package:flutter_project/screens/sign_in.dart';
import 'package:flutter_project/widgets/custom_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  bool obsecure = true;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  void handleSignUp() async {
    if (!_formkey.currentState!.validate()) return;

    setState(() => isLoading = true);

    String? result = await AuthService().signUpUser(
      email: email.text,
      password: password.text,
      username: username.text,
    );
    if (!mounted) return;
    setState(() => isLoading = false);

    if (result == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created!"),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } else {
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
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return "Please enter valid username!";
                        }
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
                        padding: EdgeInsets.symmetric(vertical: 12),
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
