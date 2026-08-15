import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';

class ColorOptionsGrid extends StatelessWidget {
  final List<(String, Color)> options;
  final List<String> shapes;
  final void Function((String, Color)) onTap;
  final bool Function(String) isWrong;
  final bool Function(String) isCorrect;

  const ColorOptionsGrid({
    super.key, 
    required this.options,
    required this.shapes,
    required this.onTap,
    required this.isWrong,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    bool istablet = screenSize.width > Constants.tabletSize;

    // Use the first shape for all color options
    final shapePath = shapes.isNotEmpty
        ? shapes[0]
        : 'assets/shapes/shape_1.png';

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape || istablet ? 4 : 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1, // Square aspect ratio for shapes
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        if (index >= options.length) return const SizedBox.shrink();

        final opt = options[index];
        final wrong = isWrong(opt.$1);
        final correct = isCorrect(opt.$1);

        return GestureDetector(
          onTap: () => onTap(opt),
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
                  // Colored shape - same shape for all options
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(opt.$2, BlendMode.srcIn),
                      child: Image.asset(
                        shapePath,
                        fit: BoxFit.contain,
                      ),
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
