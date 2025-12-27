import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/bonus_sreen/float_words/bonus_screen.dart';
import 'package:boby/ui/screens/bonus_sreen/match_it/match_it.dart';
import 'package:boby/ui/screens/bonus_sreen/to_be_bonus_screen/to_be_bonus_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:boby/ui/screens/bonus_sreen/complete_sentence/complete_sentence.dart';

class BonusSettings extends StatelessWidget {
  const BonusSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        "name": "Green",
        "image": "assets/bonus_green.png",
        "color": Colors.green,
        "explanation": "Complete the verb to be to earn points.",
        "bonus_screen": ToBeBonusScreen.routeName,
      },
      {
        "name": "Yellow",
        "image": "assets/bonus_yellow.png",
        "color": Colors.amber,
        "explanation": "Tap the correct image to get points.",
        "bonus_screen": MatchItScreen.route,
      },
      {
        "name": "Blue",
        "image": "assets/bonus_blue.png",
        "color": Colors.blue,
        "explanation": "Touch the indicated words to earn points.",
        "bonus_screen": BonusScreenFloatWords.route,
      },
      {
        "name": "Purple",
        "image": "assets/bonus_purple.png",
        "color": Colors.purple,
        "explanation": "Finish the sentences to earn points.",
        "bonus_screen": CompleteSentence.route,
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: data.map((element) {
          return _buildBadgeCard(
            bonus_screen: element["bonus_screen"]!,
            explanation: element["explanation"]!,
            name: element["name"]!,
            image: element["image"]!,

            color: element["color"]!,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBadgeCard({
    required String bonus_screen,
    required String name,
    required String image,
    required Color color,
    required String explanation,
  }) {
    return GestureDetector(
      onTap: () => _showBadgeDialog(
        appController: Get.find<AppController>(),
        bonus_screen: bonus_screen,
        name: name,
        image: image,

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
          ],
        ),
      ),
    );
  }

  void _showBadgeDialog({
    required AppController appController,
    required String name,
    required String image,
    required String bonus_screen,
    required Color color,
    required String explanation,
  }) {
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color, width: 4),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 1,
                right: 1,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    "X",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge Image with Glow
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(image, width: 80, height: 80),
                  ),
                  const SizedBox(height: 20),

                  // Badge Name
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Explanation
                  Text(
                    explanation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        appController.isTrainingMode.value = true;
                        Get.toNamed(bonus_screen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Try it now! ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
