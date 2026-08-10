import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class WordMenu extends StatelessWidget {
  const WordMenu({super.key});

  final List<String> letters = const ["M", "E", "N", "U"];
  final double letterSize = 36;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFD54F), width: 3.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 24),
          const SizedBox(width: 6),
          for (int i = 0; i < letters.length; i++)
            BounceInDown(
              delay: Duration(milliseconds: 100 * i),
              duration: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Image.asset(
                  "assets/letters_2/${letters[i]}.png",
                  width: letterSize,
                  height: letterSize,
                ),
              ),
            ),
          const SizedBox(width: 6),
          const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 24),
        ],
      ),
    );
  }
}

