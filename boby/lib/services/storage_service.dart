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
  static const String _kMathOpAdd = 'math_op_add';
  static const String _kMathOpSub = 'math_op_sub';
  static const String _kMathOpMul = 'math_op_mul';
  static const String _kMathOpDiv = 'math_op_div';
  static const String _kMemoryGrid = 'memory_grid'; // values: '3x3', '3x4'

  late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    instance._box = await Hive.openBox(_boxName);
    // initialize defaults if null
    instance._box.putAll({
      if (instance._box.get(_kMathOpAdd) == null) _kMathOpAdd: true,
      if (instance._box.get(_kMathOpSub) == null) _kMathOpSub: false,
      if (instance._box.get(_kMathOpMul) == null) _kMathOpMul: false,
      if (instance._box.get(_kMathOpDiv) == null) _kMathOpDiv: false,
      if (instance._box.get(_kMemoryGrid) == null) _kMemoryGrid: '3x3',
    });
  }

  String? getBackground() => _box.get(_kBackground) as String?;
  Future<void> setBackground(String path) => _box.put(_kBackground, path);

  int getMathCorrect() => (_box.get(_kMathCorrect) as int?) ?? 0;
  Future<void> incMathCorrect([int by = 1]) =>
      _box.put(_kMathCorrect, getMathCorrect() + by);
  Future<void> setMathCorrect(int value) => _box.put(_kMathCorrect, value);

  int getMathWrong() => (_box.get(_kMathWrong) as int?) ?? 0;
  Future<void> incMathWrong([int by = 1]) =>
      _box.put(_kMathWrong, getMathWrong() + by);
  Future<void> setMathWrong(int value) => _box.put(_kMathWrong, value);

  int getMathTotalAttempts() => getMathCorrect() + getMathWrong();
  
  // Memory game scores
  int getMemoryCorrect() => (_box.get('memory_correct') as int?) ?? 0;
  Future<void> incMemoryCorrect([int by = 1]) =>
      _box.put('memory_correct', getMemoryCorrect() + by);
  Future<void> setMemoryCorrect(int value) => _box.put('memory_correct', value);

  int getMemoryWrong() => (_box.get('memory_wrong') as int?) ?? 0;
  Future<void> incMemoryWrong([int by = 1]) =>
      _box.put('memory_wrong', getMemoryWrong() + by);
  Future<void> setMemoryWrong(int value) => _box.put('memory_wrong', value);

  // Sound cards game scores
  int getSoundCardsCorrect() => (_box.get('sound_cards_correct') as int?) ?? 0;
  Future<void> incSoundCardsCorrect([int by = 1]) =>
      _box.put('sound_cards_correct', getSoundCardsCorrect() + by);
  Future<void> setSoundCardsCorrect(int value) => _box.put('sound_cards_correct', value);

  int getSoundCardsWrong() => (_box.get('sound_cards_wrong') as int?) ?? 0;
  Future<void> incSoundCardsWrong([int by = 1]) =>
      _box.put('sound_cards_wrong', getSoundCardsWrong() + by);
  Future<void> setSoundCardsWrong(int value) => _box.put('sound_cards_wrong', value);

  // Word guess game scores
  int getWordGuessCorrect() => (_box.get('word_guess_correct') as int?) ?? 0;
  Future<void> incWordGuessCorrect([int by = 1]) =>
      _box.put('word_guess_correct', getWordGuessCorrect() + by);
  Future<void> setWordGuessCorrect(int value) => _box.put('word_guess_correct', value);

  int getWordGuessWrong() => (_box.get('word_guess_wrong') as int?) ?? 0;
  Future<void> incWordGuessWrong([int by = 1]) =>
      _box.put('word_guess_wrong', getWordGuessWrong() + by);
  Future<void> setWordGuessWrong(int value) => _box.put('word_guess_wrong', value);

  double getMathAverage() {
    final total = getMathTotalAttempts();
    if (total == 0) return 0;
    return getMathCorrect() / total;
  }

  int getColorsCorrect() => (_box.get(_kColorsCorrect) as int?) ?? 0;
  Future<void> incColorsCorrect([int by = 1]) =>
      _box.put(_kColorsCorrect, getColorsCorrect() + by);
  Future<void> setColorsCorrect(int value) => _box.put(_kColorsCorrect, value);

  int getNumbersCorrect() => (_box.get(_kNumbersCorrect) as int?) ?? 0;
  Future<void> incNumbersCorrect([int by = 1]) =>
      _box.put(_kNumbersCorrect, getNumbersCorrect() + by);
  Future<void> setNumbersCorrect(int value) =>
      _box.put(_kNumbersCorrect, value);

  int getThingsCorrect() => (_box.get(_kThingsCorrect) as int?) ?? 0;
  Future<void> incThingsCorrect([int by = 1]) =>
      _box.put(_kThingsCorrect, getThingsCorrect() + by);
  Future<void> setThingsCorrect(int value) => _box.put(_kThingsCorrect, value);

  int getCounter(String key) => (_box.get(key) as int?) ?? 0;
  Future<void> setCounter(String key, int value) => _box.put(key, value);
  Future<void> incCounter(String key, [int by = 1]) =>
      _box.put(key, getCounter(key) + by);

  ValueListenable<Box> listenable({List<dynamic>? keys}) =>
      _box.listenable(keys: keys);
  static String get mathCorrectKey => _kMathCorrect;
  static String get mathWrongKey => _kMathWrong;
  static String get mathOpAddKey => _kMathOpAdd;
  static String get mathOpSubKey => _kMathOpSub;
  static String get mathOpMulKey => _kMathOpMul;
  static String get mathOpDivKey => _kMathOpDiv;
  static String get memoryGridKey => _kMemoryGrid;

  bool getMathOpAdd() => (_box.get(_kMathOpAdd) as bool?) ?? true;
  Future<void> setMathOpAdd(bool v) => _box.put(_kMathOpAdd, v);
  bool getMathOpSub() => (_box.get(_kMathOpSub) as bool?) ?? false;
  Future<void> setMathOpSub(bool v) => _box.put(_kMathOpSub, v);
  bool getMathOpMul() => (_box.get(_kMathOpMul) as bool?) ?? false;
  Future<void> setMathOpMul(bool v) => _box.put(_kMathOpMul, v);
  bool getMathOpDiv() => (_box.get(_kMathOpDiv) as bool?) ?? false;
  Future<void> setMathOpDiv(bool v) => _box.put(_kMathOpDiv, v);

  String getMemoryGrid() => (_box.get(_kMemoryGrid) as String?) ?? '3x3';
  Future<void> setMemoryGrid(String value) => _box.put(_kMemoryGrid, value);
}
