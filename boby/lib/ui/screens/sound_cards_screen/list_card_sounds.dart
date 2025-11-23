import 'package:boby/ui/screens/word_guess/widgets/celebration_image.dart';
import 'package:boby/ui/shared/score.dart';
import 'package:boby/ui/shared/word_of_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart'
    show DottedBorder, RoundedRectDottedBorderOptions;
import '../../../utils/constants.dart';
import 'widgets/card_sound.dart';
import 'package:boby/controllers/app_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:boby/services/storage_service.dart';

class ListCardSounds extends StatefulWidget {
  const ListCardSounds({super.key});

  @override
  State<ListCardSounds> createState() => _ListCardSoundsState();
}

class _ListCardSoundsState extends State<ListCardSounds> {
  late List<Map<String, String>> assets;
  final List<String?> cardNames = List.filled(4, null);
  int? activeCardIndex;
  final AppController app = Get.find<AppController>();

  final String _winSound = "assets/sounds/winner-game.wav";
  final String _wrongMatchSound = "assets/sounds/bubble-pop.wav";
  final String _gameOverSound = "assets/sounds/game-over-trombone.wav";
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String soundPath) async {
    try {
      await _audioPlayer.setAsset(soundPath);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRandomCards();
  }

  List<Map<String, String>> shuffledNames = [];

  void _loadRandomCards() {
    // Reset card names
    for (int i = 0; i < cardNames.length; i++) {
      cardNames[i] = null;
    }

    // Shuffle and take 4 random assets
    final shuffled = List<Map<String, String>>.from(Constants.assets)
      ..shuffle();
    assets = shuffled.take(4).toList();

    // Create a copy of assets for shuffling just the names
    shuffledNames = List<Map<String, String>>.from(assets)..shuffle();
  }

  Future<void> _checkAllCardsMatched() async {
    // Check if all cards are filled
    bool allFilled = cardNames.every((name) => name != null);

    if (allFilled) {
      final storage = StorageService.instance;
      // Check if all cards have their correct names
      int currentCorrect = 0;
      for (int i = 0; i < assets.length; i++) {
        if (cardNames[i] == assets[i]["name"]) {
          currentCorrect++;
        }
      }

      // Update scores in storage
      final int currentWrong = assets.length - currentCorrect;
      await storage.incSoundCardsCorrect(currentCorrect);
      await storage.incSoundCardsWrong(currentWrong);

      if (currentCorrect == assets.length) {
        // All correct - win
        await _playSound(_winSound);
        app.celebrationVisible.value = true;

        // Hide celebration and load new cards after 1 second
        await Future.delayed(const Duration(seconds: 1));
        app.celebrationVisible.value = false;
        setState(() {
          _loadRandomCards();
        });
      } else {
        // Some wrong - game over
        await _playSound(_gameOverSound);

        // Clear all cards after a short delay
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          for (int i = 0; i < cardNames.length; i++) {
            cardNames[i] = null;
          }
        });
      }
    }
  }

  // Calculate number of correct matches
  int getCorrectCount() {
    int count = 0;
    for (int i = 0; i < assets.length; i++) {
      if (cardNames[i] == assets[i]["name"]) {
        count++;
      }
    }
    return count;
  }

  // Get color based on number of correct matches
  Color getScoreColor() {
    final correctCount = getCorrectCount();
    if (correctCount == 0) {
      return Colors.red;
    } else if (correctCount <= 2) {
      return Colors.orange;
    } else if (correctCount == 4) {
      return Colors.green;
    }
    return Colors.orange; // default to orange for 3/4
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final currentCorrect = getCorrectCount();
    final totalCount = assets.length;

    bool isLandscape = screenSize.width / screenSize.height > 1;
    bool istablet = screenSize.width > Constants.tabletSize;
    bool isWide = isLandscape || istablet;

    return Stack(
      children: [
        Obx(
          () => app.celebrationVisible.value
              ? const CelebrationImage()
              : const SizedBox.shrink(),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Score(game: "DragAndDrop"),

              // Top half of screen - Cards
              isWide ? const Spacer() : const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WordOfImages(letters: "DRAG", letterSize: isWide ? 50 : 25),
                  const SizedBox(width: 10),
                  WordOfImages(letters: "AND", letterSize: isWide ? 50 : 25),
                  const SizedBox(width: 10),
                  WordOfImages(letters: "DROP", letterSize: isWide ? 50 : 25),
                ],
              ),
              isWide ? const Spacer() : const SizedBox(height: 10),
              Center(
                child: isLandscape || istablet
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (assets.isNotEmpty) _buildCardTarget(0),
                          if (assets.length > 1) _buildCardTarget(1),

                          if (assets.length > 2) _buildCardTarget(2),
                          if (assets.length > 3) _buildCardTarget(3),
                        ],
                      )
                    :
                      // First row of cards
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (assets.isNotEmpty) _buildCardTarget(0),
                              if (assets.length > 1) _buildCardTarget(1),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (assets.length > 2) _buildCardTarget(2),
                              if (assets.length > 3) _buildCardTarget(3),
                            ],
                          ),
                        ],
                      ),
              ),
              isWide ? const Spacer() : const SizedBox(height: 10),
              // Bottom half of screen - All names and score
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Show score when all cards are filled
                    if (cardNames.every((name) => name != null))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          '$currentCorrect/$totalCount',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: getScoreColor(),
                          ),
                        ),
                      )
                    else
                      // Show names when not all cards are filled
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            // First row of names
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (shuffledNames.isNotEmpty)
                                  _buildNameContainer(
                                    shuffledNames[0]["name"]!,
                                    0,
                                  ),
                                if (shuffledNames.length > 1)
                                  _buildNameContainer(
                                    shuffledNames[1]["name"]!,
                                    1,
                                  ),
                              ],
                            ),
                            if (shuffledNames.length > 2) ...[
                              const SizedBox(height: 5),
                              // Second row of names
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (shuffledNames.length > 2)
                                    _buildNameContainer(
                                      shuffledNames[2]["name"]!,
                                      2,
                                    ),
                                  if (shuffledNames.length > 3)
                                    _buildNameContainer(
                                      shuffledNames[3]["name"]!,
                                      3,
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              isWide ? const Spacer() : const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardTarget(int index) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        // Always accept any name being dragged
        setState(() {
          activeCardIndex = index;
        });
        return true;
      },
      onAccept: (name) async {
        // Play sound when dropping a name
        await _playSound(_wrongMatchSound);

        setState(() {
          // Remove from previous position if it exists
          final previousIndex = cardNames.indexOf(name);
          if (previousIndex != -1) {
            cardNames[previousIndex] = null;
          }

          // Add to new position - store the actual name that was dragged
          cardNames[index] = name;
          activeCardIndex = null;
        });

        // Check if all cards are filled
        await _checkAllCardsMatched();
      },
      builder: (context, candidateData, rejectedData) {
        return CardSound(
          colorKey: 0,
          image: assets[index]["image"]!,
          name: cardNames[index] ?? '',
          sound: assets[index]["sound"]!,
          isActive: activeCardIndex == index,
        );
      },
      onLeave: (data) {
        setState(() {
          activeCardIndex = null;
        });
      },
    );
  }

  Widget _buildNameContainer(String name, int index) {
    // Don't show the name if it's already on a card
    if (cardNames.contains(name)) {
      return Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: const SizedBox.shrink(),
      );
    }

    return Draggable<String>(
      data: name,
      feedback: Material(
        // Container con borde segmentado --------------//
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: const Radius.circular(20),
              color: const Color(0xFF1E88E5),
              strokeWidth: 2,
              dashPattern: const [6, 4],
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(
                  232,
                  242,
                  242,
                  242,
                ).withOpacity(0.8),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 6, 45, 243),
                ),
              ),
            ),
          ),
        ),
      ),
      // Container con borde segmentado --------------//
      childWhenDragging: Container(
        width: 150,
        //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: const Color(0xFF1E88E5),
            strokeWidth: 2,
            dashPattern: const [6, 4],
            radius: const Radius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ),
      // Container con borde segmentado --------------//
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: const Color(0xFF1E88E5),
            strokeWidth: 2,
            dashPattern: const [6, 4],
            radius: const Radius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(232, 242, 242, 242).withOpacity(0.8),
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 6, 45, 243),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
