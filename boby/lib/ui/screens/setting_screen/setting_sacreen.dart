import 'package:flutter/material.dart';

import 'widgets/background_card.dart';
import 'widgets/background_word.dart';

class SettingScreen extends StatelessWidget {
  static const String route = '/setting_screen';
  SettingScreen({super.key});

  List<String> backGrounds = [
    "assets/backgrounds/sabana.jpg",
    "assets/backgrounds/farm.jpg",
    "assets/backgrounds/grass.jpg",
    "assets/backgrounds/oceano.jpg",
    "assets/backgrounds/oso.jpg",
    "assets/backgrounds/soft.png",
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double width = 0;
    if (screenWidth < 300) {
      width = screenWidth * 0.4;
    } else {
      width = screenWidth * 0.3;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        BackgroundWord(),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: width, // máximo ancho por item
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1, // cuadrado (ancho = alto)
          ),

          itemCount: backGrounds.length,

          itemBuilder: (context, index) {
            return BackgroundCard(image: backGrounds[index]);
          },
        ),
      ],
    );
  }
}
