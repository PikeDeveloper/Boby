import 'dart:math';

import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/shared/score.dart';
import 'package:boby/ui/shared/word_of_images.dart';
import 'package:flutter/material.dart';
import 'package:boby/ui/screens/scramble_word/widgets/sentences.dart';
import 'package:get/get.dart';

class ScrambleScreen extends StatefulWidget {
  const ScrambleScreen({super.key});

  @override
  State<ScrambleScreen> createState() => _ScrambleScreenState();
}

class _ScrambleScreenState extends State<ScrambleScreen> {
  late String currentSentence;
  late List<String> correctWords;
  late List<String> scrambledWords;
  List<String?> droppedWords = [];
  int score = 0;
  bool showFeedback = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadNewSentence();
  }

  void _loadNewSentence() {
    final appController = Get.find<AppController>();
    final List<String> sentences = appController.scrableLevel.value == "easy"
        ? Sentences.sentencesEasyLevel
        : appController.scrableLevel.value == "medium"
        ? Sentences.sentencesMediumLevel
        : Sentences.sentencesHardLevel;

    setState(() {
      currentSentence = sentences[Random().nextInt(sentences.length)];
      correctWords = currentSentence.split(' ');
      scrambledWords = List.from(correctWords)..shuffle();
      droppedWords = List.filled(correctWords.length, null);
      showFeedback = false;
      isCorrect = false;
    });
  }

  void _checkAnswer() {
    bool correct = true;
    for (int i = 0; i < correctWords.length; i++) {
      if (droppedWords[i] != correctWords[i]) {
        correct = false;
        break;
      }
    }

    setState(() {
      isCorrect = correct;
      showFeedback = true;
      if (correct) {
        score += 10;
      }
    });

    if (correct) {
      Future.delayed(const Duration(seconds: 2), () {
        _loadNewSentence();
      });
    } else {
      // Auto-reset after 1 second on incorrect answer
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          droppedWords = List.filled(correctWords.length, null);
          showFeedback = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Score and Controls
          Score(game: "ScrambleWord"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WordOfImages(letters: "ORDER", letterSize: 18),
              WordOfImages(letters: "THE", letterSize: 18),
              WordOfImages(letters: "WORDS", letterSize: 18),
            ],
          ),
          const SizedBox(height: 20),

          // Drop Zone (Top)
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: showFeedback
                    ? (isCorrect ? Colors.green.shade100 : Colors.red.shade100)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: showFeedback
                      ? (isCorrect ? Colors.green : Colors.red)
                      : Colors.grey.shade400,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showFeedback)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect ? Colors.green : Colors.red,
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isCorrect ? 'Correct!' : 'Try again!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Single line sentence display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: List.generate(
                        correctWords.length,
                        (index) => _buildDropTarget(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Scrambled Words (Bottom)
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: scrambledWords.map((word) {
                      bool isUsed = droppedWords.contains(word);
                      return _buildDraggableWord(word, isUsed);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropTarget(int index) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) =>
          droppedWords[index] == null && !showFeedback,
      onAcceptWithDetails: (details) {
        setState(() {
          droppedWords[index] = details.data;
        });

        // Auto-check when all words are placed
        if (droppedWords.every((word) => word != null)) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _checkAnswer();
          });
        }
      },
      builder: (context, candidateData, rejectedData) {
        bool isHighlighted = candidateData.isNotEmpty;

        return GestureDetector(
          onTap: () {
            if (!showFeedback && droppedWords[index] != null) {
              setState(() {
                droppedWords[index] = null;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? Colors.blue.shade100.withOpacity(0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              droppedWords[index] ?? '_____',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: droppedWords[index] != null
                    ? Colors.black
                    : Colors.grey.shade400,
                decoration: droppedWords[index] == null
                    ? TextDecoration.underline
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraggableWord(String word, bool isUsed) {
    if (isUsed) {
      return Opacity(
        opacity: 0.3,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            word,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Draggable<String>(
      data: word,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            word,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            word,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          word,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
