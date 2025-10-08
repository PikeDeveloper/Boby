import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          appController.backGroundImage.value == ""
              ? "assets/backgrounds/sabana.jpg"
              : appController.backGroundImage.value,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
