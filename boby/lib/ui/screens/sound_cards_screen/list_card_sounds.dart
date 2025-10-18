import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'widgets/card_sound.dart';

class ListCardSounds extends StatelessWidget {
  ListCardSounds({super.key});

  final List<Map<String, String>> assets = Constants.assets;  
  /*
   [
    {
      "image": "assets/images/accordeon.jpg",
      "name": "Accordion",
      "sound": "assets/sound_names/accordeon.wav",
    },
    {
      "image": "assets/images/bee.jpg",
      "name": "Bee",
      "sound": "assets/sound_names/bee.wav",
    },
    {
      "image": "assets/images/bell.jpg",
      "name": "Bell",
      "sound": "assets/sound_names/bell.wav",
    },
    {
      "image": "assets/images/bus.jpg",
      "name": "Bus",
      "sound": "assets/sound_names/bus.wav",
    },
    {
      "image": "assets/images/cat.jpg",
      "name": "Cat",
      "sound": "assets/sound_names/cat.wav",
    },
    {
      "image": "assets/images/chick.jpg",
      "name": "Chick",
      "sound": "assets/sound_names/chick.wav",
    },
    {
      "image": "assets/images/clapping.jpg",
      "name": "Clapping",
      "sound": "assets/sound_names/clapping.wav",
    },
    {
      "image": "assets/images/cow.jpg",
      "name": "Cow",
      "sound": "assets/sound_names/cow.wav",
    },
    {
      "image": "assets/images/dog.jpg",
      "name": "Dog",
      "sound": "assets/sound_names/dog.wav",
    },
    {
      "image": "assets/images/drum.jpg",
      "name": "Drum",
      "sound": "assets/sound_names/drum.wav",
    },
    {
      "image": "assets/images/duck.jpg",
      "name": "Duck",
      "sound": "assets/sound_names/duck.wav",
    },
    {
      "image": "assets/images/firetruck.jpg",
      "name": "Firetruck",
      "sound": "assets/sound_names/firetruck.wav",
    },
    {
      "image": "assets/images/fireworks.jpg",
      "name": "Fireworks",
      "sound": "assets/sound_names/fireworks.wav",
    },
    {
      "image": "assets/images/flaute.jpg",
      "name": "Flute",
      "sound": "assets/sound_names/flaute.wav",
    },
    {
      "image": "assets/images/frog.jpg",
      "name": "Frog",
      "sound": "assets/sound_names/frog.wav",
    },
    {
      "image": "assets/images/guitar.jpg",
      "name": "Guitar",
      "sound": "assets/sound_names/guitar.wav",
    },
    {
      "image": "assets/images/hen.jpg",
      "name": "Hen",
      "sound": "assets/sound_names/hen.wav",
    },
    {
      "image": "assets/images/horse.jpg",
      "name": "Horse",
      "sound": "assets/sound_names/horse.wav",
    },
    {
      "image": "assets/images/lion.jpg",
      "name": "Lion",
      "sound": "assets/sound_names/lion.wav",
    },
    {
      "image": "assets/images/owl.jpg",
      "name": "Owl",
      "sound": "assets/sound_names/owl.wav",
    },
    {
      "image": "assets/images/phone.jpg",
      "name": "Phone",
      "sound": "assets/sound_names/telephone.wav",
    },
    {
      "image": "assets/images/piano.jpg",
      "name": "Piano",
      "sound": "assets/sound_names/piano.wav",
    },
    {
      "image": "assets/images/pig.jpg",
      "name": "Pig",
      "sound": "assets/sound_names/pig.wav",
    },
    {
      "image": "assets/images/rooster.jpg",
      "name": "Rooster",
      "sound": "assets/sound_names/rooster.wav",
    },
    {
      "image": "assets/images/sheep.jpg",
      "name": "Sheep",
      "sound": "assets/sound_names/sheep.wav",
    },
    {
      "image": "assets/images/train.jpg",
      "name": "Train",
      "sound": "assets/sound_names/train.wav",
    },
    {
      "image": "assets/images/trumpet.jpg",
      "name": "Trumpet",
      "sound": "assets/sound_names/trumpet.wav",
    },
    {
      "image": "assets/images/water.jpg",
      "name": "Water",
      "sound": "assets/sound_names/water.wav",
    },
    {
      "image": "assets/images/whistle.jpg",
      "name": "Whistle",
      "sound": "assets/sound_names/whistle.wav",
    },
    {
      "image": "assets/images/xylophone.jpg",
      "name": "Xylophone",
      "sound": "assets/sound_names/xylophone.wav",
    },
  ];*/

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
