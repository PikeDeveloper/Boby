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
    return Material(
      color: Colors.transparent,
      elevation: 6,
      shadowColor: Colors.black26,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
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
                          Color.fromARGB(255, 78, 72, 255),
                          Color.fromARGB(255, 53, 97, 240)
                        ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: borderRadius,
            border: Border.all(
              color: isError
                  ? const Color(0xFFE57373)
                  : isCorrect
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF4527A0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Center(child: child),
        ),
      ),
    );
  }
}
