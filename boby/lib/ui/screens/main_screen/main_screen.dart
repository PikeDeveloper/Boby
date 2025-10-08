import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/main_screen/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/main_menu.dart';
import '../about/about.dart';
import '../ballom_screen/ballom_screen.dart';
import '../memory/memory_screen.dart';
import '../setting_screen/setting_sacreen.dart';
import '../sound_cards_screen/list_card_sounds.dart';
import 'widgets/drawer.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main_screen';

  MainScreen({super.key});

  final List<Widget> screens = [
    ListCardSounds(),
    MemoryScreen(),
    BallomScreen(),
    SettingScreen(),
    //AbautScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.put<AppController>(AppController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              appController.menuOpen.value = !appController.menuOpen.value;
            },
            icon: Icon(Icons.menu),
          ),
        ],
        title: const Text('Boby App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            Background(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: screens[appController.currentPage.value],
            ),
            appController.menuOpen.value ? MainMenu() : SizedBox(),
          ],
        ),
      ),
    );
  }
}
