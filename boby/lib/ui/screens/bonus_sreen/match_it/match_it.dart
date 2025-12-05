import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/screens/bonus_sreen/match_it/widgets/number_options_grid.dart';
import 'package:boby/ui/shared/score.dart';
import 'package:boby/ui/shared/word_of_images.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:boby/utils/constants.dart';

class MatchItScreen extends StatefulWidget {
  const MatchItScreen({super.key});

  @override
  State<MatchItScreen> createState() => _MatchItScreenState();
}

class _FigureTarget extends StatelessWidget {
  final String imagePath;
  const _FigureTarget({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: FittedBox(
        fit: BoxFit.contain,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}

class _FigureOptionsGrid extends StatelessWidget {
  final List<String> options;
  final List<Map<String, String>> assets;
  final void Function(String) onTap;
  final bool Function(String) isWrong;
  final bool Function(String) isCorrect;

  const _FigureOptionsGrid({
    required this.options,
    required this.assets,
    required this.onTap,
    required this.isWrong,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    bool istablet = screenSize.width > Constants.tabletSize;

    // Color choices with human-readable names
    final List<Color> colors = const [
      (Colors.blue),
      (Colors.yellow),
      (Colors.purple),
      (Colors.orange),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape || istablet ? 4 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1, // Make it square for images
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final label = options[index];
        final asset = assets.firstWhere(
          (a) => a['name'] == label,
          orElse: () => {'image': '', 'name': label},
        );
        final wrong = isWrong(label);
        final correct = isCorrect(label);

        return GestureDetector(
          onTap: () => onTap(label),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: wrong
                    ? Colors.red
                    : correct
                    ? Colors.green
                    : colors[index],
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  if (asset['image']?.isNotEmpty ?? false)
                    Image.asset(
                      asset['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildFallbackContent(label),
                    )
                  else
                    _buildFallbackContent(label),

                  // Overlay for wrong/correct state
                  if (wrong || correct)
                    Container(
                      color: (wrong ? Colors.red : Colors.green).withOpacity(
                        0.3,
                      ),
                      child: Center(
                        child: Icon(
                          wrong ? Icons.close : Icons.check,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackContent(String label) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

enum _RoundType { shape, number, figure }

class _MatchItScreenState extends State<MatchItScreen> {
  final _rng = Random();
  late AppController _app;

  // Shapes found under assets/shapes/
  final List<String> _shapes = const [
    'assets/shapes/shape_1.png',
    'assets/shapes/shape_3.png',
    'assets/shapes/shape_4.png',
    'assets/shapes/shape_5.png',
    'assets/shapes/shape_6.png',
  ];

  // Color choices with human-readable names
  final List<(String, Color)> _colors = const [
    ('Red', Color.fromARGB(255, 255, 23, 6)),
    ('Green', Colors.green),
    ('Blue', Colors.blue),
    ('Yellow', Colors.yellow),
    ('Purple', Colors.purple),
    ('Orange', Colors.orange),
    ('Pink', Color.fromARGB(255, 255, 120, 165)),
    ('Brown', Colors.brown),
    ('Gray', Colors.grey),
    ('Black', Colors.black),
  ];

  //number choices
  final List<Map<String, dynamic>> _numbers = [
    {"number": 1, "letter": "one"},
    {"number": 2, "letter": "two"},
    {"number": 3, "letter": "three"},
    {"number": 4, "letter": "four"},
    {"number": 5, "letter": "five"},
    {"number": 6, "letter": "six"},
    {"number": 7, "letter": "seven"},
    {"number": 8, "letter": "eight"},
    {"number": 9, "letter": "nine"},
    {"number": 10, "letter": "ten"},
    {"number": 11, "letter": "eleven"},
    {"number": 12, "letter": "twelve"},
    {"number": 13, "letter": "thirteen"},
    {"number": 14, "letter": "fourteen"},
    {"number": 15, "letter": "fifteen"},
    {"number": 16, "letter": "sixteen"},
    {"number": 17, "letter": "seventeen"},
    {"number": 18, "letter": "eighteen"},
    {"number": 19, "letter": "nineteen"},
    {"number": 20, "letter": "twenty"},
  ];

  final String soundPathIncorrectAnswer = "assets/sounds/bubble-pop.wav";
  final String soundPathCorrectAnswer = "assets/sounds/game-bonus.wav";

  final String numberPath = "assets/numbers/";

  // Current round state
  _RoundType _roundType = _RoundType.shape;
  // Shape round
  String? _targetShapePath;
  (String, Color)? _targetColor;
  late List<(String, Color)> _colorOptions;
  // Number round
  int? _targetNumber; // 1..20
  late List<int> _numberOptions;
  // Figure round (from Constants.assets)
  Map<String, String>? _targetFigure; // expects keys: image, name
  late List<String> _figureOptions; // list of 4 names
  // Track wrong selections in current round
  final Set<String> _wrongColorLabels = {};
  final Set<int> _wrongNumberValues = {};
  final Set<String> _wrongFigureLabels = {};

  // Store the complete figure data for display
  List<Map<String, String>> _figureAssets = [];
  // Feedback state
  bool _isLocked = false; // prevents taps during feedback
  bool _showCorrectOverlay = false; // show green check over the target

  @override
  void initState() {
    super.initState();
    // Resolve AppController for sounds
    if (Get.isRegistered<AppController>()) {
      _app = Get.find<AppController>();
    } else {
      _app = Get.put(AppController());
    }
    _nextRound();
  }

  void _nextRound() {
    // Pick next round type based on AppController flags
    final enabled = <_RoundType>[];
    if (_app.enableColors.value) enabled.add(_RoundType.shape);
    if (_app.enableNumbers.value) enabled.add(_RoundType.number);
    if (_app.enableObjects.value && Constants.assets.isNotEmpty)
      enabled.add(_RoundType.figure);

    // If nothing enabled, fallback to colors/shape
    if (enabled.isEmpty) {
      enabled.add(_RoundType.shape);
    }

    _roundType = enabled[_rng.nextInt(enabled.length)];

    if (_roundType == _RoundType.shape) {
      _generateShapeRound();
    } else if (_roundType == _RoundType.number) {
      _generateNumberRound();
    } else {
      _generateFigureRound();
    }
    setState(() {});
  }

  void _generateShapeRound() {
    // Select a random shape and color
    _targetShapePath = _shapes[_rng.nextInt(_shapes.length)];
    _targetColor = _colors[_rng.nextInt(_colors.length)];

    // Build 4 color options including the correct one
    final Set<int> usedIdx = {_colors.indexOf(_targetColor!)};
    final List<(String, Color)> opts = [_targetColor!];

    // Add 3 more distinct colors
    while (opts.length < 4) {
      final idx = _rng.nextInt(_colors.length);
      if (usedIdx.add(idx)) {
        opts.add(_colors[idx]);
      }
    }

    // Shuffle the options
    opts.shuffle(_rng);
    _colorOptions = opts;

    // Clear other states
    _targetNumber = null;
    _targetFigure = null;
    _wrongColorLabels.clear();
    _wrongNumberValues.clear();
    _wrongFigureLabels.clear();
    _targetNumber = null;
    _targetFigure = null;
    _wrongColorLabels.clear();
    _wrongNumberValues.clear();
    _wrongFigureLabels.clear();
  }

  void _generateNumberRound() {
    _targetNumber = _rng.nextInt(20) + 1; // 1..20
    final Set<int> opts = {_targetNumber!};

    // Generate 3 more distinct numbers
    while (opts.length < 4) {
      // Generate numbers within 10 of the target number, but at least 1 and at most 99
      int newNum;
      do {
        final offset = _rng.nextInt(10) + 1; // 1-10
        if (_rng.nextBool()) {
          newNum = (_targetNumber! + offset).clamp(1, 99);
        } else {
          newNum = (_targetNumber! - offset).clamp(1, 99);
        }
      } while (opts.contains(newNum));

      opts.add(newNum);
    }

    _numberOptions = opts.toList()..shuffle(_rng);
    _targetShapePath = null;
    _targetColor = null;
    _targetFigure = null;
    _wrongColorLabels.clear();
    _wrongNumberValues.clear();
    _wrongFigureLabels.clear();

    //change de target number to the target number in letter
  }

  void _generateFigureRound() {
    // Build a pool from Constants.assets that have required keys
    final pool = List<Map<String, String>>.from(Constants.assets);
    if (pool.isEmpty) {
      // fallback to shape round if no figures available
      _generateShapeRound();
      return;
    }

    // Select a random target figure
    _targetFigure = pool[_rng.nextInt(pool.length)];

    // Build 4 figure options including the correct one
    final Set<int> usedIndices = {pool.indexOf(_targetFigure!)};
    final List<Map<String, String>> opts = [_targetFigure!];

    while (opts.length < 4 && usedIndices.length < pool.length) {
      final idx = _rng.nextInt(pool.length);
      if (usedIndices.add(idx)) {
        opts.add(pool[idx]);
      }
    }
    // In case of too few unique figures, fill with random ones (shouldn't happen with Constants.assets)
    while (opts.length < 4) {
      final idx = _rng.nextInt(pool.length);
      if (!opts.any((fig) => fig['name'] == pool[idx]['name'])) {
        opts.add(pool[idx]);
      }
    }

    // Shuffle the options
    opts.shuffle(_rng);
    _figureOptions = opts.map((fig) => fig['name']!).toList();
    _figureAssets = opts;
    _targetShapePath = null;
    _targetColor = null;
    _targetNumber = null;
    _wrongColorLabels.clear();
    _wrongNumberValues.clear();
    _wrongFigureLabels.clear();
  }

  void _onColorTap((String, Color) picked) {
    if (_isLocked) return;
    if (picked == _targetColor) {
      _app.playMenuSound(soundPathCorrectAnswer);
      StorageService.instance.incMatchItCorrect();
      setState(() {
        _isLocked = true;
        _showCorrectOverlay = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        _isLocked = false;
        _showCorrectOverlay = false;
        _nextRound();
      });
    } else {
      _app.playMenuSound(soundPathIncorrectAnswer);
      StorageService.instance.incMatchItWrong();
      setState(() {
        _wrongColorLabels.add(picked.$1);
      });
    }
  }

  void _onNumberTap(int picked) {
    if (_isLocked) return;
    if (picked == _targetNumber) {
      _app.playMenuSound(soundPathCorrectAnswer);
      StorageService.instance.incMatchItCorrect();
      setState(() {
        _isLocked = true;
        _showCorrectOverlay = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        _isLocked = false;
        _showCorrectOverlay = false;
        _nextRound();
      });
    } else {
      _app.playMenuSound(soundPathIncorrectAnswer);
      StorageService.instance.incMatchItWrong();
      setState(() {
        _wrongNumberValues.add(picked);
      });
    }
  }

  void _onFigureTap(String picked) {
    if (_isLocked) return;
    if (_targetFigure != null && picked == _targetFigure!["name"]) {
      _app.playMenuSound(soundPathCorrectAnswer);
      StorageService.instance.incMatchItCorrect();
      setState(() {
        _isLocked = true;
        _showCorrectOverlay = true;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        _isLocked = false;
        _showCorrectOverlay = false;
        _nextRound();
      });
    } else {
      _app.playMenuSound(soundPathIncorrectAnswer);
      StorageService.instance.incMatchItWrong();
      setState(() {
        _wrongFigureLabels.add(picked);
      });
    }
  }

  // Removed letterPath: PNG letters no longer used for options

  // Helper method to get the current target word
  String get _currentTargetWord {
    if (_roundType == _RoundType.shape) {
      return _targetColor?.$1 ?? '';
    } else if (_roundType == _RoundType.number) {
      return _numbers.firstWhere((n) => n['number'] == _targetNumber)['letter'];
    } else {
      return _targetFigure?['name'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    bool istablet = screenSize.width > Constants.tabletSize;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Score(game: "MatchIt"),

          Spacer(),

          WordOfImages(
            letters: _currentTargetWord.toUpperCase(),
            letterSize: isLandscape || istablet ? 90 : 40,
          ),
          Spacer(),

          // Main content area (now empty since we show the word at the top)
          const Spacer(),

          // Show the options at the bottom
          if (_roundType == _RoundType.shape) ...[
            _ColorOptionsGrid(
              options: _colorOptions,
              shapes: _shapes,
              onTap: _onColorTap,
              isWrong: (label) => _wrongColorLabels.contains(label),
              isCorrect: (label) =>
                  _targetColor != null &&
                  label == _targetColor!.$1 &&
                  _isLocked,
            ),
          ] else if (_roundType == _RoundType.number) ...[
            NumberOptionsGrid(
              options: _numberOptions,
              onTap: _onNumberTap,
              isWrong: (value) => _wrongNumberValues.contains(value),
              isCorrect: (value) =>
                  _targetNumber != null && value == _targetNumber && _isLocked,
            ),
          ] else ...[
            _FigureOptionsGrid(
              options: _figureOptions,
              assets: _figureAssets,
              onTap: _onFigureTap,
              isWrong: (label) => _wrongFigureLabels.contains(label),
              isCorrect: (label) =>
                  _targetFigure != null &&
                  label == _targetFigure!["name"] &&
                  _isLocked,
            ),
          ],
          Spacer(),
          // Options are now shown above in the main content area
        ],
      ),
    );
  }
}

class _ColorOptionsGrid extends StatelessWidget {
  final List<(String, Color)> options;
  final List<String> shapes;
  final void Function((String, Color)) onTap;
  final bool Function(String) isWrong;
  final bool Function(String) isCorrect;

  const _ColorOptionsGrid({
    required this.options,
    required this.shapes,
    required this.onTap,
    required this.isWrong,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    bool istablet = screenSize.width > Constants.tabletSize;

    // Use the first shape for all color options
    final shapePath = shapes.isNotEmpty
        ? shapes[0]
        : 'assets/shapes/shape_1.png';

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape || istablet ? 4 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1, // Square aspect ratio for shapes
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        if (index >= options.length) return const SizedBox.shrink();

        final opt = options[index];
        final wrong = isWrong(opt.$1);
        final correct = isCorrect(opt.$1);

        return GestureDetector(
          onTap: () => onTap(opt),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: wrong
                    ? Colors.red
                    : correct
                    ? Colors.green
                    : Colors.transparent,
                width: 4,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Colored shape - same shape for all options
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(opt.$2, BlendMode.srcIn),
                    child: Image.asset(
                      shapePath,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  // Overlay for wrong/correct state
                  if (wrong || correct)
                    Container(
                      color: (wrong ? Colors.red : Colors.green).withOpacity(
                        0.3,
                      ),
                      child: Center(
                        child: Icon(
                          wrong ? Icons.close : Icons.check,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
// Removed _ColorOptionButton as it's no longer needed

// _WordPng removed: options now render direct Text labels
