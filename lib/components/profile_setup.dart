import 'package:flutter/material.dart';
import 'package:flutter_project/data/models/user_model.dart';
import 'package:flutter_project/widgets/custom_dropdown_field.dart';
import 'package:flutter_project/widgets/custom_text_field.dart';
import 'package:flutter_project/widgets/upload_avatar.dart';

class ProfileSetup extends StatefulWidget {
  final Function(UserModel) onUpdate;
  final VoidCallback onContinue;
  final UserModel currentUser;
  
  const ProfileSetup({
  super.key, 
  required this.onContinue, 
  required this.onUpdate, 
  required this.currentUser
  });

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  late TextEditingController nameController;
  late TextEditingController roleController;
  String? selectedStatus;
  final List<String> statusOptions = ["Student", "Professional", "Freelancer", "Job Seeker"];
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentUser.fullName);
    roleController = TextEditingController(text: widget.currentUser.targetRole);
  }

  void _notifyParent() {
    widget.onUpdate(UserModel(
      fullName: nameController.text,
      targetRole: roleController.text,
      currentStatus: widget.currentUser.currentStatus,
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UploadAvatar(),
        SizedBox(height: 60,),
        CustomTextField(hintText: "Full Name", icon: Icons.person, controller: nameController,
          onChanged: (val) => _notifyParent(),),
        SizedBox(height: 10,),
        CustomDropdownField(
          hintText: "Current Status",
          icon: Icons.work_outline,
          items: statusOptions,
          value: widget.currentUser.currentStatus,
          onChanged: (newValue) {
            widget.currentUser.currentStatus = newValue;
            _notifyParent();
          },
        ),
        SizedBox(height: 10,),
        CustomTextField(hintText: "Target Role", icon: Icons.ads_click, controller: roleController,
          onChanged: (val) => _notifyParent(),),
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
