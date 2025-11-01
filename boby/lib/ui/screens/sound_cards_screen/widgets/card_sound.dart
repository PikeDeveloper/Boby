import 'dart:async';
import 'dart:math';

import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';


class CardSound extends StatefulWidget {
  const CardSound({
    super.key,
    required this.sound,
    required this.name,
    required this.image,
    this.isActive = false,
  });

  final String sound;
  final String name;
  final String image;
  final bool isActive;
  
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
  
  static final Map<String, Color> _assignedColors = {};

  @override
  void initState() {
    super.initState();
    _jumpCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _jumpY = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -16.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: -16.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(_jumpCtrl);
    
    // Assign a random but consistent color to each unique card name
    if (!_assignedColors.containsKey(widget.name)) {
      // If we've used all colors, start reusing them
      if (_assignedColors.length >= _borderColors.length) {
        _assignedColors.clear();
      }
      
      // Find a color that hasn't been used yet
      Color availableColor;
      do {
        availableColor = _borderColors[Random().nextInt(_borderColors.length)];
      } while (_assignedColors.containsValue(availableColor) && 
               _assignedColors.length < _borderColors.length);
      
      _assignedColors[widget.name] = availableColor;
    }
    _borderColor = _assignedColors[widget.name]!;
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    _jumpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    
    // Use the pre-assigned border color

    // Animations disabled: static card

    return GestureDetector(
      onTap: () async {
        _jumpCtrl.forward(from: 0);
        
        if (appController.cardSelected.value == widget.name) {
          // If already selected, stop the animation and sound
          await _audioPlayer.stop();
          _playerStateSubscription?.cancel();
          
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
          appController.cardSelected.value = ''; // Clear selection
          return; // Exit early to prevent restarting
        }
        
        try {
          // If not selected, select and start animation
          appController.cardSelected.value = widget.name;
          
          // Play sound using local AudioPlayer
          await _audioPlayer.setAsset(widget.sound);
          await _audioPlayer.play();
          
          if (mounted) {
            setState(() {
              _isPlaying = true;
            });
          }
          
          // Listen for audio completion
          _playerStateSubscription?.cancel();
          _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
            if (state.processingState == ProcessingState.completed) {
              if (mounted) {
                setState(() {
                  _isPlaying = false;
                });
              }
              appController.cardSelected.value = ''; // Clear selection when sound finishes
            }
          });
        } catch (e) {
          debugPrint('Error playing sound: $e');
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
          appController.cardSelected.value = ''; // Clear selection on error
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
              width: 150,
              height: 150,
              child: Card(
                elevation: 4,
                color: appController.cardSelected.value == widget.name
                    ? _isPlaying
                        ? Colors.green.withOpacity(0.8)
                        : Colors.blue.withOpacity(0.8)
                    : const Color.fromARGB(255, 236, 8, 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _borderColor,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    
                    children: [
                      Image.asset(widget.image, fit: BoxFit.cover),
                      if (widget.name.isNotEmpty)
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Container(
                          width: 130,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(232, 200, 220, 255).withOpacity(0.8), // Light blue background
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
                              color: Color.fromARGB(255, 0, 0, 200), // Blue text
                            ),
                          ),
                        ),
                      )
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
