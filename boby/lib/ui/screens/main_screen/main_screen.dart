import 'package:flutter/material.dart';

import '../sounds_screen/widgets/list_card_sounds.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main_screen';


   MainScreen({super.key});

  List Screens = [
    ListCardSounds(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boby App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body:  Screens[0],
      
      
    );
  }
}