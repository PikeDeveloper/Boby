import 'dart:math';

import 'package:flutter/material.dart';

class MatchItWord extends StatelessWidget {
  const MatchItWord({super.key});

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    final width = screensize.width;
    final height = screensize.height;
    final minSize = min(width, height);

    final letterSize = minSize / 9;

    List<String> lettersMatch = ["M", "A", "T", "C", "H"];
    List<String> lettersIt = [
      "I",
      "T",
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var letter in lettersMatch)
          Image.asset("assets/letters_2/$letter.png",
              width: letterSize, height: letterSize),
        const SizedBox(width: 16),
        for (var letter in lettersIt)
          Image.asset("assets/letters_2/$letter.png",
              width: letterSize, height: letterSize),
      ],
    );
  }
}
