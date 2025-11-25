import 'dart:math';

import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/shared/word_menu.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainMenu extends StatelessWidget {
  MainMenu({super.key});

  final String soundPath = "assets/sounds/transition.wav";

  final List<Map<String, String>> options = [
    {"name": "Sounds", "route": "0", "image": "assets/sounds_icon.png"},
    {"name": "Memory", "route": "1", "image": "assets/memory_icon.png"},
    {
      "name": "Letters Soup",
      "route": "2",
      "image": "assets/letters_soup_icon.png",
    },
    {"name": "Settings", "route": "3", "image": "assets/math_icon.png"},
    {"name": "Word Guess", "route": "4", "image": "assets/word_guess_icon.png"},
    {"name": "Match It", "route": "5", "image": "assets/match_it_icon.png"},
    {"name": "Names", "route": "6", "image": "assets/match_it_icon.png"},
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final screenSize = MediaQuery.of(context).size;

    double minSide = min(screenSize.width, screenSize.height);

    if (screenSize.width / screenSize.height > 1) {
      minSide = minSide * 0.6;
    }

    List<Widget> widgets = [];
    for (var option in options) {
      widgets.add(
        GestureDetector(
          onTap: () {
            // Reproduce el sonido usando el AppController (persiste entre navegaciones)
            appController.playMenuSound(soundPath);
            appController.menuOpen.value = false;
            appController.currentPage.value = int.parse(option["route"]!);
          },
          child: SizedBox(
            width: minSide * 0.3,
            height: minSide * 0.3,
            child: Image.asset(option["image"]!, fit: BoxFit.cover),
          ),
        ),
      );
    }
    //crea un grid con las opciones
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            appController.menuOpen.value = false;
          },
          child: Container(
            color: Colors.black.withOpacity(0.6),
            width: screenSize.width,
            height: screenSize.height,
          ),
        ),
        Center(
          child: Container(
            width: minSide * 0.8,
            height: minSide * 1.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/soft.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: MyColors.green, width: 6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WordMenu(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [widgets[0], widgets[1]],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [widgets[2], widgets[3]],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [widgets[4], widgets[5]],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
