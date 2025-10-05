import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../sound_cards_screen/list_card_sounds.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main_screen';

  MainScreen({super.key});

  final List<Widget> screens = [ListCardSounds()];

  @override
  Widget build(BuildContext context) {
    final appController = Get.put<AppController>(AppController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boby App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [Image.asset('assets/backgrounds/sabana.jpg'), screens[0]],
      ),
    );
  }
}
