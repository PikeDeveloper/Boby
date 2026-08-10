import 'dart:math';

import 'package:flutter/material.dart';
import 'package:boby/services/storage_service.dart';

import '../../../../utils/constants.dart';

class MemrySettings extends StatelessWidget {
  const MemrySettings({super.key});

  final String imagePath = "assets/card.png";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final minSize = min(screenWidth, screenHeight);
    final itemSize = minSize * 0.08;
    bool istablet = screenWidth > Constants.tabletSize;
    bool isLandscape = screenWidth / screenHeight > 1;

    return ValueListenableBuilder(
      valueListenable: StorageService.instance.listenable(
        keys: [StorageService.memoryGridKey],
      ),
      builder: (context, box, _) {
        final current = StorageService.instance.getMemoryGrid();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!isLandscape && !istablet)
              _buildOptionCard(
                key: '3x2',
                label: 'Easy',
                rows: 3,
                cols: 2,
                current: current,
                itemSize: itemSize,
              ),
            _buildOptionCard(
              key: '3x3',
              label: 'Medium',
              rows: 3,
              cols: 3,
              current: current,
              itemSize: itemSize,
            ),
            _buildOptionCard(
              key: '4x4',
              label: 'Hard',
              rows: 4,
              cols: 4,
              current: current,
              itemSize: itemSize,
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionCard({
    required String key,
    required String label,
    required int rows,
    required int cols,
    required String current,
    required double itemSize,
  }) {
    final selected = current == key;
    const Map<String, Color> levelColors = {
      'Easy': Color(0xFF26C281),
      'Medium': Color(0xFFAB47BC),
      'Hard': Color(0xFFFF5252),
    };
    const Map<String, String> levelEmojis = {
      'Easy': '⭐',
      'Medium': '🔥',
      'Hard': '💎',
    };
    final color = levelColors[label] ?? Colors.purple;
    final emoji = levelEmojis[label] ?? '⭐';

    return GestureDetector(
      onTap: () => StorageService.instance.setMemoryGrid(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: selected ? color.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.06),
              blurRadius: selected ? 14 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Grid Preview
            Container(
              width: cols * 15.0 + (cols - 1) * 3,
              height: rows * 15.0 + (rows - 1) * 3,
              constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                ),
                itemCount: rows * cols,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: selected ? color : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 3,
                            )
                          ]
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Emoji + Label
            Text(
              emoji,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: selected ? color : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              key,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: selected ? color.withValues(alpha: 0.8) : Colors.grey.shade400,
              ),
            ),

            // Checkmark
            const SizedBox(height: 8),
            if (selected)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
              )
            else
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
