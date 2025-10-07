import 'package:flutter/material.dart';

import 'wigdets/ballon_painter.dart';


class BallomScreen extends StatelessWidget {
  const BallomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BalloonWidget(color: Colors.red, sizePx: 100);
  }
}