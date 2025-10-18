import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const String _boxName = 'app';
  static const String _kBackground = 'background';
  static const String _kMathCorrect = 'math_correct';
  static const String _kMathWrong = 'math_wrong';
  static const String _kColorsCorrect = 'colors_correct';
  static const String _kNumbersCorrect = 'numbers_correct';
  static const String _kThingsCorrect = 'things_correct';

  late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    instance._box = await Hive.openBox(_boxName);
  }

  String? getBackground() => _box.get(_kBackground) as String?;
  Future<void> setBackground(String path) => _box.put(_kBackground, path);

  int getMathCorrect() => (_box.get(_kMathCorrect) as int?) ?? 0;
  Future<void> incMathCorrect([int by = 1]) => _box.put(_kMathCorrect, getMathCorrect() + by);
  Future<void> setMathCorrect(int value) => _box.put(_kMathCorrect, value);

  int getMathWrong() => (_box.get(_kMathWrong) as int?) ?? 0;
  Future<void> incMathWrong([int by = 1]) => _box.put(_kMathWrong, getMathWrong() + by);
  Future<void> setMathWrong(int value) => _box.put(_kMathWrong, value);

  int getMathTotalAttempts() => getMathCorrect() + getMathWrong();
  double getMathAverage() {
    final total = getMathTotalAttempts();
    if (total == 0) return 0;
    return getMathCorrect() / total;
  }

  int getColorsCorrect() => (_box.get(_kColorsCorrect) as int?) ?? 0;
  Future<void> incColorsCorrect([int by = 1]) => _box.put(_kColorsCorrect, getColorsCorrect() + by);
  Future<void> setColorsCorrect(int value) => _box.put(_kColorsCorrect, value);

  int getNumbersCorrect() => (_box.get(_kNumbersCorrect) as int?) ?? 0;
  Future<void> incNumbersCorrect([int by = 1]) => _box.put(_kNumbersCorrect, getNumbersCorrect() + by);
  Future<void> setNumbersCorrect(int value) => _box.put(_kNumbersCorrect, value);

  int getThingsCorrect() => (_box.get(_kThingsCorrect) as int?) ?? 0;
  Future<void> incThingsCorrect([int by = 1]) => _box.put(_kThingsCorrect, getThingsCorrect() + by);
  Future<void> setThingsCorrect(int value) => _box.put(_kThingsCorrect, value);

  int getCounter(String key) => (_box.get(key) as int?) ?? 0;
  Future<void> setCounter(String key, int value) => _box.put(key, value);
  Future<void> incCounter(String key, [int by = 1]) => _box.put(key, getCounter(key) + by);

  ValueListenable<Box> listenable({List<dynamic>? keys}) => _box.listenable(keys: keys);
  static String get mathCorrectKey => _kMathCorrect;
  static String get mathWrongKey => _kMathWrong;
}
