import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';

class SentenceContainer extends StatelessWidget {
  const SentenceContainer({super.key, required this.sentence});

  final String sentence;

  final Color brown = const Color.fromARGB(255, 252, 138, 106);
  final Color yellow = const Color.fromARGB(255, 247, 192, 27);
  final Color beige = const Color.fromARGB(255, 247, 233, 142);

  final double borderRadius = 15;
  final double height = 100;
  final double width = 350;

  final double margin = 4;

  final double borderRadiusFactor = 2;
  

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final bool isTablet = screenWidth > Constants.tabletSize;
    final bool iisLandscape = screenWidth > screenHeight;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding:  EdgeInsets.all(margin),
       
          decoration: BoxDecoration(
            color: brown,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child:  Container(
            padding:  EdgeInsets.all(margin),
     
          decoration: BoxDecoration(
            
            color: yellow,
            borderRadius: BorderRadius.circular(borderRadius -  borderRadiusFactor),
          ),
          child:  Container(
            padding:  EdgeInsets.all(margin),      
          decoration: BoxDecoration(
            color: brown,
            borderRadius: BorderRadius.circular(borderRadius -  borderRadiusFactor *2),
          ),
          child: Container(
          height: height,
          
          decoration: BoxDecoration(
            color: beige,
            borderRadius: BorderRadius.circular(borderRadius -  borderRadiusFactor * 3),
          ),
          child: Center(
            child: Text(
              sentence,
              style:  TextStyle(
                color: Color.fromARGB(255, 16, 69, 245),
                fontSize:  isTablet || iisLandscape ? 30 : 25,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        
        ),
        )
        ),
        
        

      ],
    );
  }
}