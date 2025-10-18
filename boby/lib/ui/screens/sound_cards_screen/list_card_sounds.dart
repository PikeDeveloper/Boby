import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'widgets/card_sound.dart';

class ListCardSounds extends StatelessWidget {
  ListCardSounds({super.key});

  final List<Map<String, String>> assets = Constants.assets;  


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double width = 0;
    if (screenWidth < 300) {
      width = screenWidth * 0.4;
    } else if (screenWidth < 700) {
      width = screenWidth * 0.3;
    } else {
      width = screenWidth * 0.2;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: width, // máximo ancho por item
          crossAxisSpacing: width * 0.1,
          mainAxisSpacing: width * 0.1,
          childAspectRatio: 1, // cuadrado (ancho = alto)
        ),
      
        itemCount: assets.length,
      
        itemBuilder: (context, index) {
          return CardSound(
            image: assets[index]["image"]!,
            name: assets[index]["name"]!,
            sound: assets[index]["sound"]!,
          );
        },
      ),
    );
  }
}
