import 'dart:math';

import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CardSound extends StatelessWidget {
  const CardSound({
    super.key,
    required this.sound,
    required this.name,
    required this.image,
    required this.onPressed,
  });

  final String sound;
  final String name;
  final String image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    List<Color> borderColors = [
      const Color(0xFFF1C40F),
      const Color(0xffBE5EED),
      const Color(0xFFFF4C88),
      const Color(0xFFEF4444),
      const Color(0xFF19E680),
      const Color(0xFF25AFF4),
      const Color(0xFFEF4444),
      const Color(0xFF19E680),
      const Color(0xFF25AFF4),
      const Color(0xFFF1C40F),
      const Color(0xffBE5EED),
      const Color(0xFFFF4C88),
    ];

    int colorSelected = Random().nextInt(borderColors.length);

    return Obx(
      () => GestureDetector(
        onTap: () {
          appController.cardSelected.value = name;
          onPressed();
        },
        child: Card(
          color: appController.cardSelected.value == name
              ? Colors.green
              : const Color.fromARGB(255, 236, 8, 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: borderColors[colorSelected], width: 5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(image),
          ),
        ),
      ),
    );
  }
}
