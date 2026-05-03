import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/main_screen/main_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/storage_service.dart';

import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize services
  await Get.putAsync<StorageService>(() => StorageService.init());
  Get.put(AppController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boby - Learn English',
      initialRoute: MainScreen.route,
      getPages: Routes.routes,
      navigatorObservers: [observer],
      theme: ThemeData(
        textTheme: GoogleFonts.comicNeueTextTheme(),
        useMaterial3: true,
      ),
    );
  }
}
