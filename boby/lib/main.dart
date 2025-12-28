import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/bonus_sreen/true_or_false_bonus/true_or_false.dart';
import 'package:boby/ui/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/storage_service.dart';

import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize services
  await Get.putAsync<StorageService>(() => StorageService.init());
  Get.put(AppController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: TrueOrFalseBonusScreen.routeName,
      getPages: Routes.routes,
      theme: ThemeData(
        textTheme: GoogleFonts.comicNeueTextTheme(),
        useMaterial3: true,
      ),
    );
  }
}
