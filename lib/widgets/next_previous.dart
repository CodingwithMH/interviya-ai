import 'package:flutter/material.dart';

class NextPrevious extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  const NextPrevious({super.key, required this.onPrevious, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: onPrevious, 
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                style: IconButton.styleFrom(
              elevation: 8,
              shadowColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              backgroundColor: Color(0xff0A898D),
              foregroundColor: Colors.white,
            ),),
              IconButton(
                onPressed: onNext, 
                icon: Icon(Icons.arrow_forward_ios_rounded),
                style: IconButton.styleFrom(
              elevation: 8,
              shadowColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              backgroundColor: Color(0xff0A898D),
              foregroundColor: Colors.white,
            ),)
            ],
          );
  }
}