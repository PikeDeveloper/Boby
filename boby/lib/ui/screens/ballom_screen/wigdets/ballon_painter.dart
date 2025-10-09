import 'dart:math';

import 'package:flutter/material.dart';

class BalloonWidget extends StatelessWidget {
   BalloonWidget({super.key, required this.sizePx, required this.color});

  final double sizePx;
  final Color color;

  List<String> colors = [
    "assets/yelow_ballon.png",
    "assets/blue_ballon.png",
    "assets/green_ballon.png",
      "assets/purple_ballon.png",
  ];

  @override
  Widget build(BuildContext context) {
    //retorna un widget con un balon de ccolor aleatorio
    return Image.asset(
      colors[Random().nextInt(colors.length)],
      width: sizePx *3 ,
      height: sizePx* 5
    );
  }
}
