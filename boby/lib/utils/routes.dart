import 'package:get/get.dart';

import '../ui/screens/main_screen/main_screen.dart';
import '../ui/screens/setting_screen/setting_sacreen.dart';

class Routes {
  static final List<GetPage<dynamic>> routes = [
    GetPage(name: MainScreen.route, page: () => MainScreen()),
    GetPage(name: SettingScreen.route, page: () => SettingScreen()),
  ];
}
