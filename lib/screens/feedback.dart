import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Color(0xFF0A898D),
          elevation: 0,
          centerTitle: false,
          leading: Padding(
            padding: EdgeInsets.only(top: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Feedback",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/User_Feedback.png",
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1E293B),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: category("Bug Report", true)),
                SizedBox(width: 12),
                Expanded(child: category("UI/UX Issue", false)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: category("Feature Suggestion", false)),
                SizedBox(width: 12),
                Expanded(child: category("General Query", false)),
              ],
            ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  " Your Email",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1E293B),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                  hintText: "hammadtheta12@gmail.com",
                  hintStyle: TextStyle(color: Color(0xff94A3B8), fontSize: 14),
                  prefixIcon: Icon(Icons.email, color: Color(0xff0A898D)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  " Your Message",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1E293B),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff1E293B).withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: TextFormField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: "Tell us what's on your mind... we're all ears!",
                  hintStyle: TextStyle(color: Color(0xff94A3B8), fontSize: 14),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
             SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0A898D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Send Feedback",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget category(String title, bool isSelected) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: isSelected ? Color(0xFF0A898D) : Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Color(0xff1E293B).withValues(alpha: 0.1),
          blurRadius: 20,
          offset: Offset(0, 4),
        ),
      ],
    ),

    child: Center(
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Color(0xFF0A898D),
          fontSize: 16,
        ),
      ),
    ),
  );
}
