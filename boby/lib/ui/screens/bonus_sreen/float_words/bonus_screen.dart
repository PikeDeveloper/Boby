import 'dart:math';
import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/shared/score.dart';
import 'package:boby/ui/shared/word_of_images.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'widgets/bonus_words.dart';

class BonusScreenFloatWords extends StatefulWidget {
  static const route = '/bonus_screen';
  const BonusScreenFloatWords({super.key});

  @override
  State<BonusScreenFloatWords> createState() => _BonusScreenFloatWordsState();
}

class _BonusScreenFloatWordsState extends State<BonusScreenFloatWords>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final Random _random = Random();

  final StorageService storage = Get.find<StorageService>();

  // Game State
  late Map<String, dynamic> _targetCategory;
  final List<FloatingWord> _activeWords = [];
  final List<ScoreFeedbackItem> _feedbacks = [];

  // Sounds
  final String soundPathIncorrectAnswer = "assets/sounds/bubble-pop.wav";
  final String soundPathCorrectAnswer = "assets/sounds/game-bonus.wav";

  // Configuration
  final int _maxWords = 9;
  final double _spawnInterval = 50.0; // Frames roughly
  double _timeSinceLastSpawn = 0;

  // Timer
  final Duration _gameDuration = const Duration(seconds: 20);
  Duration _elapsedTime = Duration.zero;
  bool _isGameOver = false;

  static const List<Color> _spawnColorOptions = [
    Color(0xFF29B6F6), // Vibrant Sky Blue
    Color(0xFFFF9800), // Vibrant Sunny Orange
    Color(0xFFAB47BC), // Vibrant Playful Purple
  ];

  late Color _currentRoundColor;

  @override
  void initState() {
    super.initState();
    _startNewGame();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _startNewGame() {
    _targetCategory =
        BonusWords.bonusWords[_random.nextInt(BonusWords.bonusWords.length)];
    _currentRoundColor =
        _spawnColorOptions[_random.nextInt(_spawnColorOptions.length)];
    _activeWords.clear();
    _feedbacks.clear();
    _elapsedTime = Duration.zero;
    _isGameOver = false;
    _timeSinceLastSpawn = _spawnInterval;
  }

  Duration _lastElapsed = Duration.zero;

  void _onTick(Duration elapsed) {
    if (_isGameOver) return;

    setState(() {
      final delta = elapsed - _lastElapsed;
      _lastElapsed = elapsed;

      // Update Timer
      _elapsedTime += delta;
      if (_elapsedTime >= _gameDuration) {
        _isGameOver = true;
        _elapsedTime = _gameDuration;
        _handleGameOver();
        return;
      }

      // Update positions and wobble
      for (var word in _activeWords) {
        word.y -= word.speed;
        word.wobble += 0.06;
      }

      // Remove words when they float above the play area (y < -0.05)
      _activeWords.removeWhere((word) => word.y < -0.05);

      // Spawn new words
      _timeSinceLastSpawn++;
      if (_activeWords.length < _maxWords &&
          _timeSinceLastSpawn > _spawnInterval) {
        if (_random.nextDouble() < 0.85) {
          _spawnWord();
          _timeSinceLastSpawn = 0;
        }
      }

      // Update feedbacks
      final now = DateTime.now();
      _feedbacks.removeWhere(
        (item) => now.difference(item.creationTime).inMilliseconds > 1000,
      );
    });
  }

  void _handleGameOver() {
    final appController = Get.find<AppController>();
    appController.bonusScreen.value = 7;
    Get.back();
  }

  void _spawnWord() {
    bool spawnCorrect = _random.nextBool();
    String wordText;

    List<String> correctOptions = List<String>.from(_targetCategory['options']);

    if (spawnCorrect) {
      wordText = correctOptions[_random.nextInt(correctOptions.length)];
    } else {
      var otherCategories = BonusWords.bonusWords
          .where((c) => c != _targetCategory)
          .toList();
      if (otherCategories.isNotEmpty) {
        var randomCat =
            otherCategories[_random.nextInt(otherCategories.length)];
        List<String> otherOptions = List<String>.from(randomCat['options']);
        wordText = otherOptions[_random.nextInt(otherOptions.length)];
      } else {
        wordText = "WRONG";
      }
    }

    double startX = 0.08 + _random.nextDouble() * 0.65;

    _activeWords.add(
      FloatingWord(
        text: wordText,
        x: startX,
        y: 1.05, // Starts at bottom of play area
        speed: 0.0022 + _random.nextDouble() * 0.002,
        wobble: _random.nextDouble() * pi * 2,
        isTarget: correctOptions.contains(wordText),
        badgeColor: _currentRoundColor,
      ),
    );
  }

  void _handleTap(FloatingWord word, String gameSelected) {
    final appController = Get.find<AppController>();
    if (word.resultColor != null) return; // Already tapped

    setState(() {
      if (word.isTarget) {
        word.resultColor = const Color(0xFF4CAF50);
        _addFeedback(word, "+2", const Color(0xFF4CAF50));
        Get.find<AppController>().playGameBonus();
        if (!appController.isTrainingMode.value) {
          storage.incScoreCorrect(gameSelected);
          storage.incScoreCorrect(gameSelected);
        }
      } else {
        word.resultColor = const Color(0xFFEF5350);
        _addFeedback(word, "-1", const Color(0xFFEF5350));
        Get.find<AppController>().playBubblePop();
        if (!appController.isTrainingMode.value) {
          storage.incScoreWrong(gameSelected);
        }
      }
    });
  }

  void _addFeedback(FloatingWord word, String text, Color color) {
    _feedbacks.add(
      ScoreFeedbackItem(
        text: text,
        x: word.x,
        y: word.y,
        color: color,
        creationTime: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bonus_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Main Layout Structure
          SafeArea(
            child: Column(
              children: [
                // Top Header (Score + Category Prompt Banner)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Column(
                    children: [
                      Score(game: appController.gameSelected.value),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Progress bar
                            Container(
                              height: 16,
                              width: screenSize.width * 0.75,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  height: 16,
                                  width: (screenSize.width * 0.75) *
                                      (1.0 -
                                          (_elapsedTime.inMilliseconds /
                                                  _gameDuration.inMilliseconds)
                                              .clamp(0.0, 1.0)),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF29B6F6),
                                        Color(0xFF0288D1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Touch the words related to:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.darkBlue,
                              ),
                            ),
                            const SizedBox(height: 6),
                            WordOfImages(
                              letters: _targetCategory['word'],
                              letterSize: 22,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bounded Floating Words Play Area
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final playAreaWidth = constraints.maxWidth;
                      final playAreaHeight = constraints.maxHeight;

                      return Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          // Active Floating Word Balloons
                          ..._activeWords.map((word) {
                            final double driftX = sin(word.wobble) * 12;
                            final double leftPos = (playAreaWidth * word.x) + driftX;
                            final double topPos = playAreaHeight * word.y;

                            final Color displayColor =
                                word.resultColor ?? word.badgeColor;

                            return Positioned(
                              left: leftPos.clamp(8.0, playAreaWidth - 140.0),
                              top: topPos,
                              child: GestureDetector(
                                onTap: () => _handleTap(
                                  word,
                                  appController.gameSelected.value,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: displayColor,
                                    gradient: LinearGradient(
                                      colors: [
                                        displayColor,
                                        Color.alphaBlend(
                                          Colors.black.withValues(alpha: 0.15),
                                          displayColor,
                                        ),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: displayColor.withValues(alpha: 0.45),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (word.resultColor != null) ...[
                                        Icon(
                                          word.isTarget
                                              ? Icons.check_circle_rounded
                                              : Icons.cancel_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                      Text(
                                        word.text,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),

                          // Score Feedbacks (+2 / -1)
                          ..._feedbacks.map((feedback) {
                            final age = DateTime.now()
                                .difference(feedback.creationTime)
                                .inMilliseconds;
                            final progress = (age / 1000.0).clamp(0.0, 1.0);
                            final double currentY =
                                (playAreaHeight * feedback.y) - (progress * 50);
                            final double opacity = (1.0 - progress).clamp(0.0, 1.0);
                            final double scale = 1.0 + (sin(progress * pi) * 0.4);

                            return Positioned(
                              left: (playAreaWidth * feedback.x).clamp(10.0, playAreaWidth - 60.0),
                              top: currentY,
                              child: Opacity(
                                opacity: opacity,
                                child: Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: feedback.color,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: feedback.color.withValues(alpha: 0.4),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      feedback.text,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingWord {
  String text;
  double x; // 0.0 to 1.0
  double y; // 1.0 (bottom) to 0.0 (top of play area)
  double speed;
  double wobble;
  bool isTarget;
  Color badgeColor;
  Color? resultColor;

  FloatingWord({
    required this.text,
    required this.x,
    required this.y,
    required this.speed,
    required this.wobble,
    required this.isTarget,
    required this.badgeColor,
    this.resultColor,
  });
}

class ScoreFeedbackItem {
  String text;
  double x;
  double y;
  Color color;
  DateTime creationTime;

  ScoreFeedbackItem({
    required this.text,
    required this.x,
    required this.y,
    required this.color,
    required this.creationTime,
  });
}

