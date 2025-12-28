import 'dart:async';
import 'dart:math';
import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/shared/score.dart';
import 'package:boby/ui/shared/word_of_images.dart';
import 'package:boby/utils/colors.dart';
import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrueOrFalseBonusScreen extends StatefulWidget {
  static const String routeName = '/true-or-false-bonus-screen';
  const TrueOrFalseBonusScreen({super.key});

  @override
  State<TrueOrFalseBonusScreen> createState() => _TrueOrFalseBonusScreenState();
}

class _TrueOrFalseBonusScreenState extends State<TrueOrFalseBonusScreen> {
  final Random random = Random();
  late Map<String, String> currentItem;
  late String displayedName;
  late bool isCorrectName;
  bool? selectedAnswer;

  // PageView controller for swipe transitions
  late PageController _pageController;
  late Map<String, String> nextItem;
  late String nextDisplayedName;
  late bool nextIsCorrectName;

  // Sound paths
  final String soundPathIncorrectAnswer = "assets/sounds/bubble-pop.wav";
  final String soundPathCorrectAnswer = "assets/sounds/game-bonus.wav";

  // Timer state
  Timer? _gameTimer;
  final Duration _gameDuration = const Duration(seconds: 15);
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadQuestion();
    _loadNextQuestion();
    _startTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _pageController.dispose();
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
        final appController = Get.find<AppController>();
        appController.bonusScreen.value = 7;
        Get.back();
      }
    });
  }

  void _loadQuestion() {
    // Select a random item from assetsExtras
    currentItem =
        Constants.assetsExtras[random.nextInt(Constants.assetsExtras.length)];

    // Randomly decide if we show the correct name or a wrong one
    isCorrectName = random.nextBool();

    if (isCorrectName) {
      displayedName = currentItem['name']!;
    } else {
      // Get a different random item's name
      Map<String, String> wrongItem;
      do {
        wrongItem = Constants
            .assetsExtras[random.nextInt(Constants.assetsExtras.length)];
      } while (wrongItem['name'] == currentItem['name']);
      displayedName = wrongItem['name']!;
    }

    selectedAnswer = null;
  }

  void _loadNextQuestion() {
    List totalItems = [];
    totalItems.addAll(Constants.assetsExtras);
    totalItems.addAll(Constants.assets);
    // Select a random item from assetsExtras for next question
    nextItem = totalItems[random.nextInt(totalItems.length)];

    // Randomly decide if we show the correct name or a wrong one
    nextIsCorrectName = random.nextBool();

    if (nextIsCorrectName) {
      nextDisplayedName = nextItem['name']!;
    } else {
      // Get a different random item's name
      Map<String, String> wrongItem;
      do {
        wrongItem = totalItems[random.nextInt(totalItems.length)];
      } while (wrongItem['name'] == nextItem['name']);
      nextDisplayedName = wrongItem['name']!;
    }
  }

  void _onAnswerSelected(bool answer) {
    if (selectedAnswer != null) return; // Prevent multiple selections

    final appController = Get.find<AppController>();
    StorageService storage = StorageService.instance;

    setState(() {
      selectedAnswer = answer;

      bool isCorrect =
          (answer == true && isCorrectName) ||
          (answer == false && !isCorrectName);

      if (isCorrect) {
        // Play correct answer sound
        appController.playMenuSound(soundPathCorrectAnswer);

        if (!appController.isTrainingMode.value) {
          storage.incScoreCorrect(appController.gameSelected.value);
        }

        // Wait 1 second before loading next question
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            // Advance to next page in PageView
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      } else {
        // Play incorrect answer sound
        appController.playMenuSound(soundPathIncorrectAnswer);

        if (!appController.isTrainingMode.value) {
          storage.incScoreWrong(appController.gameSelected.value);
        }

        // Wait 1 second before loading next question (same as correct answer)
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            // Advance to next page in PageView
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  Color _getButtonColor(bool buttonValue) {
    if (selectedAnswer == null) {
      return buttonValue ? MyColors.green : MyColors.red;
    }

    bool isCorrect =
        (selectedAnswer == true && isCorrectName) ||
        (selectedAnswer == false && !isCorrectName);

    if (selectedAnswer == buttonValue) {
      return isCorrect ? Colors.green : Colors.red;
    }

    return buttonValue ? MyColors.green : MyColors.red;
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: WordOfImages(letters: 'BONUS', letterSize: 30)),
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
              Score(game: appController.gameSelected.value),

              // Timer bar
              Container(
                height: 20,
                width: screenWidth * 0.8,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
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
                      return Container(
                        height: 20,
                        width: (screenWidth * 0.8) * progress,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image with swipe to skip - PageView for seamless transitions
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: PageView(
                            key: ValueKey(
                              '${currentItem['image']}_${nextItem['image']}',
                            ),
                            controller: _pageController,
                            onPageChanged: (index) {
                              if (index > 0) {
                                setState(() {
                                  // Move next question to current
                                  currentItem = nextItem;
                                  displayedName = nextDisplayedName;
                                  isCorrectName = nextIsCorrectName;
                                  selectedAnswer = null;

                                  // Load new next question
                                  _loadNextQuestion();

                                  // Reset page controller to first page
                                  Future.delayed(Duration.zero, () {
                                    if (mounted) {
                                      _pageController.jumpToPage(0);
                                    }
                                  });
                                });
                              }
                            },
                            children: [
                              // Current image
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: selectedAnswer == null
                                        ? Colors.transparent
                                        : ((selectedAnswer == true &&
                                                  isCorrectName) ||
                                              (selectedAnswer == false &&
                                                  !isCorrectName))
                                        ? Colors.green
                                        : Colors.red,
                                    width: 5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        currentItem['image']!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    Spacer(),
                                    WordOfImages(
                                      letters: displayedName.toUpperCase(),
                                      letterSize: 25,
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              // Next image
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        nextItem['image']!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    // Name label
                                    WordOfImages(
                                      letters: nextDisplayedName.toUpperCase(),
                                      letterSize: 25,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // True and False buttons side by side
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // True button
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: selectedAnswer != null
                                      ? null
                                      : () => _onAnswerSelected(true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            _getButtonColor(true) ==
                                                Colors.green
                                            ? Colors.green
                                            : _getButtonColor(true) ==
                                                  Colors.red
                                            ? Colors.red
                                            : Colors.blue,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'TRUE',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _getButtonColor(true) ==
                                                  Colors.green
                                              ? Colors.green
                                              : _getButtonColor(true) ==
                                                    Colors.red
                                              ? Colors.red
                                              : Colors.blue,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // False button
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: GestureDetector(
                                  onTap: selectedAnswer != null
                                      ? null
                                      : () => _onAnswerSelected(false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            _getButtonColor(false) ==
                                                Colors.green
                                            ? Colors.green
                                            : _getButtonColor(false) ==
                                                  Colors.red
                                            ? Colors.red
                                            : Colors.blue,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'FALSE',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _getButtonColor(false) ==
                                                  Colors.green
                                              ? Colors.green
                                              : _getButtonColor(false) ==
                                                    Colors.red
                                              ? Colors.red
                                              : Colors.blue,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
