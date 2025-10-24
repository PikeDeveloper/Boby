import 'package:flutter/material.dart';

class BackgroundWord extends StatelessWidget {
  const BackgroundWord({super.key});

  final List<String> newLetters = const [
    "B",
    "A",
    "C",
    "K",
    "G",
    "R",
    "O",
    "U",
    "N",
    "D",
    "S",
  ];

  final double letterSize = 25;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          for (var letter in newLetters)
            Image.asset("assets/letters_2/$letter.png", width: letterSize),
        ],
      ),
    );
  }
}
