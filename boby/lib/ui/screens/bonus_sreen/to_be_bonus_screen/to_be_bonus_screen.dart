import 'dart:async';
import 'dart:math';
import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/screens/bonus_sreen/to_be_bonus_screen/widgest/colored_button.dart';
import 'package:boby/ui/screens/bonus_sreen/to_be_bonus_screen/widgest/to_be_sentences.dart';
import 'package:boby/ui/shared/score.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Timer state
  Timer? _gameTimer;
  final Duration _gameDuration = const Duration(
    seconds: 15,
  ); // Bonus usually gives more time? or less? Matching MatchIt 7s seems low for sentences. Let's start with 20s or check MatchIt again. MatchIt had 7s.
  // User didn't specify duration, I'll use 20s for reading sentences.
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
    _startTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _elapsedTime += const Duration(milliseconds: 100);
      });

      if (_elapsedTime >= _gameDuration) {
        _gameTimer?.cancel();
        Get.back();
      }
    });
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

  TextSpan _buildSentence() {
    String sentence = currentQuestion['sentence'];
    String verb = currentQuestion['verb'];

    TextStyle defaultStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.5,
      color: Colors.black, // Explicit color for RichText
    );

    // If correct answer is selected, highlight the verb in green
    if (correctSelection != null) {
      int index = sentence.indexOf(verb);
      if (index == -1) return TextSpan(text: sentence, style: defaultStyle);

      String part1 = sentence.substring(0, index);
      String part2 = sentence.substring(index + verb.length);

      return TextSpan(
        style: defaultStyle,
        children: [
          TextSpan(text: part1),
          TextSpan(
            text: verb,
            style: const TextStyle(color: Colors.green),
          ),
          TextSpan(text: part2),
        ],
      );
    }

    // Replace the verb with "____"
    String textWithBlank = sentence.replaceFirst(verb, '____');
    return TextSpan(text: textWithBlank, style: defaultStyle);
  }

  void _onAnswerSelected(String answer) {
    StorageService storage = StorageService.instance;
    if (correctSelection != null) return; // Prevent interaction if already won

    String correctAnswer = currentQuestion['verb'];

    setState(() {
      if (answer == correctAnswer) {
        storage.incSoundCardsCorrect(); // Incrementa los puntos del score

        correctSelection = answer;

        // Wait 1 second before loading next question ONLY if correct
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _loadQuestion();
            });
          }
        });
      } else {
        wrongSelections.add(answer);
        storage.incSoundCardsWrong(); // Incrementa los puntos del score
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
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/oceano.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Score(game: "DragAndDrop"),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 60,
                ), // Added vertical margin to clear score/appbar
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Builder(
                    builder: (context) {
                      double progress =
                          1.0 -
                          (_elapsedTime.inMilliseconds /
                                  _gameDuration.inMilliseconds)
                              .clamp(0.0, 1.0);
                      Color barColor = Colors.blue;

                      return Container(
                        height: 20,
                        width:
                            (MediaQuery.of(context).size.width * 0.8) *
                            progress,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // Timer
          Padding(
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
                  child: Text.rich(
                    _buildSentence(),
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
        ],
      ),
    );
  }
}
