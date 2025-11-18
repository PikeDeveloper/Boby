import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/shared/score.dart';
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
  int currentQuestionIndex = 0;
  bool showCorrect = false;
  int? selectedAnswerIndex;
  bool isCorrect = false;

  void checkAnswer(int answerIndex) {
    final isCorrectAnswer = answerIndex == 0; // First answer is correct
    
    setState(() {
      selectedAnswerIndex = answerIndex;
      showCorrect = true;
      isCorrect = isCorrectAnswer;
      
      // Update scores only if this is a new selection
      if (isCorrectAnswer) {
        storage.incCompleteSentenceCorrect();
      } else if (selectedAnswerIndex != answerIndex) {
        // Only increment wrong answers counter for new incorrect selections
        storage.incCompleteSentenceWrong();
      }
    });

    if (isCorrectAnswer) {
      // Move to next question after a delay if answer is correct
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            showCorrect = false;
            selectedAnswerIndex = null;
            currentQuestionIndex = (currentQuestionIndex + 1) % Sentences.sentences.length;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize scores
    storage.setCompleteSentenceCorrect(storage.getCompleteSentenceCorrect());
    storage.setCompleteSentenceWrong(storage.getCompleteSentenceWrong());
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = Sentences.sentences[currentQuestionIndex];
    final String sentence = currentQuestion['sentence'] as String;
    final List<String> answers = List<String>.from(currentQuestion['answers'] as List);

    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                sentence,
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
              itemCount: answers.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedAnswerIndex == index;
                bool isCorrectAnswer = index == 0; // First answer is correct
                
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
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            answers[index],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (showCorrect && isSelected)
                          Icon(
                            isCorrectAnswer ? Icons.check_circle : Icons.cancel,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          
          // Progress Indicator
          Text(
            '${currentQuestionIndex + 1}/${Sentences.sentences.length}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}