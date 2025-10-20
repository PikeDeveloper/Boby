import 'package:boby/ui/screens/word_guess/widgets/celebration_image.dart';
import 'package:boby/ui/screens/word_guess/widgets/control_buttons.dart';
import 'package:boby/ui/screens/word_guess/widgets/word_guess_word.dart';
import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boby/controllers/app_controller.dart';
import 'dart:math';


class WordGuessScreen extends StatefulWidget {
  const WordGuessScreen({super.key});

  @override
  State<WordGuessScreen> createState() => _WordGuessScreenState();
}

class _WordGuessScreenState extends State<WordGuessScreen> {
  final List<Map<String, String>> assets = Constants.assets;

  int currentIndex = 0;
  late final PageController _pageController;
  late String targetWord; // e.g., "CAT"
  late List<_Slot> slots; // answer slots
  late List<_KeyChar> keys; // keyboard keys (two rows)
  bool _showError = false; // show red border when guess is incorrect

  // Sounds
  final String _wrongWordSound = "assets/sounds/game-over-trombone.wav";
  final String _correctWordSound = "assets/sounds/winner-game.wav";
  final String _letterSound = "assets/sounds/bubble-pop.wav";

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    _startRound();
  }

  void _startRound() {
    final raw = assets[currentIndex]["name"] ?? "";
    targetWord = raw.toUpperCase();

    // Initialize slots (empty)
    slots = List.generate(targetWord.length, (_) => _Slot.empty());

    // Generate key pool: target letters + random fillers up to 14 total
    const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final required = targetWord.replaceAll(" ", "").split("");
    final pool = <String>[];

    pool.addAll(required);

    final rand = Random();
    while (pool.length < 14) {
      final c = alphabet[rand.nextInt(alphabet.length)];
      pool.add(c);
    }
    pool.shuffle(rand);

    keys = pool.map((c) => _KeyChar(char: c)).toList();
    setState(() {
      _showError = false;
    });
  }

  void _onKeyTap(int keyIndex) {
    final key = keys[keyIndex];
    if (key.used) return;

    // Find first empty slot (skip spaces if any appear in names)
    final slotIndex = slots.indexWhere((s) => s.char == null);
    if (slotIndex == -1) return;

    // Play letter sound
    final hasCtrl = Get.isRegistered<AppController>();
    if (hasCtrl) {
      Get.find<AppController>().playMenuSound(_letterSound);
    }

    setState(() {
      slots[slotIndex] = _Slot(char: key.char, keyIndex: keyIndex);
      keys[keyIndex] = key.copyWith(used: true);
      _showError = false; // clear error state on input
    });

    _checkIfCompleted();
  }

  void _onSlotTap(int slotIndex) {
    final slot = slots[slotIndex];
    if (slot.char == null) return;
    final kIndex = slot.keyIndex;
    setState(() {
      slots[slotIndex] = _Slot.empty();
      if (kIndex != null) {
        keys[kIndex] = keys[kIndex].copyWith(used: false);
      }
      _showError = false; // clear error state on edit
    });
  }
 

  void _next() {
    if (!mounted) return;
    final next = (currentIndex + 1) % assets.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _back() {
    if (!mounted) return;
    final prev = (currentIndex - 1 + assets.length) % assets.length;
    _pageController.animateToPage(
      prev,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _clue() {
    // Fill the first empty slot with the correct letter, if available in keys
    final cleanTarget = targetWord.replaceAll(" ", "");
    final emptyIndex = slots.indexWhere((s) => s.char == null);
    if (emptyIndex == -1) return;

    final correctChar = cleanTarget[emptyIndex];

    // Find an unused key matching the correct character
    final keyIndex = keys.indexWhere((k) => !k.used && k.char == correctChar);
    if (keyIndex == -1) {
      // If no free key with that char, do nothing gracefully
      return;
    }

    // Play letter sound for clue assistance as well
    final hasCtrl = Get.isRegistered<AppController>();
    if (hasCtrl) {
      Get.find<AppController>().playMenuSound(_letterSound);
    }

    setState(() {
      slots[emptyIndex] = _Slot(char: correctChar, keyIndex: keyIndex);
      keys[keyIndex] = keys[keyIndex].copyWith(used: true);
      _showError = false;
    });

    _checkIfCompleted();
  }

  void _checkIfCompleted() {
    final guess = slots.map((s) => s.char ?? "").join("");
    if (guess.length == targetWord.replaceAll(" ", "").length) {
      if (guess == targetWord.replaceAll(" ", "")) {
        // Play success sound
        final hasCtrl = Get.isRegistered<AppController>();
        if (hasCtrl) {
          Get.find<AppController>().playMenuSound(_correctWordSound);
          // Show celebration overlay for 1 second
          Get.find<AppController>().showCelebration(duration: const Duration(seconds: 1));
        }
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) return;
          final next = (currentIndex + 1) % assets.length;
          _pageController.animateToPage(
            next,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } else {
        // Play wrong sound and show red border
        final hasCtrl = Get.isRegistered<AppController>();
        if (hasCtrl) {
          Get.find<AppController>().playMenuSound(_wrongWordSound);
        }
        setState(() {
          _showError = true; // highlight slots with red border
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final minSize = min(screenSize.width, screenSize.height);

    // Split keys into two rows
    final firstRow = keys.take((keys.length / 2).ceil()).toList();
    final secondRow = keys.skip((keys.length / 2).ceil()).toList();

    

    // Celebration overlay controlled by AppController
    Widget celebrationOverlay = const SizedBox.shrink();
    if (Get.isRegistered<AppController>()) {  
      final app = Get.find<AppController>();
      celebrationOverlay = Obx(() => app.celebrationVisible.value ? const CelebrationImage() : const SizedBox.shrink());
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        celebrationOverlay,
        Column(
       
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, 
                children: [
        
                 WordGuessWord(),
                     const SizedBox(height: 30),
                  SizedBox(
                    width: minSize * 0.7,
                    height: minSize * 0.70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                          _startRound();
                        },
                        itemCount: assets.length,
                        itemBuilder: (context, index) {
                          final path = assets[index]["image"] ?? "";
                          return Image.asset(
                            path,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image_not_supported, size: 48)),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
        
                  // Answer slots (lines to place letters)
                  Center(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(slots.length, (i) {
                        final s = slots[i];
                        return GestureDetector(
                          onTap: () => _onSlotTap(i),
                          child: Container(
                            width: 36,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _showError ? Colors.red : Colors.grey.shade400, width: 2),
                              color: s.char == null ? Colors.transparent : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                            child: s.char == null
                                ? const SizedBox.shrink()
                                : Image.asset(
                                    "assets/letters_2/${s.char}.png",
                                    height: 36,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        );
                      }),
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                ControlButtons(next: _next, back: _back, clue: _clue  ), 
        
                  const SizedBox(height: 20),
        
                  // Two rows of letters to choose
                  _KeysRow(
                    keysRow: firstRow,
                    onTap: (idxInRow) => _onKeyTap(idxInRow),
                    baseIndex: 0,
                  ),
                  const SizedBox(height: 8),
                  _KeysRow(
                    keysRow: secondRow,
                    onTap: (idxInRow) => _onKeyTap((keys.length / 2).ceil() + idxInRow),
                    baseIndex: (keys.length / 2).ceil(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
      ],
    );
  }
}

class _KeysRow extends StatelessWidget {
  const _KeysRow({required this.keysRow, required this.onTap, required this.baseIndex});

  final List<_KeyChar> keysRow;
  final void Function(int idxInRow) onTap;
  final int baseIndex; // not used visually, but kept for clarity

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 8,
        children: List.generate(keysRow.length, (i) {
          final k = keysRow[i];
          return SizedBox(
            width: 36,
            height: 44,
            child: ElevatedButton(
              onPressed: k.used ? null : () => onTap(i),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                k.char,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _KeyChar {
  const _KeyChar({required this.char, this.used = false});
  final String char;
  final bool used;

  _KeyChar copyWith({String? char, bool? used}) => _KeyChar(char: char ?? this.char, used: used ?? this.used);
}

class _Slot {
  const _Slot({required this.char, this.keyIndex});
  final String? char;
  final int? keyIndex;

  factory _Slot.empty() => const _Slot(char: null, keyIndex: null);
}