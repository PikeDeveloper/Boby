import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/storage_service.dart';
import 'services/firebase_service.dart';
import 'services/daily_report_service.dart';

import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase (try-catch to handle when not configured yet)
  try {
    await FirebaseService().initialize();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
    print('This is expected if Firebase is not properly configured');
  }

  // Initialize services
  await Get.putAsync<StorageService>(() => StorageService.init());
  Get.put(AppController());

  // Check and send daily progress report to parent (non-blocking)
  DailyReportService.checkAndSendDailyReport();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: MainScreen.route,
      getPages: Routes.routes,
      theme: ThemeData(
        textTheme: GoogleFonts.comicNeueTextTheme(),
        useMaterial3: true,
      ),
    );
  }
}
