import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';

class FigureOptionsGrid extends StatelessWidget {
  final List<String> options;
  final List<Map<String, String>> assets;
  final void Function(String) onTap;
  final bool Function(String) isWrong;
  final bool Function(String) isCorrect;

  const FigureOptionsGrid({
    required this.options,
    required this.assets,
    required this.onTap,
    required this.isWrong,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    bool istablet = screenSize.width > Constants.tabletSize;

    // Color choices with human-readable names
    final List<Color> colors = const [
      (Colors.blue),
      (Colors.yellow),
      (Colors.purple),
      (Colors.orange),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape || istablet ? 4 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1, // Make it square for images
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final label = options[index];
        final asset = assets.firstWhere(
          (a) => a['name'] == label,
          orElse: () => {'image': '', 'name': label},
        );
        final wrong = isWrong(label);
        final correct = isCorrect(label);

        return GestureDetector(
          onTap: () => onTap(label),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: wrong
                    ? Colors.red
                    : correct
                    ? Colors.green
                    : colors[index],
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
                  // Image
                  if (asset['image']?.isNotEmpty ?? false)
                    Image.asset(
                      asset['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildFallbackContent(label),
                    )
                  else
                    _buildFallbackContent(label),

                  // Overlay for wrong/correct state
                  if (wrong || correct)
                    Container(
                      color: (wrong ? Colors.red : Colors.green).withOpacity(
                        0.3,
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

  Widget _buildFallbackContent(String label) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
