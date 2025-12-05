import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemorySoundButton extends StatelessWidget {
  const MemorySoundButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return GestureDetector(
      onTap: () {
        appController.playMenuSound("assets/sounds/retro-game-over.wav");
      },
      child: const Icon(Icons.volume_off),
    );
  }
}
