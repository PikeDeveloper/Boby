import 'dart:math';
import 'package:boby/ui/shared/number_of_images.dart';
import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';


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
    bool istablet = minSize > Constants.tabletSize;  
    


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
        crossAxisCount: isLandscape || istablet ? 4 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final n = options[index];
        
        final wrong = isWrong(n);
        final correct = isCorrect(n);
        return GestureDetector(
          onTap: () => onTap(n),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: wrong 
                    ? Colors.red 
                    : correct ? Colors.green : Colors.transparent, 
                  width: 4,
                ),
               
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Colored shape - same shape for all options
          

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(90, 255, 255, 255),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromARGB(94, 255, 255, 255),
                        
                        ),
                        child: Center(child: NumberOfImages(number: n.toString(), numberSize: 60))),
                   
                     
                    // Overlay for wrong/correct state
                    if (wrong || correct)
                      Container(
                        color: (wrong ? Colors.red : Colors.green).withValues(alpha: 0.3),
                        child: Center(
                          child: Icon(
                            wrong ? Icons.close : Icons.check,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        );
      },
    );
  }
}
