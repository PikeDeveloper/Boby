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
      "image": "assets/images/airplane.jpg",
      "name": "Airplane",
      "sound": "assets/sounds/airplane.wav",
    },
    {
      "image": "assets/images/apple.jpg",
      "name": "Apple",
      "sound": "assets/sounds/apple.wav",
    },
    {
      "image": "assets/images/ball.jpg",
      "name": "Ball",
      "sound": "assets/sounds/ball.wav",
    },
    {
      "image": "assets/images/banana.jpg",
      "name": "Banana",
      "sound": "assets/sounds/banana.wav",
    },
    {
      "image": "assets/images/bed.jpg",
      "name": "Bed",
      "sound": "assets/sounds/bed.wav",
    },
    {
      "image": "assets/images/bicycle.jpg",
      "name": "Bicycle",
      "sound": "assets/sounds/bicycle.wav",
    },
    {
      "image": "assets/images/bird.jpg",
      "name": "Bird",
      "sound": "assets/sounds/bird.wav",
    },
    {
      "image": "assets/images/book.jpg",
      "name": "Book",
      "sound": "assets/sounds/book.wav",
    },
    {
      "image": "assets/images/boy.jpg",
      "name": "Boy",
      "sound": "assets/sounds/boy.wav",
    },
    {
      "image": "assets/images/bread.jpg",
      "name": "Bread",
      "sound": "assets/sounds/bread.wav",
    },
    {
      "image": "assets/images/car.jpg",
      "name": "Car",
      "sound": "assets/sounds/car.wav",
    },
    {
      "image": "assets/images/chair.jpg",
      "name": "Chair",
      "sound": "assets/sounds/chair.wav",
    },
    {
      "image": "assets/images/cherry.jpg",
      "name": "Cherry",
      "sound": "assets/sounds/cherry.wav",
    },
   
    {
      "image": "assets/images/cloud.jpg",
      "name": "Cloud",
      "sound": "assets/sounds/cloud.wav",
    },
    {
      "image": "assets/images/cup.jpg",
      "name": "Cup",
      "sound": "assets/sounds/cup.wav",
    },
    {
      "image": "assets/images/door.jpg",
      "name": "Door",
      "sound": "assets/sounds/door.wav",
    },
    {
      "image": "assets/images/egg.jpg",
      "name": "Egg",
      "sound": "assets/sounds/egg.wav",
    },
    {
      "image": "assets/images/elephant.jpg",
      "name": "Elephant",
      "sound": "assets/sounds/elephant.wav",
    },
    {
      "image": "assets/images/eye.jpg",
      "name": "Eye",
      "sound": "assets/sounds/eye.wav",
    },
     
    {
      "image": "assets/images/fish.jpg",
      "name": "Fish",
      "sound": "assets/sounds/fish.wav",
    },
    {
      "image": "assets/images/flower.jpg",
      "name": "Flower",
      "sound": "assets/sounds/flower.wav",
    },
    {
      "image": "assets/images/foot.jpg",
      "name": "Foot",
      "sound": "assets/sounds/foot.wav",
    },
    {
      "image": "assets/images/girl.jpg",
      "name": "Girl",
      "sound": "assets/sounds/girl.wav",
    },
    {
      "image": "assets/images/grapes.jpg",
      "name": "Grapes",
      "sound": "assets/sounds/grapes.wav",
    },
    {
      "image": "assets/images/hand.jpg",
      "name": "Hand",
      "sound": "assets/sounds/hand.wav",
    },
    {
      "image": "assets/images/milk.jpg",
      "name": "Milk",
      "sound": "assets/sounds/milk.wav",
    },
    {
      "image": "assets/images/moon.jpg",
      "name": "Moon",
      "sound": "assets/sounds/moon.wav",
    },
 
    {
      "image": "assets/images/orange.jpg",
      "name": "Orange",
      "sound": "assets/sounds/orange.wav",
    },
    {
      "image": "assets/images/pear.jpg",
      "name": "Pear",
      "sound": "assets/sounds/pear.wav",
    },
    {
      "image": "assets/images/rain.jpg",
      "name": "Rain",
      "sound": "assets/sounds/rain.wav",
    },
    {
      "image": "assets/images/rice.jpg",
      "name": "Rice",
      "sound": "assets/sounds/rice.wav",
    },
  
    {
      "image": "assets/images/sun.jpg",
      "name": "Sun",
      "sound": "assets/sounds/sun.wav",
    },
    {
      "image": "assets/images/table.jpg",
      "name": "Table",
      "sound": "assets/sounds/table.wav",
    },
    {
      "image": "assets/images/tree.jpg",
      "name": "Tree",
      "sound": "assets/sounds/tree.wav",
    },
    {
      "image": "assets/images/watermelon.jpg",
      "name": "Watermelon",
      "sound": "assets/sounds/watermelon.wav",
    },
   
  
  ];

}
