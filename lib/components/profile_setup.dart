import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/custom_dropdown_field.dart';
import 'package:flutter_project/widgets/custom_text_field.dart';
import 'package:flutter_project/widgets/upload_avatar.dart';

class ProfileSetup extends StatefulWidget {
  final VoidCallback onContinue;
  const ProfileSetup({super.key, required this.onContinue});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  String? selectedStatus;
  final List<String> statusOptions = ["Student", "Professional", "Freelancer", "Job Seeker"];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UploadAvatar(),
        SizedBox(height: 60,),
        CustomTextField(hintText: "Full Name", icon: Icons.person),
        SizedBox(height: 10,),
        CustomDropdownField(
          hintText: "Current Status",
          icon: Icons.work_outline,
          items: statusOptions,
          value: selectedStatus,
          onChanged: (newValue) {
            setState(() {
              selectedStatus = newValue;
            });
          },
        ),
        SizedBox(height: 10,),
        CustomTextField(hintText: "Target Role", icon: Icons.ads_click),
        SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: widget.onContinue,
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        backgroundColor: Color(0xff0A898D),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Continue", style: TextStyle(fontSize: 22)),
                    ),
      ],
    );
  }
}
