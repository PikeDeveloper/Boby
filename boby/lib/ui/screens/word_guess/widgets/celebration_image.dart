import 'package:flutter/material.dart';

class CelebrationImage extends StatelessWidget {
  const CelebrationImage({super.key});

  @override
  Widget build(BuildContext context) {
       final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return  Center(child: Column(
                 children: [
                   Image.asset("assets/confeti.gif", height: screenHeight / 2.5, width: screenWidth, fit: BoxFit.cover  ,),
                   Image.asset("assets/confeti.gif", height: screenHeight / 2.5, width: screenWidth, fit: BoxFit.cover  ,),
                 ],
               ),);
  }
}