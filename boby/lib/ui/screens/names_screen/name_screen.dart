import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/drag_and_drop_screen/widgets/card_sound.dart';
import 'package:boby/ui/shared/word_of_images.dart';
import 'package:get/get.dart';
import 'package:boby/utils/colors.dart';
import 'package:boby/utils/constants.dart';
import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List cards = Constants.assets;
    List colors = [
      MyColors.yellow,
      MyColors.purple,
      MyColors.lightPurple,
      MyColors.red,
      MyColors.green,
      MyColors.blue,
      MyColors.darkBlue,
    ];
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Listen to some names in English.",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: MyColors.darkBlue,
                ),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          child: Row(
            children: [
              const SizedBox(height: 20),
              //crea un grid con las c
              GridView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return CardSound(
                    sound: cards[index]["sound"]!,
                    name: cards[index]["name"]!,
                    image: cards[index]["image"]!,
                    colorKey: 0,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
