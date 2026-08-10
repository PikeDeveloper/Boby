import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';

class ColorOptionsGrid extends StatelessWidget {
  final List<(String, Color)> options;
  final List<String> shapes;
  final void Function((String, Color)) onTap;
  final bool Function(String) isWrong;
  final bool Function(String) isCorrect;

  const ColorOptionsGrid({super.key, 
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
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: wrong
                    ? Colors.red
                    : correct
                    ? Colors.green
                    : Colors.transparent,
                width: 4,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Colored shape - same shape for all options
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(opt.$2, BlendMode.srcIn),
                    child: Image.asset(
                      shapePath,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  // Overlay for wrong/correct state
                  if (wrong || correct)
                    Container(
                      color: (wrong ? Colors.red : Colors.green).withValues(
                        alpha: 0.3,
                      ),
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
