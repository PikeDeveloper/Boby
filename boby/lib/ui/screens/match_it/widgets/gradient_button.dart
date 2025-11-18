import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            colors: isError
                ? const [
                    Color.fromARGB(255, 245, 159, 159),
                    Color.fromARGB(255, 254, 131, 131)
                  ]
                : isCorrect
                    ? const [
                        Color.fromARGB(255, 76, 175, 80),
                        Color.fromARGB(255, 56, 142, 60)
                      ]
                    : const [
                        Colors.transparent,
                        Color.fromARGB(134, 53, 97, 240)
                      ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
