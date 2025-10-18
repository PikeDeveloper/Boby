import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/main_screen/widgets/background.dart';
import 'package:boby/ui/screens/math_screen/math_screen.dart';
import 'package:boby/ui/screens/word_guess/word_guess_screen.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/main_menu.dart';
import '../ballom_screen/ballom_screen.dart';
import '../match_it/match_it.dart';
import '../memory/memory_screen.dart';
import '../setting_screen/setting_sacreen.dart';
import '../sound_cards_screen/list_card_sounds.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main_screen';

  MainScreen({super.key});

  final List<Widget> screens = [
    ListCardSounds(),
    MemoryScreen(),
    BallomScreen(),
     MathScreen(),
    WordGuessScreen(),
    MatchItScreen(),
    SettingScreen(),
    //AbautScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.put<AppController>(AppController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            appController.currentPage.value = 6;
          },
          icon: Image.asset("assets/settings_icon.png"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              appController.menuOpen.value = !appController.menuOpen.value;
            },
            icon: Image.asset("assets/icon_burger.png"),
          ),
        ],
        title: Image.asset("assets/boby_app_logo.png", width: 100),
        centerTitle: true,
      backgroundColor: const Color.fromARGB(222, 113, 178, 235),
   
      ),

      body: Obx(
        () => SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Background(),
              screens[appController.currentPage.value],
              appController.menuOpen.value ? MainMenu() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
