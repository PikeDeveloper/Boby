import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class Score extends StatelessWidget {
  final String game;

  const Score({super.key, required this.game});

  getBadge(double correct, double wrong, bool isTablet, bool isLandscape) {
    double average = (correct / (correct + wrong)) * 100;
    String badge = "";
    if (average >= 90) {
      badge = "assets/dymond.png";
    } else if (average >= 80) {
      badge = "assets/gold.png";
    } else if (average >= 50) {
      badge = "assets/silver.png";
    } else {
      badge = "assets/bronze.png";
    }
    return Image.asset(
      badge,
      width: isTablet || isLandscape ? 40 : 30,
      height: isTablet || isLandscape ? 50 : 30,
    );
  }

  String _getCorrectValue() {
    switch (game) {
      case "Math":
        return StorageService.instance.getMathCorrect().toString();
      case "Memory":
        return StorageService.instance.getMemoryCorrect().toString();
      case "SoundCards":
        return StorageService.instance.getSoundCardsCorrect().toString();
      case "MatchIt":
        return StorageService.instance.getMatchItCorrect().toString();
      case "CompleteSentence":
        return StorageService.instance.getCompleteSentenceCorrect().toString();
      default:
        return "0";
    }
  }

  String _getWrongValue() {
    switch (game) {
      case "Math":
        return StorageService.instance.getMathWrong().toString();
      case "Memory":
        return StorageService.instance.getMemoryWrong().toString();
      case "SoundCards":
        return StorageService.instance.getSoundCardsWrong().toString();
      case "MatchIt":
        return StorageService.instance.getMatchItWrong().toString();
      case "CompleteSentence":
        return StorageService.instance.getCompleteSentenceWrong().toString();
      default:
        return "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appController = Get.find<AppController>();
    final isLandscape = screenSize.width > screenSize.height;
    bool istablet = screenSize.width > Constants.tabletSize;

    return GestureDetector(
      onTap: () => _showRestoreDialog(context, istablet, isLandscape),
      child: Container(
        width: screenSize.width * 0.8,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getBadge(
                double.parse(_getCorrectValue()),
                double.parse(_getWrongValue()),
                istablet,
                isLandscape,
              ),
              const Spacer(),
              _buildScoreItem(
                "Correct",
                _getCorrectValue(),
                MyColors.green,
                isLandscape,
                istablet,
              ),
              const SizedBox(width: 16),
              _buildScoreItem(
                "Wrong",
                _getWrongValue(),
                MyColors.red,
                isLandscape,
                istablet,
              ),
              Text(appController.noShow.value, style: TextStyle(fontSize: 1)),
              const SizedBox(width: 16),
              const Spacer(),
              getBadge(
                double.parse(_getCorrectValue()),
                double.parse(_getWrongValue()),
                istablet,
                isLandscape,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(
    String label,
    String value,
    Color color,
    bool isLandscape,
    bool istablet,
  ) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: isLandscape || istablet ? 35 : 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLandscape || istablet ? 35 : 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showRestoreDialog(
    BuildContext context,
    bool istablet,
    bool isLandscape,
  ) {
    double correct = double.parse(_getCorrectValue());
    double wrong = double.parse(_getWrongValue());
    double total = correct + wrong;
    double average = total == 0 ? 0 : (correct / total) * 100;

    String level = "";
    Color levelColor;

    if (average >= 90) {
      level = "Diamond";
      levelColor = Colors.blueAccent;
    } else if (average >= 80) {
      level = "Gold";
      levelColor = Colors.amber;
    } else if (average >= 50) {
      level = "Silver";
      levelColor = Colors.grey;
    } else {
      level = "Bronze";
      levelColor = Colors.brown;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 10,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFF1E88E5), width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Game Name
              Text(
                game,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
              ),
              const SizedBox(height: 20),

              // Level Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: levelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: levelColor, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Level: $level",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: levelColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    getBadge(correct, wrong, istablet, isLandscape),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Stats Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatBox(
                    "Correct",
                    correct.toInt().toString(),
                    Colors.green,
                  ),
                  _buildStatBox("Wrong", wrong.toInt().toString(), Colors.red),
                ],
              ),

              const SizedBox(height: 30),

              // Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Share Button
                  _buildActionButton(
                    icon: Icons.share_rounded,
                    label: "Share",
                    color: Colors.purple,
                    onTap: () {
                      // Share functionality to be implemented
                    },
                  ),

                  // Reset Button
                  _buildActionButton(
                    icon: Icons.refresh_rounded,
                    label: "Reset",
                    color: Colors.orange,
                    onTap: () {
                      _resetScores();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text(
                  "Close",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetScores() {
    final appController = Get.find<AppController>();

    switch (game) {
      case "Math":
        StorageService.instance.setMathCorrect(0);
        StorageService.instance.setMathWrong(0);
        break;
      case "Memory":
        StorageService.instance.setMemoryCorrect(0);
        StorageService.instance.setMemoryWrong(0);
        break;
      case "SoundCards":
        StorageService.instance.setSoundCardsCorrect(0);
        StorageService.instance.setSoundCardsWrong(0);
        break;
      case "WordGuess":
        StorageService.instance.setWordGuessCorrect(0);
        StorageService.instance.setWordGuessWrong(0);
        break;
      case "MatchIt":
        StorageService.instance.setMatchItCorrect(0);
        StorageService.instance.setMatchItWrong(0);
        break;
      case "CompleteSentence":
        StorageService.instance.setCompleteSentenceCorrect(0);
        StorageService.instance.setCompleteSentenceWrong(0);
        break;
    }
    appController.noShow.value == "no"
        ? appController.noShow.value = "yes"
        : appController.noShow.value = "no";
  }
}
