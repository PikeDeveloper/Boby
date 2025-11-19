import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class Score extends StatelessWidget {
  final String game;


  const Score({
    super.key, 
    required this.game,

  });


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
    return Image.asset(badge, width: isTablet || isLandscape ? 40 : 30, height: isTablet || isLandscape ? 50 : 30);
  
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
        child: Obx (
          () => Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getBadge(double.parse(_getCorrectValue()), double.parse(_getWrongValue()) , istablet, isLandscape),
              const Spacer(),
              _buildScoreItem("Correct", _getCorrectValue(), MyColors.green, isLandscape, istablet),
              const SizedBox(width: 16),
              _buildScoreItem("Wrong", _getWrongValue(), MyColors.red, isLandscape, istablet),
              Text( appController.noShow.value, style: TextStyle(fontSize:1, ),),
              const SizedBox(width: 16),
              const Spacer(),
              getBadge(double.parse(_getCorrectValue()), double.parse(_getWrongValue()), istablet, isLandscape),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, Color color , bool isLandscape, bool istablet) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: isLandscape || istablet ? 35 : 16,
            fontWeight: FontWeight.w600,
            color: color
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

  void _showRestoreDialog(BuildContext context, bool istablet, bool isLandscape) {
    double average = (double.parse(_getCorrectValue()) / (double.parse(_getCorrectValue()) + double.parse(_getWrongValue()))) * 100;
String level = "";
    if (average >= 90) {
      level = "Diamond";
    } else if (average >= 80) {
      level = "Gold";
    } else if (average >= 50) {
      level = "Silver";
    } else {
      level = "Bronze";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          //'Restablecer Puntuación',
           "Restore Score",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [


            Row(
              children: [
                const Text('Your level is ' , style: TextStyle(fontSize: 20),),
                Text(level, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(width: 5),
                getBadge(double.parse(_getCorrectValue()), double.parse(_getWrongValue()) , istablet, isLandscape),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Do you want to reset the score?' , style: TextStyle(fontSize: 20),),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
             style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            child: const Text('Cancel' , style: TextStyle(fontSize: 20),),
          ),
          TextButton(
            onPressed: () {
              _resetScores();
              Navigator.of(context).pop();
           
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Reset' , style: TextStyle(fontSize: 20),),
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
      case "MatchIt":
        StorageService.instance.setMatchItCorrect(0); 
        StorageService.instance.setMatchItWrong(0);
        break;
      case "CompleteSentence":
        StorageService.instance.setCompleteSentenceCorrect(0); 
        StorageService.instance.setCompleteSentenceWrong(0);
        break;

    }
    appController.noShow.value == "no"? appController.noShow.value = "yes": appController.noShow.value = "no";
  }
}
