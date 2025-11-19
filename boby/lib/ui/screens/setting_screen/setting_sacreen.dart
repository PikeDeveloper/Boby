
import 'package:boby/ui/screens/setting_screen/widgets/background_settins.dart';
import 'package:boby/ui/screens/setting_screen/widgets/badge_setting.dart';
import 'package:boby/ui/screens/setting_screen/widgets/match_it.sattings.dart';
import 'package:boby/ui/screens/setting_screen/widgets/math_settings.dart';
import 'package:boby/ui/screens/setting_screen/widgets/memory_settings.dart';
import 'package:boby/ui/screens/setting_screen/widgets/more_apps.dart';
import 'package:flutter/material.dart';

import '../../shared/word_of_images.dart';

class SettingScreen extends StatelessWidget {
  static const String route = '/setting_screen';
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          WordOfImages(letters: "BACKGROUNDS", letterSize: 25),
          BackgroundSettings(),
          //SizedBox(height: 100),
          //WordOfImages(letters: "MATH", letterSize: 25),
          //MathSettings(),
          SizedBox(height: 100),
          WordOfImages(letters: "MEMORY", letterSize: 25), 
          MemrySettings(),
          SizedBox(height: 100),
          WordOfImages(letters: "MATCH", letterSize: 25),
          MatchItSettings(),
          SizedBox(height: 100),
          WordOfImages(letters: "BADGE", letterSize: 25),
          BadgeSettings(),
          SizedBox(height: 100),
          WordOfImages(letters: "MORE", letterSize: 25),
          MoreApps(),
          SizedBox(height: 100),
          
        ],
      ),
    );
  }
}
