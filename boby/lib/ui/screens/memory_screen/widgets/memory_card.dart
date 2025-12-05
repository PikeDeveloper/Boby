import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:animate_do/animate_do.dart';

class MemoryCard extends StatefulWidget {
  final int id;
  final String image;
  final String name;
  final String sound;
  final bool isFlipped;
  final bool isMatched;
  final Function()? onTap;
  final int colorKey;
  final int gameVersion; // To force rebuild when game restarts

  const MemoryCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.isFlipped,
    required this.isMatched,
    this.onTap,
    required this.colorKey,
    required this.gameVersion,
    required this.sound,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    if (widget.isFlipped) {
      _flipController.value = 1.0;
    }
  }

  AnimationController? _pulseController;

  @override
  void didUpdateWidget(MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }

    if (widget.isMatched && !oldWidget.isMatched) {
      _pulseController?.forward();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isFlipped && !widget.isMatched) {
          widget.onTap?.call();
        }
      },
      child: Pulse(
        manualTrigger: true,
        controller: (controller) {
          _pulseController = controller;
          if (widget.isMatched) {
            controller.forward();
          }
        },
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            final angle = _flipAnimation.value * 3.14159; // Convert to radians
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(angle);

            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: _flipAnimation.value <= 0.5
                  ? _buildCardBack()
                  : Transform(
                      transform: Matrix4.identity()..rotateY(3.14159),
                      alignment: Alignment.center,
                      child: _buildCardFront(),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(widget.image, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCardBack() {
    return Center(child: Image.asset("assets/card.png", fit: BoxFit.cover));
  }
}
