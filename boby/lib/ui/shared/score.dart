import 'dart:math';

import 'package:flutter/material.dart';
import 'package:boby/services/storage_service.dart';

typedef ScoreTapCallback = void Function(BuildContext context);

class Score extends StatelessWidget {
  final int correct;
  final int wrong;
  final String correctLabel;
  final String wrongLabel;
  final bool showPercentage;
  final ScoreTapCallback onTap;

  const Score({
    super.key,
    required this.correct,
    required this.wrong,
    this.correctLabel = 'Aciertos',
    this.wrongLabel = 'Fallos',
    this.showPercentage = true,
    required this.onTap,
  });

  // Constructor for math-specific score
  Score.math({
    super.key,
    required this.correct,
    required this.wrong,
    ScoreTapCallback? onTap,
  })  : correctLabel = 'Aciertos',
        wrongLabel = 'Fallos',
        showPercentage = true,
        onTap = onTap ?? _showMathRestoreDialog;

  // Constructor for memory game score
  Score.memory({
    super.key,
    required this.correct,
    required this.wrong,
    ScoreTapCallback? onTap,
  })  : correctLabel = 'Aciertos',
        wrongLabel = 'Fallos',
        showPercentage = false,
        onTap = onTap ?? _showMemoryRestoreDialog;

  // Constructor for sound cards game score
  Score.soundCards({
    super.key,
    required this.correct,
    required this.wrong,
    ScoreTapCallback? onTap,
  })  : correctLabel = 'Correctas',
        wrongLabel = 'Incorrectas',
        showPercentage = true,
        onTap = onTap ?? _showSoundCardsRestoreDialog;

  // Constructor for word guess game score
  Score.wordGuess({
    super.key,
    required this.correct,
    required this.wrong,
    ScoreTapCallback? onTap,
  })  : correctLabel = 'Aciertos',
        wrongLabel = 'Fallos',
        showPercentage = true,
        onTap = onTap ?? _showWordGuessRestoreDialog;
        
  // Constructor for colors game score
  Score.colors({
    super.key,
    required this.correct,
    required this.wrong,
    ScoreTapCallback? onTap,
  })  : correctLabel = 'Correctos',
        wrongLabel = 'Incorrectos',
        showPercentage = true,
        onTap = onTap ?? _showColorsRestoreDialog;
        
  // Constructor for numbers game score
  Score.numbers({
    super.key,
    required this.correct,
    required this.wrong,
    ScoreTapCallback? onTap,
  })  : correctLabel = 'Correctos',
        wrongLabel = 'Incorrectos',
        showPercentage = true,
        onTap = onTap ?? _showNumbersRestoreDialog;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final minSize = min(screenWidth, screenHeight);
    final letterSize = minSize / 8;
 
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Builder(
          builder: (context) {

            TextStyle styleLabel = TextStyle(
                fontSize: letterSize * 0.28, fontWeight: FontWeight.w600);
            TextStyle styleValue = TextStyle(
                fontSize: letterSize * 0.35, fontWeight: FontWeight.bold);

            Widget col(String label, String value, Color color) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: styleLabel.copyWith(color: color)),
                    const SizedBox(width: 4),
                    Text(value, style: styleValue.copyWith(color: color)),
                  ],
                );

            final children = <Widget>[
              col(correctLabel, '$correct', Colors.green),
              if (showPercentage) SizedBox(width: letterSize),
             
              SizedBox(width: letterSize),
              col(wrongLabel, '$wrong', Colors.red),
            ];

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            );
          },
        )
      ),
    );
  }

  static void _showMathRestoreDialog(BuildContext context) {
    _showRestoreDialog(
      context,
      onRestore: () {
        StorageService.instance.setMathCorrect(0);
        StorageService.instance.setMathWrong(0);
      },
    );
  }

  static void _showMemoryRestoreDialog(BuildContext context) {
    _showRestoreDialog(
      context,
      onRestore: () {
        StorageService.instance.setMemoryCorrect(0);
        StorageService.instance.setMemoryWrong(0);
      },
    );
  }

  static void _showSoundCardsRestoreDialog(BuildContext context) {
    _showRestoreDialog(
      context,
      onRestore: () {
        StorageService.instance.setSoundCardsCorrect(0);
        StorageService.instance.setSoundCardsWrong(0);
      },
    );
  }

  static void _showWordGuessRestoreDialog(BuildContext context) {
    _showRestoreDialog(
      context,
      onRestore: () {
        StorageService.instance.setWordGuessCorrect(0);
        StorageService.instance.setWordGuessWrong(0);
      },
    );
  }
  
  static void _showColorsRestoreDialog(BuildContext context) {
    _showRestoreDialog(
      context,
      onRestore: () {
        StorageService.instance.setColorsCorrect(0);
      },
    );
  }
  
  static void _showNumbersRestoreDialog(BuildContext context) {
    _showRestoreDialog(
      context,
      onRestore: () {
        StorageService.instance.setNumbersCorrect(0);
      },
    );
  }

  static void _showRestoreDialog(
    BuildContext context, {
    required VoidCallback onRestore,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Restablecer Contador',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: const Text('¿Estás seguro de que quieres restablecer el contador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              onRestore();
              Navigator.pop(context);
            },
            child: const Text(
              'Restablecer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
