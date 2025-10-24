import 'package:flutter/material.dart';

class WordOfImages extends StatelessWidget {
  const WordOfImages(
      {super.key, required this.letters, required this.letterSize});

  final List<String> letters;
  final double letterSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (!letters.contains(" ")) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < letters.length; i++) ...[
            Image.asset("assets/letters_2/${letters[i]}.png",
                height: letterSize),
            if (i != letters.length - 1) const SizedBox(width: 6),
          ],
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
              for (int j = 0; j < words[i].length; j++) ...[
                Image.asset("assets/letters_2/${words[i][j]}.png",
                    height: letterSize),
                if (j != words[i].length - 1) const SizedBox(width: 10),
              ],
            ],
          ),
          if (i != words.length - 1) const SizedBox(height: 6),
        ]
      ],
    );
  }
}
