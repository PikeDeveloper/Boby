import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Score extends StatelessWidget {
  final String game;


  const Score({
    super.key, 
    required this.game,

  });



  String _getCorrectValue() {
    switch (game) {
      case "Math":
        return StorageService.instance.getMathCorrect().toString();
      case "Memory":
        return StorageService.instance.getMemoryCorrect().toString();
      case "SoundCards":
        return StorageService.instance.getSoundCardsCorrect().toString();
      case "WordGuess":
        return StorageService.instance.getWordGuessCorrect().toString();
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
      case "WordGuess":
        return StorageService.instance.getWordGuessWrong().toString();
 
      default:
        return "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appController = Get.find<AppController>();
    final String noShow = appController.noShow.value;
    return GestureDetector(
      onTap: () => _showRestoreDialog(context),
      child: Container(
        width: screenSize.width * 0.8,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Obx (
          () => Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildScoreItem("Correct", _getCorrectValue(), MyColors.green),
              const SizedBox(width: 16),
              _buildScoreItem("Wrong", _getWrongValue(), MyColors.red),
              Text(appController.noShow.value, style: TextStyle(fontSize:1, ),),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, Color color) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          //'Restablecer Puntuación',
           "Restore Score",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to reset the score?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
             style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _resetScores();
              Navigator.of(context).pop();
           
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
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

    }
    appController.noShow.value == "no"? appController.noShow.value = "yes": appController.noShow.value = "no";
  }
}
