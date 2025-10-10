import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/shared/word_menu.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainMenu extends StatelessWidget {
  MainMenu({super.key});

  final String soundPath = "assets/sounds/musical-game.wav";

  final List<Map<String, String>> options = [
    {"name": "Sounds", "route": "0", "image": "assets/sounds_icon.png"},
    {"name": "Memory", "route": "1", "image": "assets/memory_icon.png"},
    {"name": "Ballon", "route": "2", "image": "assets/ballon_icon.png"},
    {"name": "Settings", "route": "3", "image": "assets/settings_icon.png"},
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    double width = 0;
    if (screenWidth < 300) {
      width = screenWidth * 0.3;
    } else {
      width = screenWidth * 0.2;
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
            width: width,
            height: width,
            child: Image.asset(option["image"]!),
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
            width: screenWidth < 350 ? 300 : 350,
            height: screenWidth < 350 ? 300 : 350,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/soft.png"),
                fit: BoxFit.cover,
              ),
              color: Colors.white,
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
