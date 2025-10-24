import 'package:flutter/material.dart';

class LetterButton extends StatelessWidget {
  const LetterButton(
      {super.key,
      required this.onTap,
      required this.letters,
      required this.letterSize});

  final VoidCallback onTap;
  final List<String> letters;
  final double letterSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (!letters.contains(" ")) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var letter in letters)
            Image.asset("assets/letters_2/$letter.png", height: letterSize),
        ],
      );
    }

    final List<List<String>> words = [];
    List<String> current = [];
    for (final ch in letters) {
      if (ch == " ") {
        if (current.isNotEmpty) {
          words.add(current);
          current = [];
        }
      } else {
        current.add(ch);
      }
    }
    if (current.isNotEmpty) {
      words.add(current);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < words.length; i++) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var letter in words[i])
                Image.asset("assets/letters_2/$letter.png", height: letterSize),
            ],
          ),
          if (i != words.length - 1) const SizedBox(height: 6),
        ]
      ],
    );
  }
}
