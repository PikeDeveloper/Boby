import 'dart:async';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CardSound extends StatefulWidget {
  final int colorKey; // Add colorKey parameter

  const CardSound({
    required this.sound,
    required this.name,
    required this.image,
    this.isActive = false,
    required this.colorKey, // This will change with each game
    this.onTap,
    super.key,
  });

  // Call this method to reset colors for a new game
  static void resetColors() {
    _CardSoundState.resetColors();
  }

  final String sound;
  final String name;
  final String image;
  final bool isActive;
  final VoidCallback? onTap;

  // Get the correct name for this card from the image path
  String get correctName {
    // Extract the name from the image path (assuming format like 'assets/images/cat.png')
    final fileName = image.split('/').last.split('.').first;
    // Capitalize first letter
    return fileName[0].toUpperCase() + fileName.substring(1);
  }

  @override
  State<CardSound> createState() => _CardSoundState();
}

class _CardSoundState extends State<CardSound>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late final AnimationController _jumpCtrl;
  late final Animation<double> _jumpY;
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStateSubscription;
  late final Color _borderColor;

  static final List<Color> _borderColors = [
    const Color(0xFFF1C40F), // Amarillo
    const Color(0xffBE5EED), // Morado
    const Color(0xFFFF4C88), // Rosa
    const Color(0xFFEF4444), // Rojo
    const Color(0xFF19E680), // Verde
    const Color(0xFF25AFF4), // Azul
    const Color(0xFFFFA500), // Naranja
    const Color(0xFF9B59B6), // Púrpura
    const Color(0xFF1ABC9C), // Verde azulado
    const Color(0xFFE74C3C), // Rojo oscuro
    const Color(0xFF3498DB), // Azul claro
    const Color(0xFF2ECC71), // Verde esmeralda
  ];

  // Use a map to store colors per (name, colorKey) pair
  static final Map<String, Map<int, Color>> _assignedColors = {};

  // Call this method to reset colors for a new game
  static void resetColors() {
    // No need to clear here, we'll use the colorKey to get new colors
  }

  @override
  void initState() {
    super.initState();
    _jumpCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _jumpY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -16.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -16.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_jumpCtrl);

    // Get or create color for this card based on name and colorKey
    if (!_assignedColors.containsKey(widget.name)) {
      _assignedColors[widget.name] = {};
    }

    // If we don't have a color for this colorKey yet, assign one
    if (!_assignedColors[widget.name]!.containsKey(widget.colorKey)) {
      // Get all currently assigned colors for this game
      final usedColors = _assignedColors.values
          .map((map) => map[widget.colorKey])
          .whereType<Color>()
          .toSet();

      // Find an available color
      Color availableColor;
      final availableColors = _borderColors
          .where((color) => !usedColors.contains(color))
          .toList();

      if (availableColors.isNotEmpty) {
        availableColor =
            availableColors[Random().nextInt(availableColors.length)];
      } else {
        // If all colors are used, start reusing them
        availableColor = _borderColors[Random().nextInt(_borderColors.length)];
      }

      _assignedColors[widget.name]![widget.colorKey] = availableColor;
    }

    _borderColor = _assignedColors[widget.name]![widget.colorKey]!;
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    _jumpCtrl.dispose();
    super.dispose();
  }

  // Check if the device is an iPad
  bool get isTablet {
    // ignore: deprecated_member_use
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    return data.size.shortestSide >=
        600; // 600 is a common breakpoint for tablets
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    bool isLandscape = screenSize.width > screenSize.height;
    double minSize = min(screenSize.width, screenSize.height);
    double cardWidth = isTablet ? 170.0 : 150.0;
    double cardHeight = cardWidth * 1.2; // Maintain aspect ratio

    if (((cardWidth * 4) + 20) > minSize && isLandscape) {
      cardWidth = minSize / 4;
      cardHeight = cardWidth * 1.2; // Maintain aspect ratio
    }

    // Animations disabled: static card

    return GestureDetector(
      onTap: () async {
        widget.onTap?.call();
        _jumpCtrl.forward(from: 0);

        try {
          // Stop any currently playing sound
          await _audioPlayer.stop();
          _playerStateSubscription?.cancel();

          // Play the sound
          await _audioPlayer.setAsset(widget.sound);
          await _audioPlayer.play();

          if (mounted) {
            setState(() {
              _isPlaying = true;
            });
          }

          // Listen for audio completion
          _playerStateSubscription = _audioPlayer.playerStateStream.listen((
            state,
          ) {
            if (state.processingState == ProcessingState.completed) {
              if (mounted) {
                setState(() {
                  _isPlaying = false;
                });
              }
            }
          });
        } catch (e) {
          debugPrint('Error playing sound: $e');
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
        }
      },
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _jumpY,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _jumpY.value),
              child: child,
            ),
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: _borderColor, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.asset(widget.image, fit: BoxFit.cover),

                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: !widget.name.isNotEmpty
                            ? Container(
                                width: 150,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1,
                                  horizontal: 12,
                                ),
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    color: const Color(0xFF1E88E5),
                                    strokeWidth: 2,
                                    dashPattern: const [6, 4],
                                    radius: const Radius.circular(20),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromARGB(
                                        232,
                                        242,
                                        242,
                                        242,
                                      ).withOpacity(0.2),
                                    ),
                                    child: Text(
                                      "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 6, 45, 243),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 130,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromARGB(
                                    232,
                                    242,
                                    242,
                                    242,
                                  ).withOpacity(0.8), // Light blue background
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(
                                      255,
                                      0,
                                      0,
                                      200,
                                    ), // Blue text
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
