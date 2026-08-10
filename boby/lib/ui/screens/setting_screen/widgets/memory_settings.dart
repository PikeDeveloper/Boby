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
    final color = Colors.purple; // Theme color for Memory settings

    return GestureDetector(
      onTap: () => StorageService.instance.setMemoryGrid(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected ? color.withValues(alpha: 0.3) : Colors.transparent,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Grid Preview
            Container(
              width:
                  cols * 15.0 +
                  (cols - 1) * 2, // Approximate width based on mini-grid
              height: rows * 15.0 + (rows - 1) * 2,
              constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemCount: rows * cols,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? color.withValues(alpha: 0.8)
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: selected ? color : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              key,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected ? color.withValues(alpha: 0.8) : Colors.grey.shade500,
              ),
            ),

            // Checkmark
            if (selected) ...[
              const SizedBox(height: 8),
              Icon(Icons.check_circle, color: color, size: 24),
            ] else ...[
              const SizedBox(height: 8),
              Icon(
                Icons.circle_outlined,
                color: Colors.grey.shade300,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
