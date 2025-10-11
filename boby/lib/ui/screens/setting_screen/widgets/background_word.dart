import 'package:flutter/material.dart';

class BackgroundWord extends StatelessWidget {
  BackgroundWord({super.key, required});

  List<String> newLetters = [
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

  double letterSize = 25;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
