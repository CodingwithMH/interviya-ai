import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

  Future<void> _uploadToCloudinary() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
      _isUploading = true;
    });

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      
      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          _imageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ));

      var response = await request.send();
      
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        
        String secureUrl = jsonResponse['secure_url']; 
        widget.onImageUpload(secureUrl);
      } else {
        throw Exception("Cloudinary upload failed: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isUploading = false);
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
          onTap: _isUploading ? null : _uploadToCloudinary,
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
}