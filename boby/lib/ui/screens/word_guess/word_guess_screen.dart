import 'package:boby/ui/screens/word_guess/widgets/word_guess_word.dart';
import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../../utils/colors.dart';

class WordGuessScreen extends StatefulWidget {
  const WordGuessScreen({super.key});

  @override
  State<WordGuessScreen> createState() => _WordGuessScreenState();
}

class _WordGuessScreenState extends State<WordGuessScreen> {
  final List<Map<String, String>> assets = Constants.assets;

  int currentIndex = 0;
  late String targetWord; // e.g., "CAT"
  late List<_Slot> slots; // answer slots
  late List<_KeyChar> keys; // keyboard keys (two rows)

  @override
  void initState() {
    super.initState();
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
    setState(() {});
  }

  void _onKeyTap(int keyIndex) {
    final key = keys[keyIndex];
    if (key.used) return;

    // Find first empty slot (skip spaces if any appear in names)
    final slotIndex = slots.indexWhere((s) => s.char == null);
    if (slotIndex == -1) return;

    setState(() {
      slots[slotIndex] = _Slot(char: key.char, keyIndex: keyIndex);
      keys[keyIndex] = key.copyWith(used: true);
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
    });
  }

  void _clearAll() {
    setState(() {
      for (var i = 0; i < slots.length; i++) {
        slots[i] = _Slot.empty();
      }
      for (var i = 0; i < keys.length; i++) {
        keys[i] = keys[i].copyWith(used: false);
      }
    });
  }

  void _checkIfCompleted() {
    final guess = slots.map((s) => s.char ?? "").join("");
    if (guess.length == targetWord.replaceAll(" ", "").length) {
      if (guess == targetWord.replaceAll(" ", "")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Correcto!')),
        );
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            currentIndex = (currentIndex + 1) % assets.length;
          });
          _startRound();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Intenta de nuevo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = assets[currentIndex]["image"] ?? "";

    final screenSize = MediaQuery.of(context).size;
    final minSize = min(screenSize.width, screenSize.height);

    // Split keys into two rows
    final firstRow = keys.take((keys.length / 2).ceil()).toList();
    final secondRow = keys.skip((keys.length / 2).ceil()).toList();

    final colors = [MyColors.yellow, MyColors.purple, MyColors.guayaba, MyColors.red, MyColors.green, MyColors.blue];

    return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, 
            children: [
            
             WordGuessWord(),
                 const SizedBox(height: 30),
              SizedBox(
                    width: minSize * 0.8,
                    height: minSize * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image_not_supported, size: 48)),
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
                          border: Border.all(color: Colors.grey.shade400, width: 2),
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

              // Controls
            /*  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.tonal(
                    onPressed: _clearAll,
                    child: const Text('Limpiar'),
                  ),
                ],
              ),*/

              const SizedBox(height: 12),

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