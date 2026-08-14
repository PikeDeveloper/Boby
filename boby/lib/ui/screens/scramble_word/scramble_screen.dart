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

              const SizedBox(height: 16),

              // Drop Zone (Top)
              Expanded(
                flex: 3,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: showFeedback
                        ? (isCorrect
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFFFEBEE))
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: showFeedback
                          ? (isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFEF5350))
                          : Colors.grey.shade300,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: showFeedback
                            ? (isCorrect
                                  ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
                                  : const Color(0xFFEF5350).withValues(alpha: 0.3))
                            : Colors.black.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showFeedback)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            isCorrect ? "🎉 Great job!" : "Try again! 💪",
                            style: TextStyle(
                              fontSize: isLargeScreen ? 26 : 22,
                              fontWeight: FontWeight.bold,
                              color: isCorrect
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFC62828),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: DragTarget<String>(
                            onWillAcceptWithDetails: (details) => !showFeedback,
                            onAcceptWithDetails: (details) {
                              setState(() {
                                final emptyIndex = droppedWords.indexOf(null);
                                if (emptyIndex != -1) {
                                  droppedWords[emptyIndex] = details.data;
                                }
                              });

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

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isHighlighted
                                      ? const Color(0xFFE1F5FE)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isHighlighted
                                        ? const Color(0xFF0288D1)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: droppedWords.every((w) => w == null)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.touch_app_rounded,
                                              size: isLargeScreen ? 38 : 30,
                                              color: const Color(0xFF29B6F6)
                                                  .withValues(alpha: 0.6),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Tap or drag words here to build your sentence!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize:
                                                    isLargeScreen ? 18 : 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: droppedWords
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            final index = entry.key;
                                            final word = entry.value;

                                            if (word != null) {
                                              bool isWordCorrect =
                                                  word == correctWords[index];

                                              List<Color> gradientColors;
                                              if (showFeedback) {
                                                gradientColors = isCorrect
                                                    ? [
                                                        const Color(0xFF66BB6A),
                                                        const Color(0xFF388E3C),
                                                      ]
                                                    : [
                                                        const Color(0xFFEF5350),
                                                        const Color(0xFFD32F2F),
                                                      ];
                                              } else if (clueMode) {
                                                gradientColors = isWordCorrect
                                                    ? [
                                                        const Color(0xFF26A69A),
                                                        const Color(0xFF00695C),
                                                      ]
                                                    : [
                                                        const Color(0xFFEF5350),
                                                        const Color(0xFFD32F2F),
                                                      ];
                                              } else {
                                                gradientColors = [
                                                  const Color(0xFF29B6F6),
                                                  const Color(0xFF0277BD),
                                                ];
                                              }

                                              return GestureDetector(
                                                onTap: () {
                                                  if (!showFeedback) {
                                                    setState(() {
                                                      droppedWords[index] = null;
                                                    });
                                                  }
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 180,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      22,
                                                    ),
                                                    gradient: LinearGradient(
                                                      colors: gradientColors,
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: gradientColors
                                                            .last
                                                            .withValues(
                                                          alpha: 0.4,
                                                        ),
                                                        blurRadius: 6,
                                                        offset: const Offset(
                                                          0,
                                                          3,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        word,
                                                        style: TextStyle(
                                                          fontSize:
                                                              isLargeScreen
                                                                  ? 24
                                                                  : 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Icon(
                                                        Icons.close_rounded,
                                                        color: Colors.white
                                                            .withValues(
                                                          alpha: 0.8,
                                                        ),
                                                        size: 16,
                                                      ),
                                                    ],
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

              const SizedBox(height: 16),

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: clueMode ? const Color(0xFFFFF8E1) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: clueMode ? Colors.amber.shade700 : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: clueMode
                    ? Colors.amber.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.1),
                blurRadius: clueMode ? 10 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/clue-icon.png', width: 24, height: 24),
              const SizedBox(width: 6),
              Text(
                clueMode ? 'Clue ON' : 'Clue OFF',
                style: TextStyle(
                  fontSize: isLargeScreen ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: clueMode
                      ? Colors.amber.shade900
                      : const Color(0xFF546E7A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
