import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrambleSettings extends StatelessWidget {
  const ScrambleSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return ValueListenableBuilder(
      valueListenable: StorageService.instance.listenable(
        keys: [StorageService.scrambleLevelKey],
      ),
      builder: (context, box, _) {
        final current = StorageService.instance.getScrambleLevel();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildOptionCard(
              key: 'easy',
              label: 'Easy',
              description: '4 words',
              current: current,
              onTap: () {
                StorageService.instance.setScrambleLevel('easy');
                appController.scrableLevel.value = 'easy';
              },
            ),
            _buildOptionCard(
              key: 'medium',
              label: 'Medium',
              description: '6 words',
              current: current,
              onTap: () {
                StorageService.instance.setScrambleLevel('medium');
                appController.scrableLevel.value = 'medium';
              },
            ),
            _buildOptionCard(
              key: 'hard',
              label: 'Hard',
              description: '8 words',
              current: current,
              onTap: () {
                StorageService.instance.setScrambleLevel('hard');
                appController.scrableLevel.value = 'hard';
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionCard({
    required String key,
    required String label,
    required String description,
    required String current,
    required VoidCallback onTap,
  }) {
    final selected = current == key;
    final color = Colors.orange; // Theme color for Scramble settings

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 2,
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
            // Icon representing difficulty
            Icon(
              key == 'easy'
                  ? Icons.sentiment_satisfied
                  : key == 'medium'
                  ? Icons.sentiment_neutral
                  : Icons.sentiment_very_dissatisfied,
              size: 48,
              color: selected ? color : Colors.grey.shade400,
            ),
            const SizedBox(height: 12),

            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: selected ? color : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected ? color.withValues(alpha: 0.8) : Colors.grey.shade500,
              ),
            ),

            // Checkmark
            const SizedBox(height: 12),
            if (selected)
              Icon(Icons.check_circle, color: color, size: 28)
            else
              Icon(
                Icons.circle_outlined,
                color: Colors.grey.shade300,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
