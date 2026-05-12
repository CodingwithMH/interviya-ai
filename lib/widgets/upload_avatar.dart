import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadAvatar extends StatefulWidget {
  final Function(File) onImageSelected;
  final File? initialImage;
  const UploadAvatar({super.key, required this.onImageSelected, this.initialImage});

  @override
  State<UploadAvatar> createState() => _UploadAvatarState();
}

class _UploadAvatarState extends State<UploadAvatar> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageFile = widget.initialImage;
  }

  final String cloudName = "dw5wdcchx";
  final String uploadPreset = "ml_default";

Future<void> _pickImage(ImageSource source) async {
  final XFile? pickedFile = await _picker.pickImage(
    source: source,
    imageQuality: 50,
  );

  if (pickedFile == null) return;

  File file = File(pickedFile.path);
  setState(() => _imageFile = file);
  
  // Pass the local file back to the parent
  widget.onImageSelected(file); 
}

  @override
  Widget build(BuildContext context) {
  return Stack(
    alignment: Alignment.center,
    clipBehavior: Clip.none,
    children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter , colors: [Color(0xff032627),Color(0xff0A898D)]),
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Color(0xffF3F4F6),
          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
          child: _imageFile == null ? Icon(
            Icons.person,
            size: 70,
            color: Color(0xff0A898D),
          ) : null,
        ),
      ),
      
      Positioned(
        bottom: -10,
        child: GestureDetector(
          onTap: () => _showSelectionDialog(context),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xff0A898D),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter , colors: [Color(0xff032627),Color(0xff0A898D)]),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
      ),
    ],
  );
  }
  void _showSelectionDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xff0A898D)),
              title: const Text('Photo Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xff0A898D)),
              title: const Text('Camera'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
}