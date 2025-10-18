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

class _CardSoundState extends State<CardSound> {
  AudioPlayer? _player; // lazy init
  StreamSubscription<PlayerState>? _stateSub;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _player?.dispose();
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
            // Solo reproducir audio en plataformas compatibles (no Linux)
            if (!Platform.isLinux) {
              _player ??= AudioPlayer();
              await _player!.setAsset(widget.sound);
              _player!.play();
              if (mounted) {
                setState(() {
                  _isPlaying = true;
                });
              }
            } else {
              // En Linux, solo mostrar feedback visual
              print('Audio deshabilitado en Linux: ${widget.sound}');
            }
            
            // Handle when audio finishes playing
            _stateSub?.cancel();
            _stateSub = _player?.playerStateStream.listen((state) async {
              if (state.processingState == ProcessingState.completed) {
                _stateSub?.cancel();
                _stateSub = null;
                try {
                  await _player?.stop();
                } catch (_) {}
                await _player?.dispose();
                _player = null;
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
        }
      },
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
            child: Image.asset(widget.image, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
