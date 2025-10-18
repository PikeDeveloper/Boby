import 'dart:io';

class Constants {
  static  late Directory appDocsDir;
  static const int cellPhoneSize = 500;
  static const int tabletSize = 750;
  static const int desktopSize = 1200;
  static const String appName = "Fish";


    static const List<Map<String, String>> assets = [
   
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
      "image": "assets/images/flute.jpg",
      "name": "Flute",
      "sound": "assets/sound_names/flute.wav",
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
      "sound": "assets/sound_names/phone.wav",
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
      "image": "assets/images/airplane.jpg",
      "name": "Airplane",
      "sound": "assets/sound_names/airplane.wav",
    },
    {
      "image": "assets/images/apple.jpg",
      "name": "Apple",
      "sound": "assets/sound_names/apple.wav",
    },
    {
      "image": "assets/images/ball.jpg",
      "name": "Ball",
      "sound": "assets/sound_names/ball.wav",
    },
    {
      "image": "assets/images/banana.jpg",
      "name": "Banana",
      "sound": "assets/sound_names/banana.wav",
    },
    {
      "image": "assets/images/bed.jpg",
      "name": "Bed",
      "sound": "assets/sound_names/bed.wav",
    },
    {
      "image": "assets/images/bicycle.jpg",
      "name": "Bicycle",
      "sound": "assets/sound_names/bicycle.wav",
    },
    {
      "image": "assets/images/bird.jpg",
      "name": "Bird",
      "sound": "assets/sound_names/bird.wav",
    },
    {
      "image": "assets/images/book.jpg",
      "name": "Book",
      "sound": "assets/sound_names/book.wav",
    },
    {
      "image": "assets/images/boy.jpg",
      "name": "Boy",
      "sound": "assets/sound_names/boy.wav",
    },
    {
      "image": "assets/images/bread.jpg",
      "name": "Bread",
      "sound": "assets/sound_names/bread.wav",
    },
    {
      "image": "assets/images/car.jpg",
      "name": "Car",
      "sound": "assets/sound_names/car.wav",
    },
    {
      "image": "assets/images/chair.jpg",
      "name": "Chair",
      "sound": "assets/sound_names/chair.wav",
    },
    {
      "image": "assets/images/cherry.jpg",
      "name": "Cherry",
      "sound": "assets/sound_names/cherry.wav",
    },
   
    {
      "image": "assets/images/cloud.jpg",
      "name": "Cloud",
      "sound": "assets/sound_names/cloud.wav",
    },
    {
      "image": "assets/images/cup.jpg",
      "name": "Cup",
      "sound": "assets/sound_names/cup.wav",
    },
    {
      "image": "assets/images/door.jpg",
      "name": "Door",
      "sound": "assets/sound_names/door.wav",
    },
    {
      "image": "assets/images/egg.jpg",
      "name": "Egg",
      "sound": "assets/sound_names/egg.wav",
    },
    {
      "image": "assets/images/elephant.jpg",
      "name": "Elephant",
      "sound": "assets/sound_names/elephant.wav",
    },
    {
      "image": "assets/images/eye.jpg",
      "name": "Eye",
      "sound": "assets/sound_names/eye.wav",
    },
     
    {
      "image": "assets/images/fish.jpg",
      "name": "Fish",
      "sound": "assets/sound_names/fish.wav",
    },
    {
      "image": "assets/images/flower.jpg",
      "name": "Flower",
      "sound": "assets/sound_names/flower.wav",
    },
    {
      "image": "assets/images/foot.jpg",
      "name": "Foot",
      "sound": "assets/sound_names/foot.wav",
    },
    {
      "image": "assets/images/girl.jpg",
      "name": "Girl",
      "sound": "assets/sound_names/girl.wav",
    },
    {
      "image": "assets/images/grapes.jpg",
      "name": "Grapes",
      "sound": "assets/sound_names/grapes.wav",
    },
    {
      "image": "assets/images/hand.jpg",
      "name": "Hand",
      "sound": "assets/sound_names/hand.wav",
    },
    {
      "image": "assets/images/milk.jpg",
      "name": "Milk",
      "sound": "assets/sound_names/milk.wav",
    },
    {
      "image": "assets/images/moon.jpg",
      "name": "Moon",
      "sound": "assets/sound_names/moon.wav",
    },
 
    {
      "image": "assets/images/orange.jpg",
      "name": "Orange",
      "sound": "assets/sound_names/orange.wav",
    },
    {
      "image": "assets/images/pear.jpg",
      "name": "Pear",
      "sound": "assets/sound_names/pear.wav",
    },
    {
      "image": "assets/images/rain.jpg",
      "name": "Rain",
      "sound": "assets/sound_names/rain.wav",
    },
    {
      "image": "assets/images/rice.jpg",
      "name": "Rice",
      "sound": "assets/sound_names/rice.wav",
    },
  
    {
      "image": "assets/images/sun.jpg",
      "name": "Sun",
      "sound": "assets/sound_names/sun.wav",
    },
    {
      "image": "assets/images/table.jpg",
      "name": "Table",
      "sound": "assets/sound_names/table.wav",
    },
    {
      "image": "assets/images/tree.jpg",
      "name": "Tree",
      "sound": "assets/sound_names/tree.wav",
    },
    {
      "image": "assets/images/watermelon.jpg",
      "name": "Watermelon",
      "sound": "assets/sound_names/watermelon.wav",
    },
   
  
  ];

}
