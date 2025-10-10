import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewGameButton extends StatelessWidget {
  NewGameButton({super.key, required this.onTap});

  List<String> newLetters = ["N", "E", "W"];

  List<String> gameLetters = ["G", "A", "M", "E"];

  double letterSize = 25;

  final VoidCallback onTap;

  final String soundPath = "assets/sounds/retro-game-over.wav";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final appController = Get.find<AppController>();

    return GestureDetector(
      onTap: () {
        onTap();
        appController.playMenuSound(soundPath);   
      },
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child:     Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var letter in newLetters)
                  Image.asset("assets/letters/$letter.png", width: letterSize),
                SizedBox(width: 10),
                for (var letter in gameLetters)
                  Image.asset("assets/letters/$letter.png", width: letterSize),
              ],
            ),
        ),
      ),
    );
  }
}
