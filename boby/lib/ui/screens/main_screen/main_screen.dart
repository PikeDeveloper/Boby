import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../about/about.dart';
import '../setting_screen/setting_sacreen.dart';
import '../sound_cards_screen/list_card_sounds.dart';
import 'widgets/drawer.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main_screen';

  MainScreen({super.key});

  final List<Widget> screens = [
    ListCardSounds(),
    SettingScreen(),
    AbautScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.put<AppController>(AppController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boby App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(child: DrawerMenu()),
      body: Obx(
        () => Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                appController.backGroundImage.value == ""
                    ? "assets/backgrounds/sabana.jpg"
                    : appController.backGroundImage.value,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: screens[appController.currentPage.value],
            ),
          ],
        ),
      ),
    );
  }
}
