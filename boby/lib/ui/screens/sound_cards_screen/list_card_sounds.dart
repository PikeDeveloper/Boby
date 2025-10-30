import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'widgets/card_sound.dart';

class ListCardSounds extends StatelessWidget {
  ListCardSounds({super.key});

  final List<Map<String, String>> assets = Constants.assets;

  @override
  Widget build(BuildContext context) {
    // Get the first 4 assets or all if less than 4
    final displayAssets = assets.length > 4 ? assets.sublist(0, 4) : assets;
    final screenSize = MediaQuery.of(context).size;
    final safePadding = MediaQuery.of(context).padding;

    return SafeArea(
      child: Column(
        children: [
          // Top half of screen - Cards (slightly less than half to prevent overflow)
          SizedBox(
            height: (screenSize.height - safePadding.top - safePadding.bottom) * 0.45,
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
                        if (displayAssets.isNotEmpty)
                          CardSound(
                            image: displayAssets[0]["image"]!,
                            name: '',
                            sound: displayAssets[0]["sound"]!,
                          ),
                        if (displayAssets.length > 1)
                          CardSound(
                            image: displayAssets[1]["image"]!,
                            name: '',
                            sound: displayAssets[1]["sound"]!,
                          ),
                      ],
                    ),
                    if (displayAssets.length > 2) ...[
                      const SizedBox(height: 20),
                      // Second row of cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (displayAssets.length > 2)
                            CardSound(
                              image: displayAssets[2]["image"]!,
                              name: '',
                              sound: displayAssets[2]["sound"]!,
                            ),
                          if (displayAssets.length > 3)
                            CardSound(
                              image: displayAssets[3]["image"]!,
                              name: '',
                              sound: displayAssets[3]["sound"]!,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom half of screen - Names
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
                      if (displayAssets.isNotEmpty)
                        _buildNameContainer(displayAssets[0]["name"]!),
                      if (displayAssets.length > 1)
                        _buildNameContainer(displayAssets[1]["name"]!),
                    ],
                  ),
                  if (displayAssets.length > 2) ...[
                    const SizedBox(height: 20),
                    // Second row of names
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (displayAssets.length > 2)
                          _buildNameContainer(displayAssets[2]["name"]!),
                        if (displayAssets.length > 3)
                          _buildNameContainer(displayAssets[3]["name"]!),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameContainer(String name) {
    return Container(
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
    );
  }
}
