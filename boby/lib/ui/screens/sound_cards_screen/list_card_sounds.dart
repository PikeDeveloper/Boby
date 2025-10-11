import 'package:flutter/material.dart';

import 'widgets/card_sound.dart';

class ListCardSounds extends StatelessWidget {
  ListCardSounds({super.key});

  final List<Map<String, String>> assets = [
    {
      "image": "assets/images/accordeon.jpg",
      "name": "Accordion",
      "sound": "assets/sounds/accordeon.wav",
    },
    {
      "image": "assets/images/bee.jpg",
      "name": "Bee",
      "sound": "assets/sounds/bee.wav",
    },
    {
      "image": "assets/images/bell.jpg",
      "name": "Bell",
      "sound": "assets/sounds/bell.wav",
    },
    {
      "image": "assets/images/bus.jpg",
      "name": "Bus",
      "sound": "assets/sounds/bus.wav",
    },
    {
      "image": "assets/images/cat.jpg",
      "name": "Cat",
      "sound": "assets/sounds/cat.wav",
    },
    {
      "image": "assets/images/chick.jpg",
      "name": "Chick",
      "sound": "assets/sounds/chick.wav",
    },
    {
      "image": "assets/images/clapping.jpg",
      "name": "Clapping",
      "sound": "assets/sounds/clapping.wav",
    },
    {
      "image": "assets/images/cow.jpg",
      "name": "Cow",
      "sound": "assets/sounds/cow.wav",
    },
    {
      "image": "assets/images/dog.jpg",
      "name": "Dog",
      "sound": "assets/sounds/dog.wav",
    },
    {
      "image": "assets/images/drum.jpg",
      "name": "Drum",
      "sound": "assets/sounds/drum.wav",
    },
    {
      "image": "assets/images/duck.jpg",
      "name": "Duck",
      "sound": "assets/sounds/duck.wav",
    },
    {
      "image": "assets/images/firetruck.jpg",
      "name": "Firetruck",
      "sound": "assets/sounds/firetruck.wav",
    },
    {
      "image": "assets/images/fireworks.jpg",
      "name": "Fireworks",
      "sound": "assets/sounds/fireworks.wav",
    },
    {
      "image": "assets/images/flaute.jpg",
      "name": "Flute",
      "sound": "assets/sounds/flaute.wav",
    },
    {
      "image": "assets/images/frog.jpg",
      "name": "Frog",
      "sound": "assets/sounds/frog.wav",
    },
    {
      "image": "assets/images/guitar.jpg",
      "name": "Guitar",
      "sound": "assets/sounds/guitar.wav",
    },
    {
      "image": "assets/images/hen.jpg",
      "name": "Hen",
      "sound": "assets/sounds/hen.wav",
    },
    {
      "image": "assets/images/horse.jpg",
      "name": "Horse",
      "sound": "assets/sounds/horse.wav",
    },
    {
      "image": "assets/images/lion.jpg",
      "name": "Lion",
      "sound": "assets/sounds/lion.wav",
    },
    {
      "image": "assets/images/owl.jpg",
      "name": "Owl",
      "sound": "assets/sounds/owl.wav",
    },
    {
      "image": "assets/images/phone.jpg",
      "name": "Phone",
      "sound": "assets/sounds/telephone.wav",
    },
    {
      "image": "assets/images/piano.jpg",
      "name": "Piano",
      "sound": "assets/sounds/piano.wav",
    },
    {
      "image": "assets/images/pig.jpg",
      "name": "Pig",
      "sound": "assets/sounds/pig.wav",
    },
    {
      "image": "assets/images/rooster.jpg",
      "name": "Rooster",
      "sound": "assets/sounds/rooster.wav",
    },
    {
      "image": "assets/images/sheep.jpg",
      "name": "Sheep",
      "sound": "assets/sounds/sheep.wav",
    },
    {
      "image": "assets/images/train.jpg",
      "name": "Train",
      "sound": "assets/sounds/train.wav",
    },
    {
      "image": "assets/images/trumpet.jpg",
      "name": "Trumpet",
      "sound": "assets/sounds/trumpet.wav",
    },
    {
      "image": "assets/images/water.jpg",
      "name": "Water",
      "sound": "assets/sounds/water.wav",
    },
    {
      "image": "assets/images/whistle.jpg",
      "name": "Whistle",
      "sound": "assets/sounds/whistle.wav",
    },
    {
      "image": "assets/images/xylophone.jpg",
      "name": "Xylophone",
      "sound": "assets/sounds/xylophone.wav",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double width = 0;
    if (screenWidth < 300) {
      width = screenWidth * 0.4;
    } else if (screenWidth < 700) {
      width = screenWidth * 0.3;
    } else {
      width = screenWidth * 0.2;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: width, // máximo ancho por item
          crossAxisSpacing: width * 0.1,
          mainAxisSpacing: width * 0.1,
          childAspectRatio: 1, // cuadrado (ancho = alto)
        ),
      
        itemCount: assets.length,
      
        itemBuilder: (context, index) {
          return CardSound(
            image: assets[index]["image"]!,
            name: assets[index]["name"]!,
            sound: assets[index]["sound"]!,
          );
        },
      ),
    );
  }
}
