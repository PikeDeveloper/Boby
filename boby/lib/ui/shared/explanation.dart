import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Explanation extends StatelessWidget {
  final String text;
  final String audioPath;

  const Explanation({super.key, required this.text, required this.audioPath});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info, color: Colors.orange, size: 40),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) =>
              _ExplanationDialog(text: text, audioPath: audioPath),
        );
      },
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

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      if (widget.audioPath.startsWith('http')) {
        await _player.setUrl(widget.audioPath);
      } else {
        await _player.setAsset(widget.audioPath);
      }
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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          IconButton(
            icon: const Icon(
              Icons.volume_up_rounded,
              size: 50,
              color: Colors.blueAccent,
            ),
            onPressed: () async {
              await _player.seek(Duration.zero);
              await _player.play();
            },
          ),
          const Text("Reproducir audio", style: TextStyle(color: Colors.grey)),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK", style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}
