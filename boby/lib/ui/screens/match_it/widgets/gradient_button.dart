/*import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isError;
  final bool isCorrect;
  const GradientButton(
      {super.key,
      required this.child,
      required this.onTap,
      this.isError = false,
      this.isCorrect = false});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
             
            ),
            child: Center(child: child),
          ),
        ),
        if (isError || isCorrect)
          Container(
            color: (isError ? Colors.red : Colors.green).withOpacity(0.3),
            child: Center(
              child: Icon(
                isError ? Icons.close : Icons.check,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
      ],
    );
  }
}*/
