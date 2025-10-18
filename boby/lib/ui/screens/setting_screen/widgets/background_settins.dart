import 'dart:math';

import 'package:boby/ui/screens/setting_screen/widgets/background_card.dart';
import 'package:flutter/material.dart';

class BackgroundSettings extends StatelessWidget {
   BackgroundSettings({super.key});

   List<String> backGrounds = [
    "assets/backgrounds/sabana.png",
    "assets/backgrounds/farm.jpg",
    "assets/backgrounds/grass.jpg",
    "assets/backgrounds/oceano.png",
    "assets/backgrounds/oso.jpg",
    "assets/backgrounds/soft.png",
  ];

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final minSize = min(screenWidth, screenHeight); 

    final cardWidth = minSize * 0.2;
    
    return   GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: cardWidth, // máximo ancho por item
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 1, // cuadrado (ancho = alto)
            ),
      
            itemCount: backGrounds.length,
      
            itemBuilder: (context, index) {
              return BackgroundCard(image: backGrounds[index]);
            },
          );
  }
}