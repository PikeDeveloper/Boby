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
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final n = options[index];

        final wrong = isWrong(n);
        final correct = isCorrect(n);
        return GestureDetector(
          onTap: () => onTap(n),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: wrong
                    ? const Color(0xFFEF5350)
                    : correct
                    ? const Color(0xFF4CAF50)
                    : Colors.white,
                width: wrong || correct ? 4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: wrong
                      ? const Color(0xFFEF5350).withValues(alpha: 0.3)
                      : correct
                      ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.12),
                  blurRadius: wrong || correct ? 10 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: NumberOfImages(
                      number: n.toString(),
                      numberSize: isLandscape || istablet ? 75 : 60,
                    ),
                  ),

                  // Overlay for wrong/correct state
                  if (wrong || correct)
                    Container(
                      color: (wrong ? const Color(0xFFEF5350) : const Color(0xFF4CAF50)).withValues(
                        alpha: 0.25,
                      ),
                      child: Center(
                        child: AnimatedScale(
                          scale: 1.1,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            wrong ? Icons.cancel_rounded : Icons.check_circle_rounded,
                            color: wrong ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32),
                            size: 54,
                          ),
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
