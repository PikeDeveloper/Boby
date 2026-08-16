import 'dart:math';
import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/screens/tales_scrren/widgets/image_tale.dart';
import 'package:boby/ui/screens/tales_scrren/widgets/tales.dart';
import 'package:boby/ui/shared/score.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class TalesScreen extends StatefulWidget {
  static const String routeName = '/tales';
  const TalesScreen({super.key});

  @override
  State<TalesScreen> createState() => _TalesScreenState();
}

class _TalesScreenState extends State<TalesScreen> {
  final AppController _appController = Get.find();
  final StorageService _storageService = Get.find<StorageService>();
  int _currentTaleIndex = 0;
  List<String> _currentAnswers = [];
  String? _correctAnswer;
  final Set<String> _incorrectSelections = {}; // Track incorrect choices
  bool _answered = false; // "Level Completed" state

  late AudioPlayer _audioPlayer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer = AudioPlayer();
    // Initial load: get random index
    // Note: We need to know total tales count. Tales.tales is accessible.
    _currentTaleIndex = _appController.getNextTaleIndex(Tales.tales.length);
    _loadTale();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTale() async {
    // Stop any currently playing audio when loading a new tale
    await _audioPlayer.stop();

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

    // Load audio
    if (taleData['audio'] != null) {
      try {
        await _audioPlayer.setAsset(taleData['audio']!);
        // Listen to player state to reset to start if needed or update UI
      } catch (e) {
        debugPrint("Error loading audio: $e");
      }
    }

    setState(() {
      _answered = false;
      _incorrectSelections.clear();
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (_answered) return; // Already completed this level

    bool isCorrect = selectedAnswer == _correctAnswer;

    setState(() {
      if (isCorrect) {
        _appController.playGameBonus();
        _storageService.incTalesCorrect();
        _answered = true; // Mark level as completed
        // Scroll to top
        try {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } catch (e) {
          debugPrint("Error scrolling to top: $e");
        }
        // load next tale
        _currentTaleIndex = _appController.getNextTaleIndex(Tales.tales.length);
        _loadTale();
        // Transition after delay
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            _appController.setBonusScreen();
          }
        });
      } else {
        _appController.playBubblePop();
        _storageService.incTalesWrong();
        // Wrong answer: Mark it as incorrect so it stays red
        _incorrectSelections.add(selectedAnswer);
      }
    });
  }

  // Toggle audio play/pause/replay
  void _toggleAudio() async {
    final playerState = _audioPlayer.playerState;
    final processingState = playerState.processingState;

    if (processingState == ProcessingState.completed) {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } else if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final taleData = Tales.tales[_currentTaleIndex];
    final hasAudio = taleData['audio'] != null;
    final appController = Get.find<AppController>();

    return Container(
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
            Score(game: appController.gameSelected.value),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
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
                            color: Colors.orange.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        children: [
                          // Header with Audio Icon and Slider
                          // Header with Audio Icon and Slider
                          if (hasAudio)
                            Container(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  StreamBuilder<PlayerState>(
                                    stream: _audioPlayer.playerStateStream,
                                    builder: (context, snapshot) {
                                      final playerState = snapshot.data;
                                      final processingState = playerState?.processingState;
                                      final playing = playerState?.playing ?? false;

                                      IconData iconAsset;
                                      String label;
                                      if (processingState == ProcessingState.completed) {
                                        iconAsset = Icons.replay_rounded;
                                        label = 'Read Again';
                                      } else if (playing) {
                                        iconAsset = Icons.pause_rounded;
                                        label = 'Pause';
                                      } else {
                                        iconAsset = Icons.play_arrow_rounded;
                                        label = 'Read to Me';
                                      }

                                      return ElevatedButton.icon(
                                        onPressed: _toggleAudio,
                                        icon: Icon(iconAsset, size: 36),
                                        label: Text(
                                          label,
                                          style: GoogleFonts.comicNeue(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                          elevation: 6,
                                          shadowColor: Colors.orange.withValues(alpha: 0.5),
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            side: const BorderSide(color: Colors.white, width: 3),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  StreamBuilder<Duration?>(
                                    stream: _audioPlayer.durationStream,
                                    builder: (context, snapshot) {
                                      final duration = snapshot.data ?? Duration.zero;
                                      return StreamBuilder<Duration>(
                                        stream: _audioPlayer.positionStream,
                                        builder: (context, snapshot) {
                                          var position = snapshot.data ?? Duration.zero;
                                          if (position > duration) position = duration;
                                          return SliderTheme(
                                            data: SliderTheme.of(context).copyWith(
                                              trackHeight: 12,
                                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                                              activeTrackColor: Colors.orange,
                                              inactiveTrackColor: Colors.orange.shade100,
                                              thumbColor: Colors.orange.shade700,
                                            ),
                                            child: Slider(
                                              value: position.inMilliseconds.toDouble(),
                                              max: duration.inMilliseconds.toDouble(),
                                              onChanged: (value) {
                                                _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                          // Image Card
                          if (taleData['image'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: ImageTale(image: taleData['image']!),
                            ),

                          // Story Text
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F8E9), // Light green background for readability
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFAED581), width: 3),
                            ),
                            child: Text(
                              taleData['tale'] ?? '',
                              style: GoogleFonts.comicNeue(
                                fontSize: 26, // Much bigger for kids
                                height: 1.6, // More line spacing
                                color: const Color(0xFF33691E), // Darker green for contrast
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.left,
                            ),
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
                            bool isCorrectAnswer = answer == _correctAnswer;
                            bool isIncorrectlySelected = _incorrectSelections
                                .contains(answer);
                            bool isLevelCompleted = _answered;

                            // Check visual state
                            Color bgColor = Colors.white;
                            Color textColor = Colors.blueGrey;
                            Color borderColor = Colors.transparent;

                            if (isLevelCompleted && isCorrectAnswer) {
                              // Show green for the correct answer when done
                              bgColor = Colors.green.shade100;
                              textColor = Colors.green.shade800;
                              borderColor = Colors.green;
                            } else if (isIncorrectlySelected) {
                              // Show red for wrong answers that were picked
                              bgColor = Colors.red.shade100;
                              textColor = Colors.red.shade800;
                              borderColor = Colors.red;
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
                                    elevation: 4,
                                    shadowColor: Colors.black12,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: borderColor,
                                        width:
                                            (isLevelCompleted &&
                                                    isCorrectAnswer) ||
                                                isIncorrectlySelected
                                            ? 2
                                            : 0,
                                      ),
                                    ),
                                  ),
                                  onPressed:
                                      (isLevelCompleted ||
                                          isIncorrectlySelected)
                                      ? null // Block interaction if already handled
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
                                      if (isLevelCompleted && isCorrectAnswer)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: textColor,
                                        )
                                      else if (isIncorrectlySelected)
                                        Icon(
                                          Icons.cancel_rounded,
                                          color: textColor,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
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
    );
  }
}
