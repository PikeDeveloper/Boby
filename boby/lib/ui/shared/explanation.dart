import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class Explanation extends StatelessWidget {
  final String text;
  final String audioPath;

  const Explanation({super.key, required this.text, required this.audioPath});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              _ExplanationDialog(text: text, audioPath: audioPath),
        );
      },
      icon: Image.asset("assets/explanation.png"),
    );
  }
}

class _ExplanationDialog extends StatefulWidget {
  final String text;
  final String audioPath;

  const _ExplanationDialog({required this.text, required this.audioPath});

  @override
  State<_ExplanationDialog> createState() => _ExplanationDialogState();
}

class _ExplanationDialogState extends State<_ExplanationDialog> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isCompleted = state.processingState == ProcessingState.completed;
        });
      }
    });
  }

  Future<void> _initAudio() async {
    try {
      if (widget.audioPath.startsWith('http')) {
        await _player.setUrl(widget.audioPath);
      } else {
        await _player.setAsset(widget.audioPath);
      }
      await _player.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      duration: const Duration(milliseconds: 400),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.orange.shade200, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              const SizedBox(height: 20),

              // Text Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.text,
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),

              // Audio Player Control
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (_isPlaying) {
                      await _player.pause();
                    } else {
                      await _player.seek(Duration.zero);
                      await _player.play();
                    }
                  },
                  child: Icon(
                    _isCompleted
                        ? Icons.replay_rounded
                        : (_isPlaying
                              ? Icons.pause_rounded
                              : Icons.volume_up_rounded),
                    color: Colors.orange.shade800,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // OK Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
