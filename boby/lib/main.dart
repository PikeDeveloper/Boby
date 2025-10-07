import 'package:boby/ui/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return      GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: MainScreen.route,
      getPages: Routes.routes,


    );
  }
}
