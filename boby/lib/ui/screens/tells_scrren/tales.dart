import 'dart:math';

import 'package:boby/ui/screens/tells_scrren/widgets/tales.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TalesScreen extends StatefulWidget {
  static const String routeName = '/tales';
  const TalesScreen({super.key});

  @override
  State<TalesScreen> createState() => _TalesScreenState();
}

class _TalesScreenState extends State<TalesScreen> {
  int _currentTaleIndex = 0;
  List<String> _currentAnswers = [];
  String? _correctAnswer;
  bool _answered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadTale();
  }

  void _loadTale() {
    if (_currentTaleIndex >= Tales.tales.length) {
      // Game Over or Restart
      setState(() {
        _currentTaleIndex = 0;
      });
    }

    final taleData = Tales.tales[_currentTaleIndex];
    final allAnswers = (taleData['answers'] ?? '')
        .split(',')
        .map((e) => e.trim())
        .toList();

    if (allAnswers.isNotEmpty) {
      _correctAnswer = allAnswers[0];
      _currentAnswers = List.from(allAnswers);
      _currentAnswers.shuffle(Random());
    } else {
      _correctAnswer = '';
      _currentAnswers = [];
    }

    setState(() {
      _answered = false;
      _isCorrect = false;
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (_answered && _isCorrect) return; // Already passed

    setState(() {
      _answered = true;
      _isCorrect = selectedAnswer == _correctAnswer;
    });

    if (_isCorrect) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _currentTaleIndex++;
          });
          _loadTale();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentTaleIndex >= Tales.tales.length) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "All stories completed!",
                style: GoogleFonts.comicNeue(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentTaleIndex = 0;
                    _loadTale();
                  });
                },
                child: const Text("Read Again"),
              ),
            ],
          ),
        ),
      );
    }

    final taleData = Tales.tales[_currentTaleIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Tale ${_currentTaleIndex + 1}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (taleData['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  taleData['image']!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              taleData['tale'] ?? '',
              style: GoogleFonts.comicNeue(fontSize: 24, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber),
              ),
              child: Column(
                children: [
                  Text(
                    taleData['question'] ?? 'Question',
                    style: GoogleFonts.comicNeue(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ..._currentAnswers.map((answer) {
                    Color btnColor = Colors.blue.shade50;
                    Color txtColor = Colors.blue.shade900;

                    if (_answered) {
                      if (answer == _correctAnswer) {
                        btnColor = Colors.green.shade100;
                        txtColor = Colors.green.shade900;
                      } else {
                        // If we want to show red for wrong selection, we need to track selected answer.
                        // For now, let's just highlight the correct one if they guessed.
                        // Actually, requirement says "si acierta se pasa".
                        // It implies if they miss, they stay.
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _answered && _isCorrect
                              ? null
                              : () => _checkAnswer(answer),
                          child: Text(
                            answer,
                            style: GoogleFonts.comicNeue(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: txtColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            if (_answered && !_isCorrect)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Try again!",
                  style: GoogleFonts.comicNeue(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            if (_answered && _isCorrect)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Correct! Next story coming...",
                  style: GoogleFonts.comicNeue(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
