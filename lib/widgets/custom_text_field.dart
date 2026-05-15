import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.onChanged,
    this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
Widget build(BuildContext context) {
  return Material(
    elevation: 4, 
    shadowColor: Colors.black26,
    borderRadius: BorderRadius.circular(16),
    color: Colors.transparent,
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: Icon(icon, color: const Color(0xff0A898D), size: 24),
        ),
        suffixIcon: suffixIcon,
        
        errorStyle: const TextStyle(
          fontSize: 12, 
          height: 1.1,
        ),
      ),
    ),
  );
}
}