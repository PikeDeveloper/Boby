import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boby/controllers/app_controller.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key, required this.next, required this.back, required this.clue});

  final VoidCallback next;
  final VoidCallback back;
  final VoidCallback clue;

  

  @override
  Widget build(BuildContext context) {

        String clueSound = "assets/sounds/arcade-game.wav";
    String backSound = "assets/sounds/retro-game-over.wav";
    String nextSound = "assets/sounds/retro-game-over.wav";
    double iconSize = 48;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            final hasCtrl = Get.isRegistered<AppController>();
            if (hasCtrl) {
              await Get.find<AppController>().playMenuSound(backSound);
            }
            back();
          },  
          child: Image.asset( "assets/previous.png", height: iconSize),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () async {
            final hasCtrl = Get.isRegistered<AppController>();
            if (hasCtrl) {
              await Get.find<AppController>().playMenuSound(clueSound);
            }
            clue();
          },
          child: Image.asset( "assets/clue-icon.png", height: iconSize),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () async {
            final hasCtrl = Get.isRegistered<AppController>();
            if (hasCtrl) {
              await Get.find<AppController>().playMenuSound(nextSound);
            }
            next();
          },
          child: Image.asset( "assets/next.png", height: iconSize),
        ),
      ],
    );
  }
}