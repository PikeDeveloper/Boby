import 'dart:math';
import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/memory/widgets/new_game_button.dart';
import 'package:boby/ui/shared/winner_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/ui/screens/memory/widgets/memory_card.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen>
    with TickerProviderStateMixin {
  late List<MemoryCardData> cards;
  List<int> flippedCards = [];
  List<int> matchedCards = [];
  bool isProcessing = false;
  int moves = 0;
  int pairsFound = 0;
  bool isGameWon = false;
  final String soundPathFlip = "assets/sounds/bubble-pop.wav";
  final String soundPathMatch = "assets/sounds/game-bonus.wav";
  final String soundPathWinner = "assets/sounds/winner-game.wav";

  late AnimationController _flipController;
  int _targetPairs = 0;
  int _rows = 3;
  int _cols = 3;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _initializeGame();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  int _gameVersion = 0; // Add this line to track game versions

  void _initializeGame({int? rows, int? cols}) {
    // Increment game version to force new colors
    _gameVersion++;
    
    // Reset game state
    
    // Leer configuración actual si no se pasa
    final gridStr = StorageService.instance.getMemoryGrid();
    if (rows == null || cols == null) {
      final parts = gridStr.split('x');
      if (parts.length == 2) {
        final r = int.tryParse(parts[0]);
        final c = int.tryParse(parts[1]);
        if (r != null && c != null) {
          _rows = r;
          _cols = c;
        }
      }
    } else {
      _rows = rows;
      _cols = cols;
    }

    final totalSlots = _rows * _cols;
    _targetPairs = totalSlots ~/ 2; // floor

    // Seleccionar pares según la matriz
    final random = Random();
    final selectedAssets = List.from(assets);
    selectedAssets.shuffle(random);
    final gameAssets = selectedAssets.take(_targetPairs).toList();

    // Crear cartas (pares)
    cards = [];
    for (int i = 0; i < _targetPairs; i++) {
      final sound = "assets/sounds/${gameAssets[i]["name"]!.toLowerCase()}.wav";
      cards.add(
        MemoryCardData(
          id: i * 2,
          image: gameAssets[i]["image"]!,
          name: gameAssets[i]["name"]!,
          isFlipped: false,
          isMatched: false,
          colorKey: i,
          sound: sound,
        ),
      );
      cards.add(
        MemoryCardData(
          id: i * 2 + 1,
          image: gameAssets[i]["image"]!,
          name: gameAssets[i]["name"]!,
          isFlipped: false,
          isMatched: false,
          colorKey: i,
          sound: sound,
        ),
      );
    }

    // Mezclar las cartas
    cards.shuffle(random);

    // Si el número de casillas es impar, agregar una carta vacía para completar
    if (totalSlots.isOdd) {
      cards.add(
        MemoryCardData(
          id: cards.length,
          image: "",
          name: "Empty",
          isFlipped: false,
          isMatched: false,
          colorKey: 0,
          sound: "",
        ),
      );
    }

    flippedCards.clear();
    matchedCards.clear();
    moves = 0;
    pairsFound = 0;
    isGameWon = false;
  }

  final List<Map<String, String>> assets = [
    {"image": "assets/images/accordeon.jpg", "name": "Accordion"},
    {"image": "assets/images/bee.jpg", "name": "Bee"},
    {"image": "assets/images/bell.jpg", "name": "Bell"},
    {"image": "assets/images/bus.jpg", "name": "Bus"},
    {"image": "assets/images/cat.jpg", "name": "Cat"},
    {"image": "assets/images/chick.jpg", "name": "Chick"},
    {"image": "assets/images/clapping.jpg", "name": "Clapping"},
    {"image": "assets/images/cow.jpg", "name": "Cow"},
    {"image": "assets/images/dog.jpg", "name": "Dog"},
    {"image": "assets/images/drum.jpg", "name": "Drum"},
    {"image": "assets/images/duck.jpg", "name": "Duck"},
    {"image": "assets/images/firetruck.jpg", "name": "Firetruck"},
    {"image": "assets/images/fireworks.jpg", "name": "Fireworks"},
    {"image": "assets/images/flute.jpg", "name": "Flute"},
    {"image": "assets/images/frog.jpg", "name": "Frog"},
    {"image": "assets/images/guitar.jpg", "name": "Guitar"},
    {"image": "assets/images/hen.jpg", "name": "Hen"},
    {"image": "assets/images/horse.jpg", "name": "Horse"},
    {"image": "assets/images/lion.jpg", "name": "Lion"},
    {"image": "assets/images/owl.jpg", "name": "Owl"},
    {"image": "assets/images/phone.jpg", "name": "Phone"},
    {"image": "assets/images/piano.jpg", "name": "Piano"},
    {"image": "assets/images/pig.jpg", "name": "Pig"},
    {"image": "assets/images/rooster.jpg", "name": "Rooster"},
    {"image": "assets/images/sheep.jpg", "name": "Sheep"},
    {"image": "assets/images/train.jpg", "name": "Train"},
    {"image": "assets/images/trumpet.jpg", "name": "Trumpet"},
    {"image": "assets/images/water.jpg", "name": "Water"},
    {"image": "assets/images/whistle.jpg", "name": "Whistle"},
    {"image": "assets/images/xylophone.jpg", "name": "Xylophone"},
  ];

  String backGroundImage = "assets/card.png";

  void _flipCard(int index) {
    if (isProcessing ||
        flippedCards.contains(index) ||
        matchedCards.contains(index) ||
        cards[index].name == "Empty") {
      return;
    }

    // Reproducir sonido al voltear la carta
    final appController = Get.find<AppController>();
    appController.playMenuSound(soundPathFlip);

    setState(() {
      flippedCards.add(index);
      cards[index].isFlipped = true;
    });

    if (flippedCards.length == 2) {
      setState(() {
        isProcessing = true;
        moves++;
      });

      // Verificar si las cartas coinciden
      final card1 = cards[flippedCards[0]];
      final card2 = cards[flippedCards[1]];

      if (card1.name == card2.name) {
        // ¡Coinciden! - Reproducir sonido de match
        final appController = Get.find<AppController>();
        appController.playMenuSound(soundPathMatch);

        setState(() {
          matchedCards.addAll(flippedCards);
          cards[flippedCards[0]].isMatched = true;
          cards[flippedCards[1]].isMatched = true;
          pairsFound++;
        });

        flippedCards.clear();
        isProcessing = false;

        // Verificar si el juego terminó
        if (pairsFound == _targetPairs) {
          // Reproducir música de victoria
          final appController = Get.find<AppController>();
          appController.playMenuSound(soundPathWinner);

          // Mostrar pantalla de victoria
          setState(() {
            isGameWon = true;
          });
        }
      } else {
        // No coinciden, voltear de vuelta después de un delay
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              cards[flippedCards[0]].isFlipped = false;
              cards[flippedCards[1]].isFlipped = false;
              flippedCards.clear();
              isProcessing = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final minSide = min(screenSize.width, screenSize.height);
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  NewGameButton(
                    onTap: () {
                      _initializeGame();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: minSide * 0.8,
                  height: minSide * 0.8,
                  child: ValueListenableBuilder(
                    valueListenable: StorageService.instance
                        .listenable(keys: [StorageService.memoryGridKey]),
                    builder: (context, box, _) {
                      // actualizar dimensiones según selección
                      final gridStr = StorageService.instance.getMemoryGrid();
                      final parts = gridStr.split('x');
                      int rows = _rows;
                      int cols = _cols;
                      if (parts.length == 2) {
                        final r = int.tryParse(parts[0]);
                        final c = int.tryParse(parts[1]);
                        if (r != null && c != null) {
                          rows = r;
                          cols = c;
                        }
                      }

                      final totalSlots = rows * cols;
                      // re-inicializar si cambió el tamaño
                      if (rows != _rows ||
                          cols != _cols ||
                          cards.length != totalSlots) {
                        _initializeGame(rows: rows, cols: cols);
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: totalSlots,
                        itemBuilder: (context, index) {
                          return _buildCard(index);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isGameWon)
          WinnerScreen(onTap: () {
            _initializeGame();
            setState(() {});
          })
      ],
    );
  }

  Widget _buildCard(int index) {
    final card = cards[index];
    final isFlipped = flippedCards.contains(index) || matchedCards.contains(index);
    final isMatched = matchedCards.contains(index);

    if (card.name == "Empty") {
      return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
        child: const Icon(Icons.close, size: 50),
      );
    }

    // Update the card state
    final updatedCard = card.copyWith(
      isFlipped: isFlipped,
      isMatched: isMatched,
    );
    cards[index] = updatedCard;

    return MemoryCard(
      key: ValueKey('card_${card.id}_${isFlipped ? 'flipped' : 'hidden'}_${_gameVersion}'),
      id: card.id,
      image: card.image,
      name: card.name,
      isFlipped: isFlipped,
      isMatched: isMatched,
      onTap: () => _flipCard(index),
      colorKey: card.colorKey,
      gameVersion: _gameVersion,
      sound: card.sound,
    );
  }
}

class MemoryCardData {
  final int id;
  final String image;
  final String name;
  final int colorKey;
  bool isFlipped;
  bool isMatched;
  final String sound;

  MemoryCardData({
    required this.id,
    required this.image,
    required this.name,
    required this.isFlipped,
    required this.isMatched,
    required this.colorKey,
    this.sound = "",
  });
  
  MemoryCardData copyWith({
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MemoryCardData(
      id: id,
      image: image,
      name: name,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
      colorKey: colorKey,
      sound: sound,
    );
  }
}
