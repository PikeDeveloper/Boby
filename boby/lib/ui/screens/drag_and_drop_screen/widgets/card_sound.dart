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
            child: AnimatedScale(
              scale: widget.isActive ? 1.06 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: Card(
                  elevation: widget.isActive ? 10 : 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                    side: BorderSide(
                      color: widget.isActive ? const Color(0xFF4CAF50) : _borderColor,
                      width: widget.isActive ? 4 : 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(widget.image, fit: BoxFit.cover),
                        ),

                        // Soft gradient at the bottom so the label always stands out clearly
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 70,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.35),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: !widget.name.isNotEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  child: DottedBorder(
                                    options: RoundedRectDottedBorderOptions(
                                      color: widget.isActive
                                          ? const Color(0xFF2E7D32)
                                          : const Color(0xFF29B6F6),
                                      strokeWidth: widget.isActive ? 2.5 : 2,
                                      dashPattern: widget.isActive
                                          ? const [8, 3]
                                          : const [6, 4],
                                      radius: const Radius.circular(20),
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: widget.isActive
                                            ? const Color(0xFFE8F5E9)
                                            : Colors.white.withValues(alpha: 0.9),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            widget.isActive
                                                ? Icons.south_rounded
                                                : Icons.south_rounded,
                                            size: 15,
                                            color: widget.isActive
                                                ? const Color(0xFF2E7D32)
                                                : const Color(0xFF0288D1),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.isActive ? "Drop here!" : "Place here",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: widget.isActive
                                                  ? const Color(0xFF2E7D32)
                                                  : const Color(0xFF0288D1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF29B6F6),
                                        Color(0xFF0277BD),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
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
