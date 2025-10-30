import 'package:boby/ui/screens/word_guess/widgets/celebration_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/constants.dart';
import 'widgets/card_sound.dart';
import 'package:get/get.dart';
import 'package:boby/controllers/app_controller.dart';

  
class ListCardSounds extends StatefulWidget {
  const ListCardSounds({super.key});

  @override
  State<ListCardSounds> createState() => _ListCardSoundsState();
}

class _ListCardSoundsState extends State<ListCardSounds> {
  final List<Map<String, String>> assets = List.from(Constants.assets);
  final List<String?> cardNames = List.filled(4, null);
  int? activeCardIndex;

  final AppController app = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    // Initialize with all names at the bottom
    for (int i = 0; i < assets.length && i < 4; i++) {
      cardNames[i] = null; // Start with no names on cards
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safePadding = MediaQuery.of(context).padding;

    return Stack(
      children: [
        Obx(() => app.celebrationVisible.value
          ? const CelebrationImage()
          : const SizedBox.shrink()),
        SafeArea(
          child: Column(
            children: [
              // Top half of screen - Cards
              SizedBox(
                height: (screenSize.height - safePadding.top - safePadding.bottom) * 0.5,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // First row of cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (assets.isNotEmpty) _buildCardTarget(0),
                            if (assets.length > 1) _buildCardTarget(1),
                          ],
                        ),
                        if (assets.length > 2) ...[
                          const SizedBox(height: 20),
                          // Second row of cards
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (assets.length > 2) _buildCardTarget(2),
                              if (assets.length > 3) _buildCardTarget(3),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom half of screen - All names
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First row of names
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (assets.isNotEmpty) _buildNameContainer(assets[0]["name"]!, 0),
                          if (assets.length > 1) _buildNameContainer(assets[1]["name"]!, 1),
                        ],
                      ),
                      if (assets.length > 2) ...[
                        const SizedBox(height: 20),
                        // Second row of names
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (assets.length > 2) _buildNameContainer(assets[2]["name"]!, 2),
                            if (assets.length > 3) _buildNameContainer(assets[3]["name"]!, 3),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCorrectNameForCard(int index) {
    // Get the image path and extract the name from it
    final imagePath = assets[index]["image"]!;
    final fileName = imagePath.split('/').last.split('.').first;
    return fileName[0].toUpperCase() + fileName.substring(1);
  }

  Widget _buildCardTarget(int index) {
    final correctName = _getCorrectNameForCard(index);
    
    return DragTarget<String>(
      onAccept: (name) {
        // Only accept if the name matches the card's expected name
        if (name == correctName) {
          setState(() {
            // Remove from previous position if it exists
            final previousIndex = cardNames.indexOf(name);
            if (previousIndex != -1) {
              cardNames[previousIndex] = null;
            }
            // Add to new position
            cardNames[index] = name;
            activeCardIndex = null;
          });
        } else {
          // If incorrect name, return it to its original position
          setState(() {
            final originalIndex = assets.indexWhere((asset) => asset["name"] == name);
            if (originalIndex != -1) {
              cardNames[originalIndex] = name;
            }
          });
        }
      },
      builder: (context, candidateData, rejectedData) {
        return CardSound(
          image: assets[index]["image"]!,
          name: cardNames[index] ?? '',
          sound: assets[index]["sound"]!,
          isActive: activeCardIndex == index,
        );
      },
      onWillAccept: (data) {
        // Only highlight if the name matches the card's original name
        final shouldAccept = data == correctName;
        setState(() {
          activeCardIndex = shouldAccept ? index : null;
        });
        return shouldAccept;
      },
      onLeave: (data) {
        setState(() {
          activeCardIndex = null;
        });
      },
    );
  }

  Widget _buildNameContainer(String name, int index) {
    // Don't show the name if it's already on a card
    if (cardNames.contains(name)) {
      return Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: const SizedBox.shrink(),
      );
    }
    
    return Draggable<String>(
      data: name,
      feedback: Material(
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(232, 242, 242, 242).withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 6, 45, 243),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300],
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ),
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(232, 242, 242, 242).withOpacity(0.8),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 6, 45, 243),
          ),
        ),
      ),
    );
  }
}
