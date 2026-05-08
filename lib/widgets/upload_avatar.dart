import 'package:flutter/material.dart';

class UploadAvatar extends StatefulWidget {
  const UploadAvatar({super.key});

  @override
  State<UploadAvatar> createState() => _UploadAvatarState();
}

class _UploadAvatarState extends State<UploadAvatar> {
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
        child: const CircleAvatar(
          radius: 50,
          backgroundColor: Color(0xffF3F4F6),
          child: Icon(
            Icons.person,
            size: 70,
            color: Color(0xff0A898D),
          ),
        ),
      ),
      
      Positioned(
        bottom: -10,
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
    ],
  );
  }
}