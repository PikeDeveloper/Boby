import 'package:flutter/material.dart';

class CardSound
 extends StatelessWidget {
  const CardSound
  ({super.key,
  required String sound,
required String name,
required String image,
required VoidCallback onPressed,
  });

  final String? sound = null;
  final String? name = "Dog";
  final String? image = "assets/images/dog.jpg";
  final VoidCallback? onPressed = null;

  @override
  Widget build(BuildContext context) {
    double width = 300.0;
    double height = 300.0;
    return 
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        borderOnForeground: true,

        color: Colors.white,
        child: Column(
          children: [
            Image.asset(image!),
            Text(name!),
            Text(sound!),
            
       
          ],
        ),
      );
  }
}