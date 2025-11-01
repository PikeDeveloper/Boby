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
  AudioPlayer? _player; // lazy init
  StreamSubscription<PlayerState>? _stateSub;
  bool _isPlaying = false;
  late final AnimationController _jumpCtrl;
  late final Animation<double> _jumpY;

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
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _player?.dispose();
    _jumpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    
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

    // Animations disabled: static card

    return GestureDetector(
      onTap: () async {
        _jumpCtrl.forward(from: 0);
        if (appController.cardSelected.value == widget.name) {
          // If already selected, stop the animation and sound
          try {
            await _player?.stop();
          } catch (_) {}
          _stateSub?.cancel();
          _stateSub = null;
          await _player?.dispose();
          _player = null;
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
          appController.cardSelected.value = ''; // Clear selection
          return; // Exit early to prevent restarting
        } else {
          // If not selected, select and start animation
          appController.cardSelected.value = widget.name;

          try {
            // Initialize audio player if not already done
            _player ??= AudioPlayer();
            
            // Stop any currently playing sound
            await _player?.stop();
            
            // Set the audio source and play
            await _player?.setAsset(widget.sound);
            await _player?.setVolume(1.0);
            await _player?.play();
            
            if (mounted) {
              setState(() {
                _isPlaying = true;
              });
            }
            
            // Add error listener
            _player?.playerStateStream.listen((state) {
              if (state.processingState == ProcessingState.completed) {
                if (mounted) {
                  setState(() {
                    _isPlaying = false;
                  });
                }
              }
            }, onError: (e) {
              debugPrint('Error playing sound: $e');
              if (mounted) {
                setState(() {
                  _isPlaying = false;
                });
              }
            });

            // Clean up when audio finishes playing
            _stateSub?.cancel();
            _stateSub = _player?.playerStateStream.listen((state) async {
              if (state.processingState == ProcessingState.completed) {
                _stateSub?.cancel();
                _stateSub = null;
                try {
                  await _player?.stop();
                  await _player?.dispose();
                  _player = null;
                } catch (e) {
                  debugPrint('Error cleaning up audio: $e');
                } finally {
                  if (mounted) {
                    setState(() {
                      _isPlaying = false;
                    });
                  }
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
                    color: borderColors[colorSelected],
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
