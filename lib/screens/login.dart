import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_projects/screens/signup.dart';
import 'package:app_projects/screens/profileSetup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 700;

    return Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/images/wave.png", fit: BoxFit.cover),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.1,
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.05),

                    Image.asset(
                      "assets/images/login.png",
                      height: isSmallScreen ? 170 : 250,
                      width: screenSize.width * 0.7,
                      fit: BoxFit.contain,
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
                        color: Color(0xff94A3B8),
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 20),

                    _buildInputField(hint: "Email Address", icon: Icons.email),

                    SizedBox(height: 10),

                    _buildInputField(
                      hint: "Password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),

                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileSetup(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0A898D),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Color(0xff1E293B),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffE5E7EB), width: 1),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff1E293B).withValues(alpha: 0.05),
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
                              height: 22,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Continue with Google",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

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
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
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
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E293B).withValues(alpha: 0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xff94A3B8), fontSize: 14),
          prefixIcon: Icon(icon, color: Color(0xff0A898D), size: 22),
          suffixIcon: isPassword
              ? Icon(
                  Icons.visibility_outlined,
                  color: Color(0xff0A898D),
                  size: 22,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}
