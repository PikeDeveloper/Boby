import 'package:boby/ui/screens/setting_screen/widgets/background_settins.dart';
import 'package:boby/ui/screens/setting_screen/widgets/math_settings.dart';
import 'package:boby/ui/screens/setting_screen/widgets/memory_settings.dart';
import 'package:flutter/material.dart';

import '../../shared/letter_button.dart';
import '../../shared/word_of_images.dart';
import 'widgets/background_card.dart';
import 'widgets/background_word.dart';

class SettingScreen extends StatelessWidget {
  static const String route = '/setting_screen';
  SettingScreen({super.key});

 

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
  

    return SingleChildScrollView(
      child: Column(
   
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          WordOfImages(  letters: [      "B",
      "A",
      "C",
      "K",
      "G",
      "R",
      "O",
      "U",
      "N",
      "D",
      "S",
        ], letterSize: 25),
         BackgroundSettings(),  
          SizedBox(height: 100),
          WordOfImages(  letters: ["M", "A", "T", "H"], letterSize: 25),
         MathSettings(),
         SizedBox(height: 100),
         WordOfImages(  letters: ["M", "E", "M", "O", "R", "Y"], letterSize: 25),
         MemrySettings(),
         SizedBox(height: 100),
        ],
      ),
    );
  }
}
