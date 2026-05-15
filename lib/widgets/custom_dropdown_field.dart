import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: Color(0xff1E293B))),
          );
        }).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xff0A898D)),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          prefixIcon: Icon(
            icon,
            color: const Color(0xff0A898D),
            size: 24,
          ),
        ),
      ),
    );
  }
}