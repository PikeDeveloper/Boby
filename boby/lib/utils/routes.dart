
import 'package:get/get.dart';

import '../ui/screens/main_screen/main_screen.dart';


class Routes {
  static final List<GetPage<dynamic>> routes = [
    GetPage(name: "/main_screen", page: () => const MainScreen()),
  ];
}
