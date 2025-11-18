import 'package:flutter/material.dart';

class NumberOfImages extends StatelessWidget {
  const NumberOfImages(
      {super.key, required this.number, required this.numberSize});

  final String number;
  final double numberSize;

  @override
  Widget build(BuildContext context) {

    // contruye los numeors del 10 al 20 si es necesario 
    
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: 
          number.length > 1 ?
          [ Image.asset("assets/numbers/${number[0]}.png", height: numberSize), 
          Image.asset("assets/numbers/${number[1]}.png", height: numberSize), ] 
          : 
           [ Image.asset("assets/numbers/${number[0]}.png", height: numberSize), ] ,

         
          
         
      
      )
    );
  }

  
  }

