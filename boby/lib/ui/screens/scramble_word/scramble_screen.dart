import 'dart:math';

import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/screens/scramble_word/widgets/draggable_word.dart';
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
  bool showFeedback = false;
  bool isCorrect = false;
  bool clueMode = false; // Track if clue mode is enabled
  final StorageService _storageService = StorageService.instance;

  // Sound paths
  final String soundPathIncorrectAnswer = "assets/sounds/bubble-pop.wav";
  final String soundPathCorrectAnswer = "assets/sounds/game-bonus.wav";

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

  void _addWordToDropZone(String word) {
    if (showFeedback) return; // Don't allow adding words during feedback

    setState(() {
      // Find the first empty slot
      final emptyIndex = droppedWords.indexOf(null);
      if (emptyIndex != -1) {
        droppedWords[emptyIndex] = word;
      }
    });

    // Auto-check when all words are placed
    if (droppedWords.every((word) => word != null)) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _checkAnswer();
      });
    }
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
    });

    // Update persistent storage and play sounds
    final appController = Get.find<AppController>();
    if (correct) {
      _storageService.incScrambleWordCorrect();
      appController.playMenuSound(soundPathCorrectAnswer);
    } else {
      _storageService.incScrambleWordWrong();
      appController.playMenuSound(soundPathIncorrectAnswer);
    }

    if (correct) {
      Future.delayed(const Duration(seconds: 1), () async {
        appController.setBonusScreen();
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
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final appController = Get.find<AppController>();
    final bool isLargeScreen = width > 600;

    return Stack(
      children: [
        clueButton(isLargeScreen),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Score and Controls
              Score(game: appController.gameSelected.value),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WordOfImages(
                    letters: "ORDER",
                    letterSize: isLargeScreen ? 30 : 18,
                  ),
                  WordOfImages(
                    letters: "THE",
                    letterSize: isLargeScreen ? 30 : 18,
                  ),
                  WordOfImages(
                    letters: "WORDS",
                    letterSize: isLargeScreen ? 30 : 18,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Clue button
              const SizedBox(height: 20),

              // Drop Zone (Top)
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: showFeedback
                        ? (isCorrect
                              ? Colors.green.shade100
                              : Colors.red.shade100)
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
                      // Drop zone area with multi-line support
                      showFeedback
                          ? Text(
                              isCorrect ? "Correct!" : "Try again!",
                              style: TextStyle(
                                fontSize: isLargeScreen ? 26 : 22,
                                fontWeight: FontWeight.bold,
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                            )
                          : const SizedBox(height: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DragTarget<String>(
                            onWillAcceptWithDetails: (details) => !showFeedback,
                            onAcceptWithDetails: (details) {
                              setState(() {
                                // Find the first empty slot
                                final emptyIndex = droppedWords.indexOf(null);
                                if (emptyIndex != -1) {
                                  droppedWords[emptyIndex] = details.data;
                                }
                              });

                              // Auto-check when all words are placed
                              if (droppedWords.every((word) => word != null)) {
                                Future.delayed(
                                  const Duration(milliseconds: 300),
                                  () {
                                    _checkAnswer();
                                  },
                                );
                              }
                            },
                            builder: (context, candidateData, rejectedData) {
                              bool isHighlighted = candidateData.isNotEmpty;

                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isHighlighted
                                      ? Colors.blue.shade100
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isHighlighted
                                        ? Colors.blue.shade400
                                        : Colors.grey.shade400,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: droppedWords.asMap().entries.map((
                                      entry,
                                    ) {
                                      final index = entry.key;
                                      final word = entry.value;

                                      if (word != null) {
                                        // Check if word is in correct position for clue mode
                                        bool isWordCorrect =
                                            word == correctWords[index];

                                        // Determine color based on clue mode and correctness
                                        Color wordColor;
                                        if (showFeedback) {
                                          // During feedback, use default blue
                                          wordColor = Colors.blue.shade400;
                                        } else if (clueMode) {
                                          // In clue mode, show green for correct, light red for incorrect
                                          wordColor = isWordCorrect
                                              ? Colors.green.shade400
                                              : Colors.red.shade300;
                                        } else {
                                          // Default blue when clue mode is off
                                          wordColor = Colors.blue.shade400;
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            if (!showFeedback) {
                                              setState(() {
                                                droppedWords[index] = null;
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: wordColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              word,
                                              style: TextStyle(
                                                fontSize: isLargeScreen
                                                    ? 25
                                                    : 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
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
                          return DraggableWord(
                            word: word,
                            isUsed: isUsed,
                            onTap: () => _addWordToDropZone(word),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Positioned clueButton(bool isLargeScreen) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          setState(() {
            clueMode = !clueMode;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: clueMode ? Colors.amber.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: clueMode ? Colors.amber.shade600 : Colors.grey.shade400,
              width: 2,
            ),
            boxShadow: clueMode
                ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/clue-icon.png', width: 24, height: 24),
              const SizedBox(width: 8),
              Text(
                clueMode ? 'Clue ON' : 'Clue OFF',
                style: TextStyle(
                  fontSize: isLargeScreen ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: clueMode
                      ? Colors.amber.shade900
                      : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
