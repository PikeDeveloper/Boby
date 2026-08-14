import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'
    show DottedBorder, RoundedRectDottedBorderOptions;

class NameContainer extends StatelessWidget {
  final List<String?> cardNames;
  final String name;
  final int index;
  final VoidCallback? onTap;
  final bool isSelected;

  const NameContainer({
    super.key,
    required this.cardNames,
    required this.name,
    required this.index,
    this.onTap,
    this.isSelected = false,
  });

  // Cheerful, child-friendly color palette for the 4 word badges
  static const List<Color> _badgeColors = [
    Color(0xFFFF5252), // Bright Coral Red
    Color(0xFF26C6DA), // Turquoise Teal
    Color(0xFFFF9800), // Sunny Orange
    Color(0xFFAB47BC), // Playful Purple
  ];

  @override
  Widget build(BuildContext context) {
    // Don't show the name if it's already on a card
    if (cardNames.contains(name)) {
      return const SizedBox(
        width: 145,
        height: 48,
      );
    }

    final Color badgeColor = _badgeColors[index % _badgeColors.length];

    return GestureDetector(
      onTap: onTap,
      child: Draggable<String>(
        data: name,
        feedback: Material(
          color: Colors.transparent,
          child: Transform.scale(
            scale: 1.08,
            child: Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: badgeColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.drag_indicator_rounded,
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        childWhenDragging: SizedBox(
          width: 145,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: Colors.grey.shade400,
              strokeWidth: 2,
              dashPattern: const [6, 4],
              radius: const Radius.circular(25),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white.withValues(alpha: 0.3),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 145,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: isSelected ? badgeColor : badgeColor,
            gradient: LinearGradient(
              colors: [
                badgeColor,
                Color.alphaBlend(Colors.black.withValues(alpha: 0.15), badgeColor),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color: isSelected ? Colors.yellowAccent : Colors.white.withValues(alpha: 0.8),
              width: isSelected ? 3.5 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.yellowAccent.withValues(alpha: 0.7)
                    : badgeColor.withValues(alpha: 0.45),
                blurRadius: isSelected ? 12 : 6,
                offset: isSelected ? const Offset(0, 2) : const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.drag_indicator_rounded,
                color: isSelected ? Colors.yellowAccent : Colors.white.withValues(alpha: 0.85),
                size: isSelected ? 19 : 17,
              ),
              const SizedBox(width: 4),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

