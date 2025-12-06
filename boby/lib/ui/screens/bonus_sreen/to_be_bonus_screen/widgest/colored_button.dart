import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';

class ToBeOptionButton extends StatelessWidget {
  final String letter; // The letter indicator (e.g., 'A', 'B')
  final String text; // The main text to display
  final Color color; // The main color of the button
  final VoidCallback onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;

  ToBeOptionButton({
    super.key,
    required this.letter,
    required this.text,
    required this.color,
    required this.onTap,
    this.isSelected = false,
    this.isCorrect = false,
    this.showResult = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final bool isTablet = screenWidth > Constants.tabletSize;
    final bool iisLandscape = screenWidth > screenHeight;

    double height = isTablet || iisLandscape ? 70 : 55;
    double width = isTablet || iisLandscape ? 500 : 300;
    double radiusContainer = 15;

    double lerp1 = 0.4;
    double lerp2 = 0.35;
    double lerp3 = 0.15;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              //botton container
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radiusContainer),
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              //middle container
              Container(
                height: height - 4,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radiusContainer - 2),
                  color: Color.lerp(color, Colors.white, lerp1)!,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: height - 10,
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(color, Colors.white, lerp2)!,
                      Color.lerp(color, Colors.white, lerp3)!,
                      color,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    // Left circle with letter
                    Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet || iisLandscape ? 20 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Text in the middle
                    Expanded(
                      child: Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet || iisLandscape ? 25 : 20,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    (showResult && isSelected)
                        ? Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: Colors.white,
                            size: 24,
                          )
                        : const SizedBox(width: 24),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
