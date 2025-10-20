import 'package:boby/controllers/app_controller.dart';
import 'package:boby/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boby/services/storage_service.dart';

class BackgroundCard extends StatelessWidget {
  const BackgroundCard({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(
      () => GestureDetector(
        onTap: () {
          appController.backGroundImage.value = image;
          StorageService.instance.setBackground(image);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: appController.backGroundImage.value == image
                  ? MyColors.green
                  : Colors.white,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(image, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
