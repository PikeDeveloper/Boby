import 'dart:math';

import 'package:flutter/material.dart';
import 'package:boby/services/storage_service.dart';

class Score extends StatelessWidget {
  const Score({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final minSize = min(screenWidth, screenHeight);
    final letterSize = minSize / 8;
    return GestureDetector(
      onTap: () => warningRestoreCounter(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ValueListenableBuilder(
          valueListenable: StorageService.instance.listenable(
            keys: [
              StorageService.mathCorrectKey,
              StorageService.mathWrongKey,
            ],
          ),
          builder: (context, box, _) {
            final correct = StorageService.instance.getMathCorrect();
            final wrong = StorageService.instance.getMathWrong();
            final total = max(1, correct + wrong);
            final avg = correct / total; // 0..1

            TextStyle styleLabel = TextStyle(
                fontSize: letterSize * 0.28, fontWeight: FontWeight.w600);
            TextStyle styleValue = TextStyle(
                fontSize: letterSize * 0.35, fontWeight: FontWeight.bold);

            Widget col(String label, String value, Color color) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: styleLabel.copyWith(color: color)),
                    Text(value, style: styleValue.copyWith(color: color)),
                  ],
                );

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                col('Correct', '$correct', Colors.green),
                SizedBox(width: letterSize),
                col('Average', (avg * 100).toStringAsFixed(2), Colors.blue),
                SizedBox(width: letterSize),
                col('Wrong', '$wrong', Colors.red),
              ],
            );
          },
        ),
      ),
    );
  }

  warningRestoreCounter(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Counter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to restore the counter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              StorageService.instance.setMathCorrect(0);
              StorageService.instance.setMathWrong(0);
              Navigator.pop(context);
            },
            child: const Text('Restore',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
