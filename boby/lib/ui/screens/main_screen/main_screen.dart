import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/bonus_sreen/match_it/match_it.dart';
import 'package:boby/ui/screens/complete_sentence/complete_sentence.dart';
import 'package:boby/ui/screens/drag_and_drop_screen/list_card_sounds.dart';
import 'package:boby/ui/screens/letters_soup/letters_soup.dart';
import 'package:boby/ui/screens/main_screen/widgets/background.dart';
import 'package:boby/ui/screens/drag_and_drop_screen/widgets/name_screen.dart';
import 'package:boby/ui/screens/scramble_word/scramble_screen.dart';
import 'package:boby/ui/screens/word_guess/word_guess_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/main_menu.dart';

import '../setting_screen/setting_sacreen.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main_screen';

  MainScreen({super.key});

  final List<Widget> screens = [
    ListCardSounds(),
    ScrambleScreen(),
    //MemoryScreen(),
    LettersSoup(),
    CompleteSentence(),
    WordGuessScreen(),
    MatchItScreen(),
    SettingScreen(),
    NameScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.put<AppController>(AppController());
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                appController.menuOpen.value = false;
                appController.currentPage.value = 6;
              },
              icon: Image.asset("assets/settings_icon.png"),
            ),
          ],
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
