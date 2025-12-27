import 'dart:math';

import 'package:boby/ui/shared/letter_button.dart';
import 'package:flutter/material.dart';

class WinnerScreen extends StatefulWidget {
  const WinnerScreen({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final minSize = min(screenWidth, screenHeight);
    final winnerMessages = ["W", "I", "N", "N", "E", "R"];
    final playAgain = ["P", "L", "A", "Y", " ", "A", "G", "A", "I", "N"];

    final letterSize = minSize / 8;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: const Color.fromARGB(220, 245, 245, 245),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var letter in winnerMessages)
                    Image.asset(
                      "assets/letters_2/$letter.png",
                      height: letterSize.toDouble(),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    "assets/winner-cup.png",
                    width: minSize / 2,
                    height: minSize / 2,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              LetterButton(
                onTap: widget.onTap,
                letters: playAgain,
                letterSize: letterSize * 0.8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
