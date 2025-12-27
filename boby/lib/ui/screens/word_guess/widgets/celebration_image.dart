import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class CelebrationImage extends StatefulWidget {
  const CelebrationImage({super.key});

  @override
  State<CelebrationImage> createState() => _CelebrationImageState();
}

class _CelebrationImageState extends State<CelebrationImage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti from top-left
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // down
            emissionFrequency: 0.01,
            numberOfParticles: 7,
            gravity: 0.3,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.orange,
              Colors.purple,
              Colors.pink,
            ],
          ),
        ),
        // Confetti from top-center
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // down
            emissionFrequency: 0.01,
            numberOfParticles: 7,
            gravity: 0.3,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.orange,
              Colors.purple,
              Colors.pink,
            ],
          ),
        ),
        // Confetti from top-right
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // down
            emissionFrequency: 0.01,
            numberOfParticles: 7,
            gravity: 0.3,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.orange,
              Colors.purple,
              Colors.pink,
            ],
          ),
        ),
      ],
    );
  }
}
