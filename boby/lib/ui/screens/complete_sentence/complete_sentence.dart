import 'dart:math';

import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/shared/score.dart';
import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/sentences.dart';

class CompleteSentence extends StatefulWidget {
  const CompleteSentence({super.key});

  @override
  State<CompleteSentence> createState() => _CompleteSentenceState();
}

class _CompleteSentenceState extends State<CompleteSentence> {
  final StorageService storage = Get.find<StorageService>();
  final AppController appController = Get.find<AppController>();
  int currentQuestionIndex = 0;
  bool showCorrect = false;
  List<int> usedQuestionIndices = [];
  Set<int> selectedAnswerIndices = {};
  int? selectedAnswerIndex;
  bool isCorrect = false;
  int? correctAnswerIndex; // Track the index of the correct answer after shuffling
  List<String> shuffledAnswers = []; // Store shuffled answers for current question

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
        storage.incCompleteSentenceCorrect();
    
      } else {
        // Increment wrong answers counter for incorrect selections
        storage.incCompleteSentenceWrong();
    
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
    final List<String> answers = List<String>.from(currentQuestion['answers'] as List);
    
    // Shuffle answers and track correct answer position
    shuffledAnswers = List.from(answers);
    shuffledAnswers.shuffle();
    correctAnswerIndex = shuffledAnswers.indexOf(answers[0]); // Original correct answer
  }

  @override
  void initState() {
    super.initState();
    // Initialize scores
    storage.setCompleteSentenceCorrect(storage.getCompleteSentenceCorrect());
    storage.setCompleteSentenceWrong(storage.getCompleteSentenceWrong());
    // Shuffle answers for the first question
    _shuffleAnswers();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = Sentences.sentences[currentQuestionIndex];
    final String sentence = currentQuestion['sentence'] as String;
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final bool isTablet = screenWidth > Constants.tabletSize;
    final bool iisLandscape = screenWidth > screenHeight;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: min(screenWidth *0.9, 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Score(
                  game: "CompleteSentence",
                ),
           
            // Question Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  "$sentence _____",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF71B2EB),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Answer Options
            Expanded(
              child: ListView.builder(
               // no scroll
           
                itemCount: shuffledAnswers.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedAnswerIndex == index || selectedAnswerIndices.contains(index);
                  bool isCorrectAnswer = index == correctAnswerIndex;
                  
                  Color buttonColor = const Color(0xFF71B2EB);
                  if (showCorrect && isSelected) {
                    buttonColor = isCorrectAnswer ? Colors.green : Colors.red;
                  }
                      
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () => checkAnswer(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor.withOpacity(showCorrect && isSelected ? 0.8 : 1.0),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              shuffledAnswers[index],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (showCorrect && isSelected)
                            Icon(
                              isCorrectAnswer ? Icons.check_circle : Icons.cancel,
                              color: Colors.white,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          

            
          ],
        ),
      ),
    );
  }
}