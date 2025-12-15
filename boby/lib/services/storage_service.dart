import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService extends GetxService {
  static Future<StorageService> init() async {
    final instance = StorageService._();
    await instance._init();
    return instance;
  }

  StorageService._();

  static StorageService get instance => Get.find<StorageService>();

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
  static const String _kScrambleLevel =
      'scramble_level'; // values: 'easy', 'medium', 'hard'

  late Box _box;

  Future<void> _init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    // initialize defaults if null
    _box.putAll({
      if (_box.get(_kMathOpAdd) == null) _kMathOpAdd: true,
      if (_box.get(_kMathOpSub) == null) _kMathOpSub: false,
      if (_box.get(_kMathOpMul) == null) _kMathOpMul: false,
      if (_box.get(_kMathOpDiv) == null) _kMathOpDiv: false,
      if (_box.get(_kMemoryGrid) == null) _kMemoryGrid: '3x3',
      if (_box.get(_kScrambleLevel) == null) _kScrambleLevel: 'easy',
    });

    // Initialize reactive variables
    talesCorrect.value = getTalesCorrect();
    talesWrong.value = getTalesWrong();
    scrambleWordCorrect.value = getScrambleWordCorrect();
    scrambleWordWrong.value = getScrambleWordWrong();
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
  // Make sound cards scores reactive
  RxInt get soundCardsCorrect =>
      (_box.get('sound_cards_correct') as int? ?? 0).obs;
  RxInt get soundCardsWrong => (_box.get('sound_cards_wrong') as int? ?? 0).obs;

  Future<void> setSoundCardsCorrect(int value) async {
    await _box.put('sound_cards_correct', value);
    soundCardsCorrect.value = value;
  }

  // Match It game scores
  int getMatchItCorrect() => (_box.get('match_it_correct') as int?) ?? 0;
  Future<void> incMatchItCorrect([int by = 1]) =>
      _box.put('match_it_correct', getMatchItCorrect() + by);
  Future<void> setMatchItCorrect(int value) =>
      _box.put('match_it_correct', value);

  int getMatchItWrong() => (_box.get('match_it_wrong') as int?) ?? 0;
  Future<void> incMatchItWrong([int by = 1]) =>
      _box.put('match_it_wrong', getMatchItWrong() + by);
  Future<void> setMatchItWrong(int value) => _box.put('match_it_wrong', value);

  int getSoundCardsWrong() => (_box.get('sound_cards_wrong') as int?) ?? 0;

  Future<void> setSoundCardsWrong(int value) async {
    await _box.put('sound_cards_wrong', value);
    soundCardsWrong.value = value;
  }

  Future<void> incSoundCardsWrong([int by = 1]) async {
    final newValue = getSoundCardsWrong() + by;
    await _box.put('sound_cards_wrong', newValue);
    soundCardsWrong.value = newValue;
  }

  // Word guess game scores
  int getWordGuessCorrect() => (_box.get('word_guess_correct') as int?) ?? 0;
  Future<void> incWordGuessCorrect([int by = 1]) =>
      _box.put('word_guess_correct', getWordGuessCorrect() + by);
  Future<void> setWordGuessCorrect(int value) =>
      _box.put('word_guess_correct', value);

  // Tales game scores
  int getTalesCorrect() => (_box.get('tales_correct') as int?) ?? 0;
  final talesCorrect = 0.obs;
  Future<void> incTalesCorrect([int by = 1]) async {
    final newValue = getTalesCorrect() + by;
    await _box.put('tales_correct', newValue);
    talesCorrect.value = newValue;
  }

  Future<void> setTalesCorrect(int value) async {
    await _box.put('tales_correct', value);
    talesCorrect.value = value;
  }

  int getTalesWrong() => (_box.get('tales_wrong') as int?) ?? 0;
  final talesWrong = 0.obs;
  Future<void> incTalesWrong([int by = 1]) async {
    final newValue = getTalesWrong() + by;
    await _box.put('tales_wrong', newValue);
    talesWrong.value = newValue;
  }

  Future<void> setTalesWrong(int value) async {
    await _box.put('tales_wrong', value);
    talesWrong.value = value;
  }

  int getWordGuessWrong() => (_box.get('word_guess_wrong') as int?) ?? 0;
  Future<void> incWordGuessWrong([int by = 1]) =>
      _box.put('word_guess_wrong', getWordGuessWrong() + by);
  Future<void> setWordGuessWrong(int value) =>
      _box.put('word_guess_wrong', value);

  // Scramble Word game scores
  int getScrambleWordCorrect() =>
      (_box.get('scramble_word_correct') as int?) ?? 0;
  final scrambleWordCorrect = 0.obs;
  Future<void> incScrambleWordCorrect([int by = 1]) async {
    final newValue = getScrambleWordCorrect() + by;
    await _box.put('scramble_word_correct', newValue);
    scrambleWordCorrect.value = newValue;
  }

  Future<void> setScrambleWordCorrect(int value) async {
    await _box.put('scramble_word_correct', value);
    scrambleWordCorrect.value = value;
  }

  int getScrambleWordWrong() => (_box.get('scramble_word_wrong') as int?) ?? 0;
  final scrambleWordWrong = 0.obs;
  Future<void> incScrambleWordWrong([int by = 1]) async {
    final newValue = getScrambleWordWrong() + by;
    await _box.put('scramble_word_wrong', newValue);
    scrambleWordWrong.value = newValue;
  }

  Future<void> setScrambleWordWrong(int value) async {
    await _box.put('scramble_word_wrong', value);
    scrambleWordWrong.value = value;
  }

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

  String getScrambleLevel() =>
      (_box.get(_kScrambleLevel) as String?) ?? 'medium';
  Future<void> setScrambleLevel(String value) =>
      _box.put(_kScrambleLevel, value);
  static String get scrambleLevelKey => _kScrambleLevel;
}
