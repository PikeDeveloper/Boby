import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:boby/controllers/app_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    _a = _rnd.nextInt(21); // 0..20
    _b = _rnd.nextInt(21); // 0..20
    _answer = _a + _b; // 0..40
    final Set<int> opts = {_answer};
    while (opts.length < 4) {
      final cand = _rnd.nextInt(41); // 0..40
      opts.add(cand);
    }
    _options = opts.toList()..shuffle(_rnd);
    _correctSelected = null;
    _wrongSelecteds.clear();
    setState(() {});
  }

  void _onSelect(BuildContext context, int value) {
    if (_correctSelected != null) return; // ya contestado correctamente
    final appController = Get.find<AppController>();
    if (value == _answer) {
      appController.playMenuSound(soundPathCorrectAnswer);
      setState(() {
        _correctSelected = value;
      });
      Future.delayed(const Duration(milliseconds: 900), _generate);
    } else {
      appController.playMenuSound(soundPathIncorrectAnswer);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildSumRow(),
                    if (_correctSelected != null)
                      const Positioned(
                        right: -8,
                        top: -8,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 100),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double buttonSize = (constraints.maxWidth - 48) / 2; // 2 columnas, 16px gaps
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
                                          ? Colors.red
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
        const Text(
          '+',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
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