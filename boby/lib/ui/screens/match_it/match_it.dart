import 'package:boby/ui/screens/match_it/widgets/mach_it_word.dart.dart';
import 'package:boby/controllers/app_controller.dart';
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
  final void Function(String) onTap;
  final bool Function(String) isWrong;
  final bool Function(String) isCorrect;
  const _FigureOptionsGrid({required this.options, required this.onTap, required this.isWrong, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.5,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final label = options[index];
        final wrong = isWrong(label);
        return _GradientButton(
          onTap: () => onTap(label),
          isError: wrong,
          isCorrect: isCorrect(label),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.0,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
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
    ('Red', Colors.red),
    ('Green', Colors.green),
    ('Blue', Colors.blue),
    ('Yellow', Colors.yellow),
    ('Purple', Colors.purple),
    ('Orange', Colors.orange),
    ('Pink', Colors.pink),
    ('Brown', Colors.brown),
    ('Gray', Colors.grey),
    ('Black', Colors.black),
  ];

  final String soundPathIncorrectAnswer = "assets/sounds/bubble-pop.wav";
  final String soundPathCorrectAnswer = "assets/sounds/game-bonus.wav";

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
    // Randomly choose between shape/color, number, and figure rounds
    final choice = _rng.nextInt(3);
    _roundType = choice == 0 ? _RoundType.shape : choice == 1 ? _RoundType.number : _RoundType.figure;

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
    _targetShapePath = _shapes[_rng.nextInt(_shapes.length)];
    _targetColor = _colors[_rng.nextInt(_colors.length)];

    // Build 4 color options including the correct one
    final Set<int> usedIdx = { _colors.indexOf(_targetColor!) };
    final List<(String, Color)> opts = [ _targetColor! ];
    while (opts.length < 4) {
      final idx = _rng.nextInt(_colors.length);
      if (usedIdx.add(idx)) {
        opts.add(_colors[idx]);
      }
    }
    opts.shuffle(_rng);
    _colorOptions = opts;
    _targetNumber = null;
    _targetFigure = null;
    _wrongColorLabels.clear();
    _wrongNumberValues.clear();
    _wrongFigureLabels.clear();
  }

  void _generateNumberRound() {
    _targetNumber = _rng.nextInt(20) + 1; // 1..20
    final Set<int> opts = { _targetNumber! };
    while (opts.length < 4) {
      opts.add(_rng.nextInt(20) + 1);
    }
    _numberOptions = opts.toList()..shuffle(_rng);
    _targetShapePath = null;
    _targetColor = null;
    _targetFigure = null;
    _wrongColorLabels.clear();
    _wrongNumberValues.clear();
    _wrongFigureLabels.clear();
  }

  void _generateFigureRound() {
    // Build a pool from Constants.assets that have required keys
    final pool = Constants.assets;
    if (pool.isEmpty) {
      // fallback to shape round if no figures available
      _generateShapeRound();
      return;
    }
    _targetFigure = pool[_rng.nextInt(pool.length)];
    final targetName = _targetFigure!["name"]!;
    // Build 4 name options including the correct one
    final Set<int> usedIdx = {};
    final List<String> opts = [targetName];
    while (opts.length < 4 && usedIdx.length < pool.length) {
      final idx = _rng.nextInt(pool.length);
      // avoid picking the same name twice
      if (pool[idx]["name"] != null && pool[idx]["name"] != targetName) {
        final name = pool[idx]["name"]!;
        if (!opts.contains(name)) opts.add(name);
      }
      usedIdx.add(idx);
    }
    // In case of too few unique names, fill with duplicates (won't happen normally)
    while (opts.length < 4) {
      opts.add(targetName);
    }
    opts.shuffle(_rng);
    _figureOptions = opts;
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
      setState(() {
        _wrongColorLabels.add(picked.$1);
      });
    }
  }

  void _onNumberTap(int picked) {
    if (_isLocked) return;
    if (picked == _targetNumber) {
      _app.playMenuSound(soundPathCorrectAnswer);
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
      setState(() {
        _wrongNumberValues.add(picked);
      });
    }
  }

  void _onFigureTap(String picked) {
    if (_isLocked) return;
    if (_targetFigure != null && picked == _targetFigure!["name"]) {
      _app.playMenuSound(soundPathCorrectAnswer);
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
      setState(() {
        _wrongFigureLabels.add(picked);
      });
    }
  }

  // Removed letterPath: PNG letters no longer used for options

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const MatchItWord(),   
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_roundType == _RoundType.shape)
                        _ShapeTarget(
                          imagePath: _targetShapePath!,
                          color: _targetColor!.$2,
                        )
                      else if (_roundType == _RoundType.number)
                        _NumberTarget(number: _targetNumber!)
                      else
                        _FigureTarget(imagePath: _targetFigure!["image"]!),
                      if (_showCorrectOverlay)
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.green,
                          size: 120,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _roundType == _RoundType.shape
                  ? _ColorOptionsGrid(
                      options: _colorOptions,
                      onTap: _onColorTap,
                      isWrong: (label) => _wrongColorLabels.contains(label),
                      isCorrect: (label) => _targetColor != null && label == _targetColor!.$1 && _isLocked,
                    )
                  : _roundType == _RoundType.number
                      ? _NumberOptionsGrid(
                          options: _numberOptions,
                          onTap: _onNumberTap,
                          isWrong: (value) => _wrongNumberValues.contains(value),
                          isCorrect: (value) => _targetNumber != null && value == _targetNumber && _isLocked,
                        )
                      : _FigureOptionsGrid(
                          options: _figureOptions,
                          onTap: _onFigureTap,
                          isWrong: (label) => _wrongFigureLabels.contains(label),
                          isCorrect: (label) => _targetFigure != null && label == _targetFigure!["name"] && _isLocked,
                        ),
            ],
          ),
        );
  }
}

class _ShapeTarget extends StatelessWidget {
  final String imagePath;
  final Color color;
  const _ShapeTarget({required this.imagePath, required this.color});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: FittedBox(
        fit: BoxFit.contain,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }
}

class _NumberTarget extends StatelessWidget {
  final int number;
  const _NumberTarget({required this.number});

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    final width = screensize.width;
    final height = screensize.height;
    final minSize = min(width , height);

    final letterSize = minSize * 0.5;
    const numbersPath = 'assets/numbers/';
    final digits = number.toString().split('');
    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final d in digits)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Image.asset(
                '$numbersPath$d.png',
                height: letterSize,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }
}

class _ColorOptionsGrid extends StatelessWidget {
  final List<(String, Color)> options;
  final void Function((String, Color)) onTap;
  final bool Function(String) isWrong;
  final bool Function(String) isCorrect;
  const _ColorOptionsGrid({required this.options, required this.onTap, required this.isWrong, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.5,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final opt = options[index];
        final wrong = isWrong(opt.$1);
        return _ColorOptionButton(
          label: opt.$1,
          color: opt.$2,
          isError: wrong,
          isCorrect: isCorrect(opt.$1),
          onTap: () => onTap(opt),
        );
      },
    );
  }
}

class _ColorOptionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isError;
  final bool isCorrect;
  const _ColorOptionButton({required this.label, required this.color, required this.onTap, this.isError = false, this.isCorrect = false});

  @override
  Widget build(BuildContext context) {
    return _GradientButton(
      onTap: onTap,
      isError: isError,
      isCorrect: isCorrect,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.0,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _NumberOptionsGrid extends StatelessWidget {
  final List<int> options;
  final void Function(int) onTap;
  final bool Function(int) isWrong;
  final bool Function(int) isCorrect;
  const _NumberOptionsGrid({required this.options, required this.onTap, required this.isWrong, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    const List<String> wordsEn = [
      'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten',
      'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen', 'Twenty',
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.5,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final n = options[index];
        final label = n >= 1 && n <= 20 ? wordsEn[n - 1] : '$n';
        final wrong = isWrong(n);
        return _GradientButton(
          onTap: () => onTap(n),
          isError: wrong,
          isCorrect: isCorrect(n),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.0,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
    );
  }
}

class _GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isError;
  final bool isCorrect;
  const _GradientButton({required this.child, required this.onTap, this.isError = false, this.isCorrect = false});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    return Material(
      color: Colors.transparent,
      elevation: 6,
      shadowColor: Colors.black26,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isError
                  ? const [Color.fromARGB(255, 245, 159, 159), Color.fromARGB(255, 254, 131, 131)]
                  : isCorrect
                      ? const [Color.fromARGB(255, 76, 175, 80), Color.fromARGB(255, 56, 142, 60)]
                      : const [Color.fromARGB(255, 78, 72, 255), Color.fromARGB(255, 53, 97, 240)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: borderRadius,
            border: Border.all(
              color: isError
                  ? const Color(0xFFE57373)
                  : isCorrect
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF4527A0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Center(child: child),
        ),
      ),
    );
  }
}

// _WordPng removed: options now render direct Text labels