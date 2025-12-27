import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:boby/services/storage_service.dart';
import 'dart:math';

class AppController extends GetxController {
  //------------General------------------------------

  var backGroundImage = "".obs;
  var currentPage = 4.obs;
  var cardSelected = "".obs;
  var bonusScreen = 7.obs;
  var gameSelected = "DragAndDrop".obs;
  var menuOpen = false.obs;
  var celebrationVisible = false.obs; // controls celebration overlay visibility
  var isTrainingMode = false.obs;

  // Tales Randomization
  final List<int> _availableTalesIndices = [];

  //---------noShow------------------------------
  var noShow = "no".obs;

  //------------MatchIt settings flags------------------------------
  // Control which types of rounds are enabled in MatchItScreen
  var enableNumbers = true.obs;
  var enableColors = true.obs; // color matching round (shape+color)
  var enableObjects = true.obs; // figures from Constants.assets

  //------------Audio Players------------------------------
  final AudioPlayer _menuAudioPlayer = AudioPlayer();
  final AudioPlayer _gameAudioPlayer = AudioPlayer();

  // Sound paths
  final String winSound = "assets/sounds/winner-game.wav";
  final String bubblePopSound = "assets/sounds/bubble-pop.wav";
  final String gameBonusSound = "assets/sounds/game-bonus.wav";
  final String gameOverSound = "assets/sounds/game-over-trombone.wav";

  @override
  void onInit() {
    super.onInit();
    // Cargar background persistido
    final saved = StorageService.instance.getBackground();
    if (saved != null && saved.isNotEmpty) {
      backGroundImage.value = saved;
    }
    // Cargar scramble level persistido
    scrableLevel.value = StorageService.instance.getScrambleLevel();
  }

  @override
  void onClose() {
    _menuAudioPlayer.dispose();
    _gameAudioPlayer.dispose();
    super.onClose();
  }

  Future<void> playMenuSound(String soundPath) async {
    try {
      if (!Platform.isLinux) {
        debugPrint('Loading menu sound: $soundPath');
        await _menuAudioPlayer.setAsset(soundPath);
        debugPrint('Playing menu sound...');
        _menuAudioPlayer.play();
        debugPrint('Menu sound started playing');
      } else {
        debugPrint('Audio disabled on Linux');
      }
    } catch (e) {
      debugPrint('Error playing menu sound: $e');
    }
  }

  Future<void> showCelebration({
    Duration duration = const Duration(seconds: 1),
  }) async {
    try {
      celebrationVisible.value = true;
      await Future.delayed(duration);
    } finally {
      celebrationVisible.value = false;
    }
  }

  // Play game sound effects
  Future<void> playGameSound(String soundPath) async {
    try {
      if (Platform.isLinux) {
        debugPrint('Audio disabled on Linux');
        return;
      }

      await _gameAudioPlayer.stop();
      await _gameAudioPlayer.setAsset(soundPath);
      await _gameAudioPlayer.setVolume(1.0);
      await _gameAudioPlayer.play();
    } catch (e) {
      debugPrint('Error playing game sound: $e');
    }
  }

  // Play card tap sound
  Future<void> playCardTap(String soundPath) async {
    await playGameSound(soundPath);
  }

  // Play win sound
  Future<void> playWinSound() async {
    await playGameSound(winSound);
  }

  // Play bubble pop sound
  Future<void> playBubblePop() async {
    await playGameSound(bubblePopSound);
  }

  // Play game bonus sound
  Future<void> playGameBonus() async {
    await playGameSound(gameBonusSound);
  }

  // Play game over sound
  Future<void> playGameOver() async {
    await playGameSound(gameOverSound);
  }

  //scrable settings
  var scrableLevel = "medium".obs;

  int getNextTaleIndex(int totalTales) {
    if (_availableTalesIndices.isEmpty) {
      _availableTalesIndices.addAll(
        List.generate(totalTales, (index) => index),
      );
      _availableTalesIndices.shuffle();
    }
    return _availableTalesIndices.removeLast();
  }

  //functions for bonus screen
  //esta funcion guarda en bonusScreen un numero aleatorio entre 0 y 6
  void setBonusScreen() {
    Random _rng = Random();
    if (bonusScreen.value <= 3) {
      bonusScreen.value = _rng.nextInt(4);
    } else {
      bonusScreen.value = _rng.nextInt(10);
    }
  }
}
