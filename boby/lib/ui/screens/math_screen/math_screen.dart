
import 'package:boby/ui/shared/score.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';

class MathScreen extends StatefulWidget {
  const MathScreen({super.key});

  @override
  State<MathScreen> createState() => _MathScreenState();
}

class _MathScreenState extends State<MathScreen> {
  final Random _rnd = Random();
  late int _a;
  late int _b;
  late int _answer;
  late List<int> _options;
  int? _correctSelected;
  final Set<int> _wrongSelecteds = {};
  String _opChar = '+';

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    // Leer opciones de Hive
    final addOn = StorageService.instance.getMathOpAdd();
    final subOn = StorageService.instance.getMathOpSub();
    final mulOn = StorageService.instance.getMathOpMul();
    final divOn = StorageService.instance.getMathOpDiv();

    final enabled = <String>[];
    if (addOn) enabled.add('+');
    if (subOn) enabled.add('-');
    if (mulOn) enabled.add('x');
    if (divOn) enabled.add('/');
    if (enabled.isEmpty) enabled.add('+');

    _opChar = enabled[_rnd.nextInt(enabled.length)];

    int maxResult = 40; // default similar to suma
    switch (_opChar) {
      case '+':
        _a = _rnd.nextInt(21); // 0..20
        _b = _rnd.nextInt(21); // 0..20
        _answer = _a + _b; // 0..40
        maxResult = 40;
        break;
      case '-':
        _a = _rnd.nextInt(21); // 0..20
        _b = _rnd.nextInt(_a + 1); // 0..a to avoid negative
        _answer = _a - _b; // 0..20
        maxResult = 20;
        break;
      case 'x':
        _a = _rnd.nextInt(11); // 0..10
        _b = _rnd.nextInt(11); // 0..10
        _answer = _a * _b; // 0..100
        maxResult = 100;
        break;
      case '/':
        // integer division a / b = q
        final divisor = max(1, _rnd.nextInt(10)); // 1..9
        final quotient = _rnd.nextInt(11); // 0..10
        _a = divisor * quotient;
        _b = divisor;
        _answer = quotient;
        maxResult = 10;
        break;
    }

    // Generar opciones
    final Set<int> opts = {_answer};
    while (opts.length < 4) {
      int cand;
      // valores cercanos al resultado para mayor reto
      final delta = (_opChar == 'x') ? 10 : 5;
      final minRange = max(0, _answer - delta);
      final maxRange = min(maxResult, _answer + delta);
      if (minRange < maxRange) {
        cand = minRange + _rnd.nextInt(maxRange - minRange + 1);
      } else {
        cand = _rnd.nextInt(maxResult + 1);
      }
      opts.add(cand);
    }
    _options = opts.toList()..shuffle(_rnd);
    _correctSelected = null;
    _wrongSelecteds.clear();
    setState(() {});
  }

  Future<void> _onSelect(BuildContext context, int value) async {
    if (_correctSelected != null) return; // ya contestado correctamente
    final appController = Get.find<AppController>();
    if (value == _answer) {
      appController.playMenuSound(soundPathCorrectAnswer);
      await StorageService.instance.incMathCorrect();
      setState(() {
        _correctSelected = value;
      });
      Future.delayed(const Duration(milliseconds: 900), _generate);
    } else {
      appController.playMenuSound(soundPathIncorrectAnswer);
      await StorageService.instance.incMathWrong();
      setState(() {
        _wrongSelecteds.add(value);
      });
    }
  }

  String soundPathCorrectAnswer = "assets/sounds/game-bonus.wav";
  String soundPathIncorrectAnswer = "assets/sounds/bubble-pop.wav";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildSumRow(),
                      if (_correctSelected != null)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 60,
                        ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double buttonSize = (constraints.maxWidth - 48) /
                          2; // 2 columnas, 16px gaps
                      return Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: _options
                            .map(
                              (opt) => SizedBox(
                                width: buttonSize,
                                height: 100,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _correctSelected == opt
                                        ? Colors.green
                                        : (_wrongSelecteds.contains(opt)
                                            ? const Color.fromARGB(
                                                113, 244, 67, 54)
                                            : null),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: _correctSelected != null
                                      ? null
                                      : () => _onSelect(context, opt),
                                  child: _buildDigitImages(opt, 36),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
              Score(
                correct: StorageService.instance.getMathCorrect(),
                wrong: StorageService.instance.getMathWrong(),
                onTap: (context) => StorageService.instance.setMathCorrect(0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSumRow() {
    const double imgH = 64;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildDigitImages(_a, imgH),
        const SizedBox(width: 8),
        Text(
          _opChar,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        _buildDigitImages(_b, imgH),
        const SizedBox(width: 8),
        const Text(
          '=',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        const Text(
          '?',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDigitImages(int value, double height) {
    final chars = value.toString().split('');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final ch in chars)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Image.asset(
              'assets/numbers/$ch.png',
              height: height,
              fit: BoxFit.contain,
            ),
          ),
      ],
    );
  }
}
