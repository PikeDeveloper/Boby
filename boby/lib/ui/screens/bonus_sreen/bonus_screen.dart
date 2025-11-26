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
        speed: 0.005 + _random.nextDouble() * 0.005, // Random speed
        isTarget: correctOptions.contains(wordText),
      ),
    );
  }

  void _handleTap(FloatingWord word) {
    if (word.color != null) return; // Already tapped

    setState(() {
      if (word.isTarget) {
        word.color = Colors.green;
      } else {
        word.color = Colors.red;
      }
    });
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
