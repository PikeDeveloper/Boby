import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:just_audio/just_audio.dart';
import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardSound extends StatefulWidget {
  const CardSound({
    super.key,
    required this.sound,
    required this.name,
    required this.image,
  });

  final String sound;
  final String name;
  final String image;

  @override
  State<CardSound> createState() => _CardSoundState();
}

class _CardSoundState extends State<CardSound>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Timer? _bounceTimer;
  Timer? _stopTimer;
  bool _isSelected = false;
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -0.3), // More noticeable vertical movement
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.elasticOut, // More bouncy effect
          ),
        );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed && _isSelected) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _bounceTimer?.cancel();
    _stopTimer?.cancel();
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  // Timer for managing the 4-second timeout

  void _startBouncing() {
    if (!mounted) return;

    // Reset animation values
    _controller.reset();

    // Cancel any existing timers
    _bounceTimer?.cancel();
    _stopTimer?.cancel();

    setState(() {
      _isSelected = true;
    });

    // Start the bouncing animation
    _controller.forward();

    // Set up the bounce loop - faster bounces
    _bounceTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!_isSelected || !mounted) {
        timer.cancel();
        return;
      }
      _controller.forward(from: 0);
    });

    // Stop bouncing after 4 seconds
    _stopTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _isSelected) {
        // Only stop if still selected
        _stopBouncing();
      }
    });
  }

  void _stopBouncing({bool resetState = true}) {
    if (!mounted) return;

    // Cancel timers first
    _bounceTimer?.cancel();
    _stopTimer?.cancel();

    if (_isSelected) {
      // Immediately update the state to stop any ongoing animations
      if (resetState) {
        setState(() {
          _isSelected = false;
        });
      }

      // Smoothly return to original position
      _controller.animateTo(0, duration: const Duration(milliseconds: 150));

      // Reset the controller after animation completes
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted && resetState) {
          _controller.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final AudioPlayer _player = AudioPlayer();
    List<Color> borderColors = [
      const Color(0xFFF1C40F),
      const Color(0xffBE5EED),
      const Color(0xFFFF4C88),
      const Color(0xFFEF4444),
      const Color(0xFF19E680),
      const Color(0xFF25AFF4),
      const Color(0xFFEF4444),
      const Color(0xFF19E680),
      const Color(0xFF25AFF4),
      const Color(0xFFF1C40F),
      const Color(0xffBE5EED),
      const Color(0xFFFF4C88),
    ];

    int colorSelected = Random().nextInt(borderColors.length);

    // Use ever to react to cardSelected changes
    ever(appController.cardSelected, (selectedName) {
      final isSelectedNow = selectedName == widget.name;
      if (isSelectedNow && !_isSelected) {
        _startBouncing();
      } else if (!isSelectedNow && _isSelected) {
        _stopBouncing();
      }
    });

    // Initial check
    if (appController.cardSelected.value == widget.name && !_isSelected) {
      _startBouncing();
    }

    return GestureDetector(
      onTap: () async {
        if (appController.cardSelected.value == widget.name) {
          // If already selected, stop the animation and sound
          _stopBouncing(resetState: true);
          if (!Platform.isLinux) {
            await _player.stop();
            _isPlaying = false;
          }
          appController.cardSelected.value = ''; // Clear selection
          return; // Exit early to prevent restarting
        } else {
          // If not selected, select and start animation
          appController.cardSelected.value = widget.name;
          
          try {
            // Solo reproducir audio en plataformas compatibles (no Linux)
            if (!Platform.isLinux) {
              await _player.setAsset(widget.sound);
              _player.play();
              _isPlaying = true;
            } else {
              // En Linux, solo mostrar feedback visual
              print('Audio deshabilitado en Linux: ${widget.sound}');
            }
            
            // Handle when audio finishes playing
            _player.playerStateStream.listen((state) {
              if (state.processingState == ProcessingState.completed) {
                _stopBouncing();
                if (mounted) {
                  setState(() {
                    _isPlaying = false;
                  });
                }
              }
            });
            
          } catch (e) {
            debugPrint('Error playing sound: $e');
            _stopBouncing();
            _isPlaying = false;
          }
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset:
                _animation.value *
                20, // Adjust the multiplier for more/less movement
            child: Transform.rotate(
              angle:
                  _controller.value *
                  0.1, // Slight rotation for more dynamic effect
              child: child,
            ),
          );
        },
        child: Card(
          elevation: _controller.value * 8, // Add elevation for a "pop" effect
          color: appController.cardSelected.value == widget.name
              ? _isPlaying 
                  ? Colors.green.withOpacity(0.8) 
                  : Colors.blue.withOpacity(0.8)
              : const Color.fromARGB(255, 236, 8, 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: borderColors[colorSelected],
              width: 3 + (_controller.value * 2), // Pulsing border effect
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(widget.image, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
