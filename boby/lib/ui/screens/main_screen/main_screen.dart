import 'dart:math';

import 'package:boby/controllers/app_controller.dart';

import 'package:boby/ui/screens/bonus_sreen/complete_sentence/complete_sentence.dart';
import 'package:boby/ui/screens/bonus_sreen/float_words/bonus_screen.dart';
import 'package:boby/ui/screens/bonus_sreen/match_it/match_it.dart';
import 'package:boby/ui/screens/bonus_sreen/to_be_bonus_screen/to_be_bonus_screen.dart';
import 'package:boby/ui/screens/bonus_sreen/true_or_false_bonus/true_or_false.dart';
import 'package:boby/ui/screens/drag_and_drop_screen/drag_and_drop_screen.dart';
import 'package:boby/ui/screens/letters_soup/letters_soup.dart';
import 'package:boby/ui/screens/main_screen/widgets/background.dart';
import 'package:boby/ui/screens/drag_and_drop_screen/widgets/name_screen.dart';
import 'package:boby/ui/screens/memory_screen/memory_screen.dart';
import 'package:boby/ui/screens/scramble_word/scramble_screen.dart';
import 'package:boby/ui/screens/tales_scrren/tales.dart';
import 'package:boby/ui/screens/word_guess/word_guess_screen.dart';
import 'package:boby/ui/shared/explanation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/main_menu.dart';

import '../setting_screen/setting_sacreen.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main_screen';

  MainScreen({super.key});

  final List<Widget> screens = [
    ListCardSounds(),
    MemoryScreen(),
    LettersSoup(),
    TalesScreen(),
    WordGuessScreen(),
    ScrambleScreen(),
    SettingScreen(),
    NameScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.put<AppController>(AppController());
    final screenSize = MediaQuery.of(context).size;
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
            Obx(
              () => getBonusButton(
                appController.bonusScreen.value,
                appController.currentPage.value,
              ),
            ),
          ],
        ),
        actions: [
          Obx(() => getExplanationButton(appController.currentPage.value)),
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
              SizedBox(
                  width: min(screenSize.width, 900),
                  child: screens[appController.currentPage.value]),
              appController.menuOpen.value ? MainMenu() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getExplanationButton(int screen) {
    switch (screen) {
      case 0:
        return Explanation(
          text: "Drag names onto cards.",
          audioPath: "assets/explanation/drag_name.mp3",
        );
      case 1:
        return Explanation(
          text: "Flip the cards to find the pairs.",
          audioPath: "assets/explanation/flip_the_cards.mp3",
        );
      case 2:
        return Explanation(
          text: "Find the hidden words in the grid.",
          audioPath: "assets/explanation/find_the_hidden_words.mp3",
        );
      case 3:
        return Explanation(
          text: "Read the story, then answer the question.",
          audioPath: "assets/explanation/read_the_story.mp3",
        );
      case 4:
        return Explanation(
          text: "Guess the word by choosing letters.",
          audioPath: "assets/explanation/guess_the_words.mp3",
        );
      case 5:
        return Explanation(
          text: "Arrange the words to make a sentence.",
          audioPath: "assets/explanation/arrange_the_words.mp3",
        );

      default:
        return SizedBox();
    }
  }

  Widget getBonusButton(int bonusScreen, int currentPage) {
    final appController = Get.find<AppController>();
    if (currentPage == 1 || currentPage == 2 || currentPage == 4) {
      debugPrint("Bonus button hidden");
      return SizedBox();
    }
    switch (bonusScreen) {
      case 0:
        return IconButton(
          onPressed: () {
            appController.isTrainingMode.value = false;
            Get.toNamed(CompleteSentence.route);
          },
          icon: Image.asset("assets/bonus_purple.png"),
        );
      case 1:
        return IconButton(
          onPressed: () {
            appController.isTrainingMode.value = false;
            Get.toNamed(BonusScreenFloatWords.route);
          },
          icon: Image.asset("assets/bonus_blue.png"),
        );
      case 2:
        return IconButton(
          onPressed: () {
            appController.isTrainingMode.value = false;
            Get.toNamed(MatchItScreen.route);
          },
          icon: Image.asset("assets/bonus_yellow.png"),
        );
      case 3:
        return IconButton(
          onPressed: () {
            appController.isTrainingMode.value = false;
            Get.toNamed(ToBeBonusScreen.routeName);
          },
          icon: Image.asset("assets/bonus_green.png"),
        );
      case 4:
        return IconButton(
          onPressed: () {
            appController.isTrainingMode.value = false;
            Get.toNamed(TrueOrFalseBonusScreen.routeName);
          },
          icon: Image.asset("assets/bonus_true_or_false.png"),
        );

      default:
        return SizedBox();
    }
  }
}
