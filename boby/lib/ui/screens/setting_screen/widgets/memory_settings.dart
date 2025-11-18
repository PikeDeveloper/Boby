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
      valueListenable: StorageService.instance
          .listenable(keys: [StorageService.memoryGridKey]),
      builder: (context, box, _) {
        final current = StorageService.instance.getMemoryGrid();

        Widget option(String key, int rows, int cols) {
          final selected = current == key;
          return InkWell(
            onTap: () => StorageService.instance.setMemoryGrid(key),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: selected ? Colors.indigo : Colors.grey.shade400,
                    width: 1.5),
                color: Colors.white.withOpacity(selected ? 0.9 : 0.7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: cols * itemSize,
                    height: rows * itemSize,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: rows * cols,
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(imagePath, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(key,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (selected)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(Icons.check_circle, color: Colors.indigo),
                    ),
                  if (!selected)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(Icons.circle_outlined, color: Colors.indigo),
                    ),
                ],
              ),
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          if  (!isLandscape && !istablet )
            option('3x2', 3, 2),
            option('3x3', 3, 3),
            option('4x4', 4, 4),
          ],
        );
      },
    );
  }
}
