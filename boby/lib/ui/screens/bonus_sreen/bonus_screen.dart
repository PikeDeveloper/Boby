import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'bonus_words.dart';

class BonusScreen extends StatefulWidget {
  static const route = '/bonus_screen';
  const BonusScreen({super.key});

  @override
  State<BonusScreen> createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final Random _random = Random();

  // Game State
  late Map<String, dynamic> _targetCategory;
  final List<FloatingWord> _activeWords = [];
  final List<ScoreFeedbackItem> _feedbacks = [];

  // Configuration
  final int _maxWords = 5;
  final double _spawnInterval = 60.0; // Frames roughly
  double _timeSinceLastSpawn = 0;

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
    // Select a random category
    _targetCategory =
        BonusWords.bonusWords[_random.nextInt(BonusWords.bonusWords.length)];
    _activeWords.clear();
    _feedbacks.clear();
  }

  void _onTick(Duration elapsed) {
    setState(() {
      // 1. Update positions
      for (var word in _activeWords) {
        word.y -= word.speed;
      }

      // 2. Remove off-screen words
      _activeWords.removeWhere((word) => word.y < -0.1);

      // 3. Spawn new words
      _timeSinceLastSpawn++;
      if (_activeWords.length < _maxWords &&
          _timeSinceLastSpawn > _spawnInterval) {
        if (_random.nextDouble() < 0.8) {
          // 80% chance to spawn if slot open
          _spawnWord();
          _timeSinceLastSpawn = 0;
        }
      }

      // 4. Update feedbacks (remove old ones)
      final now = DateTime.now();
      _feedbacks.removeWhere(
        (item) => now.difference(item.creationTime).inMilliseconds > 1000,
      );
    });
  }

  void _spawnWord() {
    bool spawnCorrect = _random.nextBool();
    String wordText;

    List<String> correctOptions = List<String>.from(_targetCategory['options']);

    if (spawnCorrect) {
      wordText = correctOptions[_random.nextInt(correctOptions.length)];
    } else {
      // Pick a random other category
      var otherCategories = BonusWords.bonusWords
          .where((c) => c != _targetCategory)
          .toList();
      if (otherCategories.isNotEmpty) {
        var randomCat =
            otherCategories[_random.nextInt(otherCategories.length)];
        List<String> otherOptions = List<String>.from(randomCat['options']);
        wordText = otherOptions[_random.nextInt(otherOptions.length)];
      } else {
        // Fallback if no other categories (unlikely)
        wordText = "WRONG";
      }
    }

    // Random X position (0.1 to 0.8 to keep within screen bounds mostly)
    double startX = 0.1 + _random.nextDouble() * 0.7;

    _activeWords.add(
      FloatingWord(
        text: wordText,
        x: startX,
        y: 1.1, // Start just below screen
        speed: 0.002 + _random.nextDouble() * 0.002, // Random speed
        isTarget: correctOptions.contains(wordText),
      ),
    );
  }

  void _handleTap(FloatingWord word) {
    if (word.color != null) return; // Already tapped

    setState(() {
      if (word.isTarget) {
        word.color = Colors.green;
        _addFeedback(word, "+2", Colors.green);
      } else {
        word.color = Colors.red;
        _addFeedback(word, "-1", Colors.red);
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
    return Scaffold(
      body: Stack(
        children: [
          // Background or other UI elements could go here

          // Header
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Touch the words related to:",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _targetCategory['word'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Words
          ..._activeWords.map((word) {
            return Positioned(
              left: MediaQuery.of(context).size.width * word.x,
              top: MediaQuery.of(context).size.height * word.y,
              child: GestureDetector(
                onTap: () => _handleTap(word),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: word.color ?? Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Text(
                    word.text,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: word.color != null ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),

          // Score Feedbacks
          ..._feedbacks.map((feedback) {
            final age = DateTime.now()
                .difference(feedback.creationTime)
                .inMilliseconds;
            final progress = age / 1000.0; // 0.0 to 1.0

            // Simple animation: Move up slightly and fade out
            final double currentY = feedback.y - (progress * 0.1);
            final double opacity = (1.0 - progress).clamp(0.0, 1.0);
            final double scale = 1.0 + (sin(progress * pi) * 0.5); // Pop effect

            return Positioned(
              left: MediaQuery.of(context).size.width * feedback.x,
              top: MediaQuery.of(context).size.height * currentY,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: feedback.color,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      feedback.text,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class FloatingWord {
  String text;
  double x; // 0.0 to 1.0
  double y; // 0.0 to 1.0 (starts > 1.0)
  double speed;
  bool isTarget;
  Color? color;

  FloatingWord({
    required this.text,
    required this.x,
    required this.y,
    required this.speed,
    required this.isTarget,
    this.color,
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
