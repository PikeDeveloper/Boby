import 'package:boby/ui/shared/word_of_images.dart';
import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WordOfImages(letters: ["A", "B", "O", "U", "T", "M", "E"], letterSize: 25),   
      ],
    );
  }
}