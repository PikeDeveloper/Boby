import 'package:get/get.dart';
import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';

class MatchItSettings extends StatelessWidget {
  const MatchItSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final String objetImagePath = "assets/images/apple.jpg";
    final String numberImagePath = "assets/numbers/1.png";
    final String colorImagePath = "assets/shapes/shape_1.png";

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOptionCard(
            label: "Objects",
            imagePath: objetImagePath,
            isSelected: appController.enableObjects.value,
            onTap: () {
              if (appController.enableObjects.value) {
                if (appController.enableNumbers.value ||
                    appController.enableColors.value) {
                  appController.enableObjects.value = false;
                }
              } else {
                appController.enableObjects.value = true;
              }
            },
            color: Colors.blue,
          ),
          _buildOptionCard(
            label: "Numbers",
            imagePath: numberImagePath,
            isSelected: appController.enableNumbers.value,
            onTap: () {
              if (appController.enableNumbers.value) {
                if (appController.enableObjects.value ||
                    appController.enableColors.value) {
                  appController.enableNumbers.value = false;
                }
              } else {
                appController.enableNumbers.value = true;
              }
            },
            color: Colors.orange,
          ),
          _buildOptionCard(
            label: "Colors",
            imagePath: colorImagePath,
            isSelected: appController.enableColors.value,
            onTap: () {
              if (appController.enableColors.value) {
                if (appController.enableObjects.value ||
                    appController.enableNumbers.value) {
                  appController.enableColors.value = false;
                }
              } else {
                appController.enableColors.value = true;
              }
            },
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String label,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle, color: color, size: 20),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
