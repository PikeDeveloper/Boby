import 'package:boby/ui/screens/drag_and_drop_screen/widgets/card_sound.dart';
import 'package:boby/utils/colors.dart';
import 'package:boby/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;

    List cards = Constants.assets;
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "This screen is not a game. It is just to learn the names of some cards.",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: MyColors.darkBlue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //switchbutton stilo apple
          // CupertinoSwitch(value: false, onChanged: (value) {}),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > 710
                    ? 4
                    : width > 500
                    ? 3
                    : 2,
                childAspectRatio: 0.8, // Adjust as needed
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CardSound(
                    sound: cards[index]["sound"]!,
                    name: cards[index]["name"]!,
                    image: cards[index]["image"]!,
                    colorKey: 0,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
