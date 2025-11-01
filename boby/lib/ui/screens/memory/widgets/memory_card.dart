import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  const MemoryCard({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            //  String backGroundImage = "assets/card.png";
            image: DecorationImage(
              image: AssetImage(image),
            ),
          ),
        ),
      ),
    );
  }
}