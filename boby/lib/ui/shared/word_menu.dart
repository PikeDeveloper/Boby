import 'package:flutter/material.dart';

class WordMenu extends StatelessWidget {
  const WordMenu({super.key});

  final List<String> letters = const ["M", "E", "N", "U"];

  final double letterSize = 35;

  @override
  Widget build(BuildContext context) {
    //retorna un row con las letras y cada letra es una imagen de "assets/letters/", el tamaño de la sletras es
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var letter in letters)
          Image.asset("assets/letters_2/$letter.png", width: letterSize, height: letterSize),
      ],
    );
  }
}
