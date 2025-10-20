import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewGameButton extends StatelessWidget {
  const NewGameButton({super.key, required this.onTap}); 

  final List<String> newLetters = const ["N", "E", "W"];

  final List<String> gameLetters = const ["G", "A", "M", "E"];

  final double letterSize = 25;

  final VoidCallback onTap;

  final String soundPath = "assets/sounds/retro-game-over.wav";

  @override
  Widget build(BuildContext context) {
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
                  Image.asset("assets/letters_2/$letter.png", height: letterSize),
                SizedBox(width: 10),
                for (var letter in gameLetters)
                  Image.asset("assets/letters_2/$letter.png", height: letterSize),
              ],
            ),
        ),
      ),
    );
  }
}
