import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/shared/word_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainMenu extends StatelessWidget {
  MainMenu({super.key});

  final String soundPath = "assets/sounds/transition.wav";

  final List<Map<String, dynamic>> options = [
    {
      "name": "DragAndDrop",
      "route": "0",
      "image": "assets/sounds_icon.png",
      "label": "Drag & Drop",
      "badgeColor": const Color(0xFF8E44AD),
    },
    {
      "name": "Memory",
      "route": "1",
      "image": "assets/memory_icon.png",
      "label": "Memory",
      "badgeColor": const Color(0xFF1ABC9C),
    },
    {
      "name": "Letters Soup",
      "route": "2",
      "image": "assets/letters_soup_icon.png",
      "label": "Word Search",
      "badgeColor": const Color(0xFF2ECC71),
    },
    {
      "name": "Tales",
      "route": "3",
      "image": "assets/tales_icon.png",
      "label": "Tales",
      "badgeColor": const Color(0xFFFF9F43),
    },
    {
      "name": "Word Guess",
      "route": "4",
      "image": "assets/word_guess_icon.png",
      "label": "Word Guess",
      "badgeColor": const Color(0xFFFF5252),
    },
    {
      "name": "ScrambleWord",
      "route": "5",
      "image": "assets/scramble_icon.png",
      "label": "Word Scramble",
      "badgeColor": const Color(0xFF3498DB),
    },
    {
      "name": "Names",
      "route": "6",
      "image": "assets/match_it_icon.png",
      "label": "Match Names",
      "badgeColor": const Color(0xFFE67E22),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final screenSize = MediaQuery.of(context).size;

    double minSide = min(screenSize.width, screenSize.height);

    if (screenSize.width / screenSize.height > 1) {
      minSide = minSide * 0.6;
    }

    // Adapt card size to available height to avoid overflow
    double availableHeight = screenSize.height * 0.85;
    double cardSize = ((availableHeight - 200) / 3 * 0.6).clamp(60.0, minSide * 0.27);

    List<Widget> widgets = [];
    for (var option in options) {
      widgets.add(
        BouncyMenuButton(
          size: cardSize,
          imagePath: option["image"] as String,
          label: option["label"] as String,
          badgeColor: option["badgeColor"] as Color,
          onTap: () {
            appController.playMenuSound(soundPath);
            appController.menuOpen.value = false;
            appController.isTrainingMode.value = false;
            appController.currentPage.value = int.parse(option["route"] as String);
            appController.gameSelected.value = option["name"] as String;
          },
        ),
      );
    }

    return Stack(
      children: [
        // Fondo semi-transparente para cerrar al tocar afuera
        GestureDetector(
          onTap: () {
            appController.menuOpen.value = false;
          },
          child: Container(
            color: Colors.black.withValues(alpha: 0.65),
            width: screenSize.width,
            height: screenSize.height,
          ),
        ),
        Center(
          child: ZoomIn(
            duration: const Duration(milliseconds: 320),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Contenedor principal con doble marco tridimensional
                Container(
                  width: minSide * 0.88,
                  constraints: BoxConstraints(
                    maxHeight: screenSize.height * 0.88,
                  ),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/backgrounds/soft.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: const Color(0xFF4CD964), width: 6.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: const Color(0xFF4CD964).withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 2),
                          const WordMenu(),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [widgets[0], widgets[1]],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [widgets[2], widgets[3]],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [widgets[4], widgets[5]],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                // Botón "X" de cierre rápido arriba a la derecha
                Positioned(
                  top: -14,
                  right: -14,
                  child: GestureDetector(
                    onTap: () {
                      appController.menuOpen.value = false;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFEE5253)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BouncyMenuButton extends StatefulWidget {
  final VoidCallback onTap;
  final String imagePath;
  final String label;
  final Color badgeColor;
  final double size;

  const BouncyMenuButton({
    super.key,
    required this.onTap,
    required this.imagePath,
    required this.label,
    required this.badgeColor,
    required this.size,
  });

  @override
  State<BouncyMenuButton> createState() => _BouncyMenuButtonState();
}

class _BouncyMenuButtonState extends State<BouncyMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.08,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = 1.0 - _controller.value;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: Transform.scale(
        scale: scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: Image.asset(widget.imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: widget.badgeColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white, width: 1.8),
                boxShadow: [
                  BoxShadow(
                    color: widget.badgeColor.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.2,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


