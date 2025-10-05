import 'package:flutter/material.dart';

import 'card_sound.dart';



class ListCardSounds extends StatelessWidget {
  ListCardSounds({super.key});

  final List<Map<String, String>> assets = [
    {
      "image": "assets/images/accordion-DmBcPgLC.jpg",
      "name": "Accordion",
      "sound": "assets/sounds/accordion.mp3",
    },
    {
      "image": "assets/images/bee.jpg",
      "name": "Bee",
      "sound": "assets/sounds/bee.mp3",
    },
    {
      "image": "assets/images/bell.jpg",
      "name": "Bell",
      "sound": "assets/sounds/bell.mp3",
    },
    {
      "image": "assets/images/bus.jpg",
      "name": "Bus",
      "sound": "assets/sounds/bus.mp3",
    },
    {
      "image": "assets/images/cat.jpg",
      "name": "Cat",
      "sound": "assets/sounds/cat.mp3",
    },
    {
      "image": "assets/images/chick.jpg",
      "name": "Chick",
      "sound": "assets/sounds/chick.mp3",
    },
    {
      "image": "assets/images/clapping.jpg",
      "name": "Clapping",
      "sound": "assets/sounds/clapping.mp3",
    },
    {
      "image": "assets/images/cow.jpg",
      "name": "Cow",
      "sound": "assets/sounds/cow.mp3",
    },
    {
      "image": "assets/images/dog.jpg",
      "name": "Dog",
      "sound": "assets/sounds/dog.mp3",
    },
    {
      "image": "assets/images/drum.jpg",
      "name": "Drum",
      "sound": "assets/sounds/drum.mp3",
    },
    {
      "image": "assets/images/duck.jpg",
      "name": "Duck",
      "sound": "assets/sounds/duck.mp3",
    },
    {
      "image": "assets/images/firetruck.jpg",
      "name": "Firetruck",
      "sound": "assets/sounds/firetruck.mp3",
    },
    {
      "image": "assets/images/fireworks.jpg",
      "name": "Fireworks",
      "sound": "assets/sounds/fireworks.mp3",
    },
    {
      "image": "assets/images/flute.jpg",
      "name": "Flute",
      "sound": "assets/sounds/flute.mp3",
    },
    {
      "image": "assets/images/frog.jpg",
      "name": "Frog",
      "sound": "assets/sounds/frog.mp3",
    },
    {
      "image": "assets/images/guitar.jpg",
      "name": "Guitar",
      "sound": "assets/sounds/guitar.mp3",
    },
    {
      "image": "assets/images/hen.jpg",
      "name": "Hen",
      "sound": "assets/sounds/hen.mp3",
    },
    {
      "image": "assets/images/horse.jpg",
      "name": "Horse",
      "sound": "assets/sounds/horse.mp3",
    },
    {
      "image": "assets/images/lion.jpg",
      "name": "Lion",
      "sound": "assets/sounds/lion.mp3",
    },
    {
      "image": "assets/images/owl.jpg",
      "name": "Owl",
      "sound": "assets/sounds/owl.mp3",
    },
    {
      "image": "assets/images/phone.jpg",
      "name": "Phone",
      "sound": "assets/sounds/phone.mp3",
    },
    {
      "image": "assets/images/piano.jpg",
      "name": "Piano",
      "sound": "assets/sounds/piano.mp3",
    },
    {
      "image": "assets/images/pig.jpg",
      "name": "Pig",
      "sound": "assets/sounds/pig.mp3",
    },
    {
      "image": "assets/images/rooster.jpg",
      "name": "Rooster",
      "sound": "assets/sounds/rooster.mp3",
    },
    {
      "image": "assets/images/sheep.jpg",
      "name": "Sheep",
      "sound": "assets/sounds/sheep.mp3",
    },
    {
      "image": "assets/images/train.jpg",
      "name": "Train",
      "sound": "assets/sounds/train.mp3",
    },
    {
      "image": "assets/images/trumpet.jpg",
      "name": "Trumpet",
      "sound": "assets/sounds/trumpet.mp3",
    },
    {
      "image": "assets/images/water.jpg",
      "name": "Water",
      "sound": "assets/sounds/water.mp3",
    },
    {
      "image": "assets/images/whistle.jpg",
      "name": "Whistle",
      "sound": "assets/sounds/whistle.mp3",
    },
    {
      "image": "assets/images/xylophone.jpg",
      "name": "Xylophone",
      "sound": "assets/sounds/xylophone.mp3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return CardSound(
          image: assets[index]["image"]!,
          name: assets[index]["name"]!,
          sound: assets[index]["sound"]!,
          onPressed: () {},
        );
      },
    );
  }
}