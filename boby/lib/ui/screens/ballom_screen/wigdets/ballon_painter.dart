import 'package:flutter/material.dart';

class BalloonWidget extends StatelessWidget {
  const BalloonWidget({super.key, required this.sizePx, required this.color});

  final double sizePx;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/yelow_ballon.png",
      width: sizePx *3 ,
      height: sizePx* 5
    );
  }
}
