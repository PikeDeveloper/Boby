import 'package:boby/ui/screens/bonus_sreen/complete_sentence/complete_sentence.dart';
import 'package:boby/ui/screens/bonus_sreen/match_it/match_it.dart';
import 'package:boby/ui/screens/bonus_sreen/to_be_bonus_screen/to_be_bonus_screen.dart';
import 'package:boby/ui/screens/bonus_sreen/true_or_false_bonus/true_or_false.dart';
import 'package:boby/ui/screens/tales_scrren/tales.dart';
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
    GetPage(name: CompleteSentence.route, page: () => const CompleteSentence()),
    GetPage(name: ToBeBonusScreen.routeName, page: () => ToBeBonusScreen()),
    GetPage(
      name: TrueOrFalseBonusScreen.routeName,
      page: () => TrueOrFalseBonusScreen(),
    ),
  ];
}
