import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:interviya/widgets/custom_appbar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String selectedCategory = "Bug Report";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<String> categories = [
    "Bug Report",
    "UI/UX Issue",
    "Feature Suggestion",
    "General Query",
  ];

  Future<void> _sendEmailViaNativeApp() async {
    final String adminEmail = "hammad90191@gmail.com";
    final String subject = Uri.encodeComponent(
      "[$selectedCategory] User Feedback - Interviya",
    );

    final String body = Uri.encodeComponent(
      "User Email: ${_emailController.text}\n\n"
      "Message:\n${_messageController.text}",
    );

    final Uri mailUri = Uri.parse(
      "mailto:$adminEmail?subject=$subject&body=$body",
    );

    try {
      if (await canLaunchUrl(mailUri)) {
        await launchUrl(mailUri, mode: LaunchMode.externalApplication);
      } else {
        throw "Could not open mail application.";
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error opening mail client: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: CustomAppbar(
        text: "Setup Interview",
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.09,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/User_Feedback.png",
                  height: size.height * 0.18,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 10),
              _sectionTitle("Category"),
              SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    child: categoryItem(
                      categories[index],
                      selectedCategory == categories[index],
                    ),
                  );
                },
              ),

              SizedBox(height: 10),
              _sectionTitle("Your Email"),
              SizedBox(height: 10),
              _buildTextField(
                controller: _emailController,
                hint: "example@mail.com",
                icon: Icons.email,
              ),

              SizedBox(height: 10),
              _sectionTitle("Your Message"),
              SizedBox(height: 10),
              _buildMessageField(),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A898D),
                    elevation: 5,
                    shadowColor: Color(0xFF0A898D).withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    if (_emailController.text.trim().isEmpty ||
                        _messageController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please fill out all fields before sending.",
                          ),
                        ),
                      );
                      return;
                    }

                    await _sendEmailViaNativeApp();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Feedback Sent Successfully!")),
                    );
                  },

                  child: Text(
                    "Send Feedback",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xff1E293B),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E293B).withValues(alpha: 0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xff94A3B8), fontSize: 14),
          prefixIcon: Icon(icon, color: Color(0xff0A898D)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildMessageField() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E293B).withValues(alpha: 0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _messageController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: "Tell us what's on your mind...",
          hintStyle: TextStyle(color: Color(0xff94A3B8), fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget categoryItem(String title, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF0A898D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : Color(0xFF0A898D).withValues(alpha: 0.2),
        ),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Color(0xff1E293B).withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF0A898D),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
