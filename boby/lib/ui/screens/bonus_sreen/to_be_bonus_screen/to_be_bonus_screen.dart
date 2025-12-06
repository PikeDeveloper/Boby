import 'dart:math';
import 'package:boby/ui/screens/bonus_sreen/to_be_bonus_screen/widgest/colored_button.dart';
import 'package:boby/ui/screens/bonus_sreen/to_be_bonus_screen/widgest/to_be_sentences.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';

class ToBeBonusScreen extends StatefulWidget {
  static const String routeName = '/to-be-bonus-screen';
  ToBeBonusScreen({super.key});

  final List<Color> colors = [
    MyColors.purple,
    MyColors.blue,
    MyColors.darkBlue,
    MyColors.yellow,
  ];

  @override
  State<ToBeBonusScreen> createState() => _ToBeBonusScreenState();
}

class _ToBeBonusScreenState extends State<ToBeBonusScreen> {
  final List toBeSentences = ToBeSentences.sentences;
  late int currentQuestionIndex;
  late Map currentQuestion;
  late List<String> options;
  String? correctSelection;
  final Set<String> wrongSelections = {};
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() {
    // Select a random question
    currentQuestionIndex = random.nextInt(toBeSentences.length);
    currentQuestion = toBeSentences[currentQuestionIndex];

    // Get the correct answer and wrong answers
    String correctAnswer = currentQuestion['verb'];
    List<String> wrongAnswers = List<String>.from(currentQuestion['wrong']);

    // Take only 3 wrong answers
    wrongAnswers.shuffle();
    List<String> selectedWrong = wrongAnswers.take(3).toList();

    // Combine and shuffle all options
    options = [correctAnswer, ...selectedWrong];
    options.shuffle();

    correctSelection = null;
    wrongSelections.clear();
  }

  String _getSentenceWithBlank() {
    String sentence = currentQuestion['sentence'];
    String verb = currentQuestion['verb'];

    // Replace the verb with "____"
    return sentence.replaceFirst(verb, '____');
  }

  void _onAnswerSelected(String answer) {
    if (correctSelection != null) return; // Prevent interaction if already won

    String correctAnswer = currentQuestion['verb'];

    setState(() {
      if (answer == correctAnswer) {
        correctSelection = answer;

        // Wait 0.5 seconds before loading next question ONLY if correct
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _loadQuestion();
            });
          }
        });
      } else {
        wrongSelections.add(answer);
      }
    });
  }

  Color _getOptionColor(String option, int index) {
    if (option == correctSelection) {
      return Colors.green;
    }
    if (wrongSelections.contains(option)) {
      return Colors.red;
    }
    return widget.colors[index % widget.colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Be Quiz'),
        backgroundColor: Colors.purple.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sentence with blank
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade200, width: 2),
              ),
              child: Text(
                _getSentenceWithBlank(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            // Answer options
            ...options.asMap().entries.map((entry) {
              final int index = entry.key;
              final String option = entry.value;
              final String letter = String.fromCharCode(
                65 + index,
              ); // A, B, C, D

              bool isSelected =
                  option == correctSelection ||
                  wrongSelections.contains(option);
              bool isCorrect = option == currentQuestion['verb'];

              return ToBeOptionButton(
                letter: letter,
                text: option,
                color: _getOptionColor(option, index),
                onTap:
                    (correctSelection != null ||
                        wrongSelections.contains(option))
                    ? () {}
                    : () => _onAnswerSelected(option),
                isSelected: isSelected,
                isCorrect: isCorrect,
                showResult:
                    isSelected, // Show result icon if selected (either correct or wrong)
              );
            }),
          ],
        ),
      ),
    );
  }
}
