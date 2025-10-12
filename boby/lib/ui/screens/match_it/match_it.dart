import 'package:boby/ui/screens/match_it/widgets/mach_it_word.dart.dart';
import 'package:boby/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MatchItScreen extends StatefulWidget {
  const MatchItScreen({super.key});

  @override
  State<MatchItScreen> createState() => _MatchItScreenState();
}

enum _RoundType { shape, number }

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
  // Track wrong selections in current round
  final Set<String> _wrongColorLabels = {};
  final Set<int> _wrongNumberValues = {};

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
    // Randomly choose between shape/color and number rounds
    _roundType = _rng.nextBool() ? _RoundType.shape : _RoundType.number;

    if (_roundType == _RoundType.shape) {
      _generateShapeRound();
    } else {
      _generateNumberRound();
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
    _wrongColorLabels.clear();
    _wrongNumberValues.clear();
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
    _wrongColorLabels.clear();
    _wrongNumberValues.clear();
  }

  void _onColorTap((String, Color) picked) {
    if (picked == _targetColor) {
      _app.playMenuSound(soundPathCorrectAnswer);
      _nextRound();
    } else {
      _app.playMenuSound(soundPathIncorrectAnswer);
      setState(() {
        _wrongColorLabels.add(picked.$1);
      });
    }
  }

  void _onNumberTap(int picked) {
    if (picked == _targetNumber) {
      _app.playMenuSound(soundPathCorrectAnswer);
      _nextRound();
    } else {
      _app.playMenuSound(soundPathIncorrectAnswer);
      setState(() {
        _wrongNumberValues.add(picked);
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
                  child: _roundType == _RoundType.shape
                      ? _ShapeTarget(
                          imagePath: _targetShapePath!,
                          color: _targetColor!.$2,
                        )
                      : _NumberTarget(number: _targetNumber!),
                ),
              ),
              const SizedBox(height: 12),
              _roundType == _RoundType.shape
                  ? _ColorOptionsGrid(
                      options: _colorOptions,
                      onTap: _onColorTap,
                      isWrong: (label) => _wrongColorLabels.contains(label),
                    )
                  : _NumberOptionsGrid(
                      options: _numberOptions,
                      onTap: _onNumberTap,
                      isWrong: (value) => _wrongNumberValues.contains(value),
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
  const _ColorOptionsGrid({required this.options, required this.onTap, required this.isWrong});

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
  const _ColorOptionButton({required this.label, required this.color, required this.onTap, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return _GradientButton(
      onTap: onTap,
      isError: isError,
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
  const _NumberOptionsGrid({required this.options, required this.onTap, required this.isWrong});

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
  const _GradientButton({required this.child, required this.onTap, this.isError = false});

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
                  : const [Color.fromARGB(255, 78, 72, 255), Color.fromARGB(255, 53, 97, 240)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: borderRadius,
            border: Border.all(color: isError ? const Color(0xFFE57373) : const Color(0xFF4527A0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Center(child: child),
        ),
      ),
    );
  }
}

// _WordPng removed: options now render direct Text labels