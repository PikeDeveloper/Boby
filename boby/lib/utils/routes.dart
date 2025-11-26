import 'package:get/get.dart';

import '../ui/screens/bonus_sreen/bonus_screen.dart';
import '../ui/screens/main_screen/main_screen.dart';

class Routes {
  static final List<GetPage<dynamic>> routes = [
    GetPage(name: MainScreen.route, page: () => MainScreen()),
    GetPage(name: BonusScreen.route, page: () => const BonusScreen()),
  ];
}
