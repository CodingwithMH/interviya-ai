import 'package:flutter/material.dart';

class ModeCard extends StatefulWidget {
  final bool isSelected;
  final String title;
  final IconData icon;
  const ModeCard({super.key,required this.icon, required this.isSelected, required this.title});

  @override
  State<ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<ModeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: widget.isSelected ? Color(0xFF0A898D) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E293B).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: 40,
            color: widget.isSelected ? Color(0xFF0A898D) : Colors.grey,
          ),
          SizedBox(height: 10),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.isSelected ? Color(0xFF0A898D) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}