import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/bonus_sreen/to_be_bonus_screen/to_be_bonus_screen.dart';
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
      initialRoute: ToBeBonusScreen.routeName,
      getPages: Routes.routes,
      theme: ThemeData(
        textTheme: GoogleFonts.comicNeueTextTheme(),
        useMaterial3: true,
      ),
    );
  }
}
