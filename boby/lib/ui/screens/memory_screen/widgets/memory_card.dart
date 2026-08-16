import 'package:boby/utils/colors.dart';
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
      duration: const Duration(milliseconds: 450),
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
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final bool isLargeScreen = width > 600;

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
                      child: _buildCardFront(isLargeScreen: isLargeScreen),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardFront({required bool isLargeScreen}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4FC3F7), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0288D1).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 8.0, left: 8.0, right: 8.0),
              child: Image.asset(widget.image, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.name,
              style: TextStyle(
                color: const Color(0xFF0277BD),
                fontSize: isLargeScreen ? 25 : 15,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset("assets/card.png", fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      ),
    );
  }
}
