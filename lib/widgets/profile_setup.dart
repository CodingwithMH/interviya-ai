import 'dart:io';

import 'package:flutter/material.dart';
import 'package:interviya/widgets/next_previous.dart';
import 'package:interviya/data/models/user_model.dart';
import 'package:interviya/widgets/custom_dropdown_field.dart';
import 'package:interviya/widgets/custom_text_field.dart';
import 'package:interviya/widgets/upload_avatar.dart';

class ProfileSetup extends StatefulWidget {
  final Function(UserModel) onUpdate;
  final Function(File) onFileChanged;
  final File? localImageFile;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final UserModel currentUser;

  const ProfileSetup({
    super.key,
    required this.onFileChanged,
    required this.localImageFile,
    required this.onNext,
    required this.onPrevious,
    required this.onUpdate,
    required this.currentUser,
  });

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  late TextEditingController nameController;
  late TextEditingController roleController;
  String? selectedStatus;
  final List<String> statusOptions = [
    "Student",
    "Professional",
    "Freelancer",
    "Job Seeker",
  ];
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentUser.fullName);
    roleController = TextEditingController(text: widget.currentUser.targetRole);
  }

  void _notifyParent() {
    setState((){
    widget.currentUser.fullName = nameController.text;
  widget.currentUser.targetRole = roleController.text;
    });
  
  widget.onUpdate(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    bool isFormValid = (widget.currentUser.fullName?.isNotEmpty ?? false) &&
                   (widget.currentUser.targetRole?.isNotEmpty ?? false) &&
                   (widget.currentUser.currentStatus != null);
    return Column(
        children: [
          UploadAvatar(
            initialImage: widget.localImageFile,
  onImageSelected: (File file) {
    widget.onFileChanged(file); 
    _notifyParent();
  },
          ),
          SizedBox(height: 60),
          CustomTextField(
            hintText: "Full Name",
            icon: Icons.person,
            controller: nameController,
            onChanged: (val) => _notifyParent(),
          ),
          SizedBox(height: 10),
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
          SizedBox(height: 10),
          CustomTextField(
            hintText: "Target Role",
            icon: Icons.ads_click,
            controller: roleController,
            onChanged: (val) => _notifyParent(),
          ),
          SizedBox(height: 20),
          NextPrevious(onPrevious: widget.onPrevious, onNext: isFormValid ? widget.onNext : () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields to continue")),
    );
    }
    ),
          // ElevatedButton(
          //   onPressed: widget.onContinue,
          //   style: ElevatedButton.styleFrom(
          //     elevation: 8,
          //     padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          //     backgroundColor: Color(0xff0A898D),
          //     foregroundColor: Colors.white,
          //   ),
          //   child: Text("Continue", style: TextStyle(fontSize: 22)),
          // ),
        ],
    );
  }
}
