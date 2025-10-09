import 'package:flutter/material.dart';

class BalloonWidget extends StatelessWidget {
   const BalloonWidget({super.key, required this.colorIndex});

  final int colorIndex;

  static const List<String> colors = [
    "assets/yelow_ballon.png",
    "assets/blue_ballon.png",
    "assets/green_ballon.png",
    "assets/purple_ballon.png",
  ];

  @override
  Widget build(BuildContext context) {
    //retorna un widget con un balon de color fijo basado en colorIndex
    return Image.asset(
      colors[colorIndex],
      
      height: 400,
    );
  }
}
