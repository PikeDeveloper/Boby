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

  final Color borderColor = const Color.fromARGB(90, 130, 130, 130);

  @override
  Widget build(BuildContext context) {
    // Don't show the name if it's already on a card
    if (cardNames.contains(name)) {
      return Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: const SizedBox.shrink(),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Draggable<String>(
        data: name,
        feedback: Material(
          color: Colors.transparent,
          // Container con borde segmentado --------------//
          child: Container(
            width: 150,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: const Radius.circular(20),
                color: borderColor,
                strokeWidth: 2,
                dashPattern: const [6, 4],
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(
                    232,
                    242,
                    242,
                    242,
                  ).withValues(alpha: 0.8),
                ),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 6, 45, 243),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Container con borde segmentado --------------//
        childWhenDragging: SizedBox(
          width: 150,
          //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: borderColor,
              strokeWidth: 2,
              dashPattern: const [6, 4],
              radius: const Radius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300],
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
        // Container con borde segmentado --------------//
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: isSelected ? Colors.blue : borderColor,
              strokeWidth: 2,
              dashPattern: const [6, 4],
              radius: const Radius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(
                  232,
                  242,
                  242,
                  242,
                ).withValues(alpha: 0.8),
                border: isSelected
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 6, 45, 243),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
