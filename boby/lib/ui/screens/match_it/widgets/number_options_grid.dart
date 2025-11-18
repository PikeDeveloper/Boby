import 'dart:math';

import 'package:boby/ui/shared/number_of_images.dart';
import 'package:flutter/material.dart';
import 'package:boby/ui/screens/match_it/widgets/gradient_button.dart';

class NumberOptionsGrid extends StatelessWidget {
  final List<int> options;
  final void Function(int) onTap;
  final bool Function(int) isWrong;
  final bool Function(int) isCorrect;
  const NumberOptionsGrid(
      {super.key,
      required this.options,
      required this.onTap,
      required this.isWrong,
      required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final minSize = min(screenSize.width, screenSize.height);
    bool isLandscape = screenSize.width > screenSize.height;
    


      //number choices
  final List<Map<String, dynamic>> wordsEn = [
    {"number": 1, "letter": "one"}, 
    {"number": 2, "letter": "two"},
    {"number": 3, "letter": "three"},
    {"number": 4, "letter": "four"},
    {"number": 5, "letter": "five"},
    {"number": 6, "letter": "six"},   
    {"number": 7, "letter": "seven"},
    {"number": 8, "letter": "eight"},
    {"number": 9, "letter": "nine"},
    {"number": 10, "letter": "ten"},
    {"number": 11, "letter": "eleven"},
    {"number": 12, "letter": "twelve"},   
    {"number": 13, "letter": "thirteen"},
    {"number": 14, "letter": "fourteen"},
    {"number": 15, "letter": "fifteen"},
    {"number": 16, "letter": "sixteen"},
    {"number": 17, "letter": "seventeen"},
    {"number": 18, "letter": "eighteen"},
    {"number": 19, "letter": "nineteen"},
    {"number": 20, "letter": "twenty"},
  ];





    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape ? 4 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final n = options[index];
        
        final wrong = isWrong(n);
        return GradientButton(
          onTap: () => onTap(n),
          isError: wrong,
          isCorrect: isCorrect(n),
          child: NumberOfImages(number: n.toString(), numberSize: 60),
        );
      },
    );
  }
}
