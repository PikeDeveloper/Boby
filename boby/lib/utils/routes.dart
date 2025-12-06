import 'package:boby/ui/screens/bonus_sreen/match_it/match_it.dart';
import 'package:boby/ui/screens/bonus_sreen/to_be_bonus_screen/to_be_bonus_screen.dart';
import 'package:get/get.dart';

import '../ui/screens/bonus_sreen/float_words/bonus_screen.dart';
import '../ui/screens/main_screen/main_screen.dart';

class Routes {
  static final List<GetPage<dynamic>> routes = [
    GetPage(name: MainScreen.route, page: () => MainScreen()),
    GetPage(
      name: BonusScreenFloatWords.route,
      page: () => const BonusScreenFloatWords(),
    ),
    GetPage(name: MatchItScreen.route, page: () => const MatchItScreen()),
    GetPage(name: ToBeBonusScreen.routeName, page: () => ToBeBonusScreen()),
  ];
}
