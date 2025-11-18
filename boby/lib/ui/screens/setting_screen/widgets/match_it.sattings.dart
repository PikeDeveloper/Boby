import 'package:get/get.dart';
import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';

class MatchItSettings extends StatelessWidget {
  const MatchItSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final String objetImagePath =  "assets/images/apple.jpg";
    final String numberImagePath = "assets/numbers/1.png";
    final String colorImagePath = "assets/shapes/shape_1.png";
    
    
    
    return Obx(() => Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => appController.enableObjects.value = !appController.enableObjects.value,
              child: Container(
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.indigo),
                  color: const Color.fromARGB(207, 255, 255, 255).withValues(alpha: 0.5),
                ),
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IgnorePointer(
                      child: Checkbox(
                        value: appController.enableObjects.value,
                        onChanged: (_) {},
                        activeColor: Colors.indigo,
                        checkColor: Colors.white,
                        
                        side: const BorderSide(color: Colors.indigo),
                      ),
                    ),
                    ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.asset(objetImagePath, width: 40, height: 32)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => appController.enableNumbers.value = !appController.enableNumbers.value,
              child: Container(
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.indigo),
                  color: const Color.fromARGB(207, 255, 255, 255).withValues(alpha: 0.5),
                ),
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IgnorePointer(
                      child: Checkbox(
                        value: appController.enableNumbers.value,
                        onChanged: (_) {},
                        activeColor: Colors.indigo,
                        checkColor: Colors.white,
                     
                        side: const BorderSide(color: Colors.indigo),
                      ),
                    ),
                    Image.asset(numberImagePath, width: 40, height: 32),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => appController.enableColors.value = !appController.enableColors.value,
              child: Container(
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.indigo),
                  color: const Color.fromARGB(207, 255, 255, 255).withValues(alpha: 0.5),
                ),
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IgnorePointer(
                      child: Checkbox(
                        value: appController.enableColors.value,
                        onChanged: (_) {},
                        activeColor: Colors.indigo,
                        checkColor: Colors.white,
                        
                        side: const BorderSide(color: Colors.indigo),
                      ),
                    ),
                    Image.asset(colorImagePath, width: 40, height: 32),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}