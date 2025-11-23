import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BadgeSettings extends StatelessWidget {
  const BadgeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        "name": "Diamond",
        "image": "assets/dymond.png",
        "value": "90",
        "color": Colors.blueAccent,
        "explanation":
            "to unlock this badge, you need to get 90% of the correct answers",
      },
      {
        "name": "Gold",
        "image": "assets/gold.png",
        "value": "80",
        "color": Colors.amber,
        "explanation":
            "to unlock this badge, you need to get 80% of the correct answers",
      },
      {
        "name": "Silver",
        "image": "assets/silver.png",
        "value": "50",
        "color": Colors.grey,
        "explanation":
            "to unlock this badge, you need to get 50% of the correct answers",
      },
      {
        "name": "Bronze",
        "image": "assets/bronze.png",
        "value": "0",
        "color": Colors.brown,
        "explanation":
            "to unlock this badge, you need to get 0% of the correct answers",
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: data.map((element) {
          return _buildBadgeCard(
            explanation: element["explanation"]!,
            name: element["name"]!,
            image: element["image"]!,
            value: element["value"]!,
            color: element["color"]!,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBadgeCard({
    required String name,
    required String image,
    required String value,
    required Color color,
    required String explanation,
  }) {
    return GestureDetector(
      onTap: () => _showBadgeDialog(
        name: name,
        image: image,
        value: value,
        color: color,
        explanation: explanation,
      ),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(image, width: 50, height: 50),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                ">= $value%",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDialog({
    required String name,
    required String image,
    required String value,
    required Color color,
    required String explanation,
  }) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text("Select Badge"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, width: 50, height: 50),
            Text(
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              ">= $value%",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              explanation,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Ok")),
        ],
      ),
    );
  }
}
