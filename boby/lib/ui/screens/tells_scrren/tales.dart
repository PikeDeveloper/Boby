import 'dart:math';

import 'package:boby/ui/screens/tells_scrren/widgets/image_tale.dart';
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
  String? _selectedAnswer; // Track the user's choice
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
      _selectedAnswer = null; // Reset selection
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (_answered) return; // Ignore if already answered logic handling

    bool isCorrect = selectedAnswer == _correctAnswer;

    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
      _selectedAnswer = selectedAnswer;
    });

    if (isCorrect) {
      // Play sound? (Optional future step)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _currentTaleIndex++;
          });
          _loadTale();
        }
      });
    } else {
      // Allow retrying checking logic?
      // Requirement: "si acierta se pasa" -> implies if wrong, perhaps stay?
      // Existing logic implies we just show "Try again" and maybe let them click again?
      // But if we set _answered = true, buttons are disabled in my previous code.
      // Let's change behavior: if wrong, reset _answered after a short delay so they can try again,
      // OR just show the error on the clicked button and let them click another.

      // Better UX for kids: If wrong, shake/red, then let them try again.
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _answered = false; // Allow trying again
            _selectedAnswer =
                null; // Reset selection so buttons go back to normal
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taleData = Tales.tales[_currentTaleIndex];

    return Scaffold(
      // Gradient background for a fun look
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFE1F5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Story Text Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          children: [
                            // Image Card
                            if (taleData['image'] != null)
                              ImageTale(image: taleData['image']!),
                            Text(
                              taleData['tale'] ?? '',
                              style: GoogleFonts.comicNeue(
                                fontSize: 22,
                                height: 1.4,
                                color: const Color(0xFF424242),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Question Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1), // Light amber
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFFFECB3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.help_outline_rounded,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    taleData['question'] ?? 'Question',
                                    style: GoogleFonts.comicNeue(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ..._currentAnswers.map((answer) {
                              bool isSelected = answer == _selectedAnswer;
                              bool isCorrectAnswer = answer == _correctAnswer;

                              // Check visual state
                              Color bgColor = Colors.white;
                              Color textColor = Colors.blueGrey;
                              Color borderColor = Colors.transparent;

                              if (_answered) {
                                if (isSelected) {
                                  if (isCorrectAnswer) {
                                    bgColor = Colors.green.shade100;
                                    textColor = Colors.green.shade800;
                                    borderColor = Colors.green;
                                  } else {
                                    bgColor = Colors.red.shade100;
                                    textColor = Colors.red.shade800;
                                    borderColor = Colors.red;
                                  }
                                } else if (isCorrectAnswer && _isCorrect) {
                                  // Optional: Show correct answer if user got it right?
                                  // Or just leave as is. User clicked correct, so it's handled above.
                                }
                              } else {
                                // Default state
                                bgColor = Colors.white;
                                textColor = const Color(0xFF5D4037);
                                borderColor = Colors.transparent;
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: bgColor,
                                      foregroundColor: textColor,
                                      elevation: isSelected ? 2 : 4,
                                      shadowColor: Colors.black12,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: borderColor,
                                          width: isSelected ? 2 : 0,
                                        ),
                                      ),
                                    ),
                                    onPressed: _answered
                                        ? null // Block interaction while processing
                                        : () => _checkAnswer(answer),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            answer,
                                            style: GoogleFonts.comicNeue(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (_answered && isSelected)
                                          Icon(
                                            isCorrectAnswer
                                                ? Icons.check_circle_rounded
                                                : Icons.cancel_rounded,
                                            color: textColor,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
