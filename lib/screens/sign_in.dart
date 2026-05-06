import 'package:flutter/material.dart';
import 'package:flutter_project/screens/sign_up.dart';
import 'package:flutter_project/widgets/custom_text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController username= TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF8FAFC),
      body: Form(
        key: formkey,
        child: Stack(
          children: [
            Positioned(
              child: Image.asset("assets/images/wave.png", fit: BoxFit.cover),
            ),
            SingleChildScrollView(
  child: Padding(
              padding: EdgeInsets.only(
                top: 100,
                left: 30,
                right: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset("assets/images/login.png", height: screenHeight*0.20,),
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
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hintText: "Password",
                  icon: Icons.lock,
                  controller: password,
                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Color(0xff0A898D),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color(0xff0A898D),
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Sign In", style: TextStyle(fontSize: 22)),
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
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white
                  ),
                  icon: Image.asset('assets/images/google_logo.png', height: 24),
                  label: Text('Sign in with Google', style: TextStyle(fontSize: 22, color: Colors.black),),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(onPressed: (){
                      Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                );
                    }, style: TextButton.styleFrom(foregroundColor: Color(0xff0A898D)), child: Text("Sign Up"),)
                  ],
                )
              ],
            ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
