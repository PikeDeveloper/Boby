import 'dart:async';
import 'dart:math';
import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/screens/bonus_sreen/complete_sentence/widgets/colored_button.dart';
import 'package:boby/ui/screens/bonus_sreen/complete_sentence/widgets/sentense_container.dart';
import 'package:boby/ui/shared/score.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boby/ui/shared/word_of_images.dart';
import 'widgets/sentences.dart';

class CompleteSentence extends StatefulWidget {
  static const String route = '/complete_sentence';
  const CompleteSentence({super.key});

  @override
  State<CompleteSentence> createState() => _CompleteSentenceState();
}

class _CompleteSentenceState extends State<CompleteSentence> {
  final StorageService storage = Get.find<StorageService>();
  final AppController appController = Get.find<AppController>();
  late int currentQuestionIndex;
  bool showCorrect = false;
  List<int> usedQuestionIndices = [];
  Set<int> selectedAnswerIndices = {};

  int? selectedAnswerIndex;
  bool isCorrect = false;
  int?
  correctAnswerIndex; // Track the index of the correct answer after shuffling
  List<String> shuffledAnswers =
      []; // Store shuffled answers for current question

  Timer? _timer;
  final Duration _gameDuration = const Duration(seconds: 10);
  Duration _elapsedTime = Duration.zero;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _elapsedTime += const Duration(milliseconds: 100);
        if (_elapsedTime >= _gameDuration) {
          _timer?.cancel();
          final appController = Get.find<AppController>();
          appController.bonusScreen.value = 7;
          Get.back();
        }
      });
    });
  }

  void checkAnswer(int answerIndex) {
    final isCorrectAnswer = answerIndex == correctAnswerIndex;

    // Play appropriate sound
    if (isCorrectAnswer) {
      appController.playGameBonus();
    } else {
      appController.playBubblePop();
    }

    setState(() {
      if (!isCorrectAnswer) {
        selectedAnswerIndices.add(answerIndex);
      } else {
        // Clear all selections when correct answer is chosen
        selectedAnswerIndices.clear();
      }
      selectedAnswerIndex = answerIndex;
      showCorrect = true;
      isCorrect = isCorrectAnswer;

      // Update scores
      if (isCorrectAnswer) {
        if (!appController.isTrainingMode.value) {
          storage.incScoreCorrect(appController.gameSelected.value);
        }
      } else {
        if (!appController.isTrainingMode.value) {
          storage.incScoreWrong(appController.gameSelected.value);
        }
      }
    });

    if (isCorrectAnswer) {
      // Move to next question after a delay if answer is correct
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            int numberOfSentences = Sentences.sentences.length;

            if (usedQuestionIndices.length == numberOfSentences) {
              usedQuestionIndices.clear();
            }
            showCorrect = false;
            selectedAnswerIndex = null;
            selectedAnswerIndices.clear();
            //choose a random question y no se puede repetir si ya su indice esta en usedQuestionIndices

            while (usedQuestionIndices.contains(currentQuestionIndex)) {
              currentQuestionIndex = Random().nextInt(numberOfSentences);
            }
            usedQuestionIndices.add(currentQuestionIndex);
            _shuffleAnswers(); // Shuffle answers for the new question
          });
        }
      });
    }
  }

  void _shuffleAnswers() {
    final currentQuestion = Sentences.sentences[currentQuestionIndex];
    final List<String> answers = List<String>.from(
      currentQuestion['answers'] as List,
    );

    // Shuffle answers and track correct answer position
    shuffledAnswers = List.from(answers);
    shuffledAnswers.shuffle();
    correctAnswerIndex = shuffledAnswers.indexOf(
      answers[0],
    ); // Original correct answer
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Initialize scores
    storage.setTalesCorrect(storage.getTalesCorrect());
    storage.setTalesWrong(storage.getTalesWrong());

    int numberOfSentences = Sentences.sentences.length;
    currentQuestionIndex = Random().nextInt(numberOfSentences);
    usedQuestionIndices.add(currentQuestionIndex);
    // Shuffle answers for the first question
    _shuffleAnswers();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = Sentences.sentences[currentQuestionIndex];
    final String sentence = currentQuestion['sentence'] as String;
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    List<Color> colors = [
      MyColors.purple,
      MyColors.blue,
      MyColors.darkBlue,
      MyColors.yellow,
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: WordOfImages(letters: 'BONUS', letterSize: 30),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/backgrounds/oceano.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header with Score
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Score(game: appController.gameSelected.value),
                ),

                //barra progresiva aqui
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 20,
                      width:
                          (MediaQuery.of(context).size.width * 0.8) *
                          (1.0 -
                              (_elapsedTime.inMilliseconds /
                                      _gameDuration.inMilliseconds)
                                  .clamp(0.0, 1.0)),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Expanded(
                  child: SizedBox(
                    width: min(screenWidth * 0.9, 600),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Question Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.orange.shade200,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Complete the sentence:",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              SentenceContainer(sentence: sentence),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Answer Options
                        Expanded(
                          child: ListView.separated(
                            itemCount: shuffledAnswers.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              bool isSelected =
                                  selectedAnswerIndex == index ||
                                  selectedAnswerIndices.contains(index);
                              bool isCorrectAnswer =
                                  index == correctAnswerIndex;

                              return AnimatedScale(
                                scale: isSelected ? 1.02 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: OptionButton(
                                  letter: String.fromCharCode(65 + index),
                                  text: shuffledAnswers[index],
                                  color: isCorrectAnswer && isSelected
                                      ? Colors.green
                                      : (isSelected && !isCorrectAnswer
                                            ? Colors.red
                                            : colors[index % colors.length]),
                                  onTap: () => checkAnswer(index),
                                  isSelected: isSelected,
                                  isCorrect: isCorrectAnswer,
                                  showResult: showCorrect,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
