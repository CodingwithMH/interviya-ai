import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadAvatar extends StatefulWidget {
  final Function(String) onImageUpload;
  const UploadAvatar({super.key, required this.onImageUpload});

  @override
  State<UploadAvatar> createState() => _UploadAvatarState();
}

class _UploadAvatarState extends State<UploadAvatar> {
  File? _imageFile;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  final String cloudName = "dw5wdcchx";
  final String uploadPreset = "ml_default";

Future<void> _uploadToCloudinary(ImageSource source) async {
  final XFile? pickedFile = await _picker.pickImage(
    source: source,
    imageQuality: 50,
  );

  if (pickedFile == null) return;

  setState(() {
    _imageFile = File(pickedFile.path);
    _isUploading = true;
  });

  try {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    // 1. Create the request
    var request = http.MultipartRequest('POST', url);

    // 2. Add fields
    request.fields['upload_preset'] = uploadPreset;

    // 3. Add the file using fromPath (specifically for Mobile/dart:io)
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', 
        pickedFile.path, // Use the path from XFile directly
      ),
    );

    // 4. Send and get response
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String secureUrl = jsonResponse['secure_url'];
      widget.onImageUpload(secureUrl);
    } else {
      throw Exception("Cloudinary upload failed: ${response.body}");
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isUploading = false);
    }
  }
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
          onTap: _isUploading ? null : () => _showSelectionDialog(context),
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
                _uploadToCloudinary(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xff0A898D)),
              title: const Text('Camera'),
              onTap: () {
                _uploadToCloudinary(ImageSource.camera);
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