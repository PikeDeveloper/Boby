import 'dart:math';
import 'package:boby/ui/shared/number_of_images.dart';
import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';

class NumberOptionsGrid extends StatelessWidget {
  final List<int> options;
  final void Function(int) onTap;
  final bool Function(int) isWrong;
  final bool Function(int) isCorrect;
  const NumberOptionsGrid({
    super.key,
    required this.options,
    required this.onTap,
    required this.isWrong,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final minSize = min(screenSize.width, screenSize.height);
    bool isLandscape = screenSize.width > screenSize.height;
    bool istablet = minSize > Constants.tabletSize;

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: wrong
                    ? Colors.red
                    : correct
                        ? Colors.green
                        : Colors.transparent,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
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
                    child: Center(
                      child: NumberOfImages(
                        number: n.toString(),
                        numberSize: 60,
                      ),
                    ),
                  ),

                  // Overlay for wrong/correct state
                  if (wrong || correct)
                    Container(
                      color:
                          (wrong ? Colors.red : Colors.green).withOpacity(0.3),
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
