import 'dart:math';

import 'package:flutter/material.dart';

class WordGuessWord extends StatelessWidget {
  WordGuessWord({
    super.key,
  });

  final List<String> lettersGuess = [
    "G",
    "U",
    "E",
    "S",
    "S",
  ];
  final List<String> lettersThe = [
    "T",
    "H",
    "E",
  ];
  final List<String> lettersWord = [
    "W",
    "O",
    "R",
    "D",
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final minSize = min(screenWidth, screenHeight);

    final letterSize = minSize / 15;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var letter in lettersGuess)
          Image.asset(
            "assets/letters_2/$letter.png",
            height: letterSize.toDouble(),
          ),
        const SizedBox(width: 16),
        for (var letter in lettersThe)
          Image.asset(
            "assets/letters_2/$letter.png",
            height: letterSize.toDouble(),
          ),
        const SizedBox(width: 16),
        for (var letter in lettersWord)
          Image.asset(
            "assets/letters_2/$letter.png",
            height: letterSize.toDouble(),
          ),
      ],
    );
  }
}
