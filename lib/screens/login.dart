import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_projects/screens/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: Stack(
        children: [
          Positioned(child: Image.asset("assets/images/wave.png")),
          Padding(
            padding: EdgeInsets.only(top: 100, left: 50, right: 50, bottom: 30),
            child: Column(
              children: [
                // Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/login.png",
                      height: 300,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                Text(
                  "Welcome Back!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color(0xff1E293B),
                  ),
                ),

                Text(
                  "Login To Continue Your Prep",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff64748B),
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff1E293B).withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      hintStyle: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.email, color: Color(0xff0A898D)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff1E293B).withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.lock, color: Color(0xff0A898D)),
                      suffixIcon: Icon(
                        Icons.visibility_outlined,
                        color: Color(0xff0A898D),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff0A898D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "OR",
                      style: TextStyle(color: Color(0xff1E293B), fontSize: 16),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 55,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffE5E7EB), width: 1),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff1E293B).withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/google_logo.png",
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Continue with google",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff0A0D2E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Color(0xff1E293B),
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(text: "Create an account "),
                          TextSpan(
                            text: "Signup",
                            style: TextStyle(
                              color: Color(0xff0A898D),
                              fontWeight: FontWeight.bold,
                            ),
                            // Click handle karne ke liye recognizer
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Yahan apni Signup screen ka route dein
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Signup(),
                                  ),
                                );
                              },
                          ),
                        ],
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
}
