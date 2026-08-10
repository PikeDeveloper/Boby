import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/services/firebase_service.dart';
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
  
  // Firebase Stats Tracking
  var currentChildId = "".obs;
  var currentChildName = "".obs;
  var currentParentEmail = "".obs;
  var firebaseEnabled = false.obs;

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
    Random rng = Random();
    if (bonusScreen.value <= 4) {
      bonusScreen.value = rng.nextInt(5);
    } else {
      bonusScreen.value = rng.nextInt(10);
    }
  }
  
  // Firebase Stats Tracking Methods
  void setupChildProfile(String childId, String childName, String parentEmail) {
    currentChildId.value = childId;
    currentChildName.value = childName;
    currentParentEmail.value = parentEmail;
    firebaseEnabled.value = true;
    
    // Guardar en storage local
    StorageService.instance.saveChildProfile(childId, childName, parentEmail);
  }
  
  Future<void> trackWordLearned(int count) async {
    if (!firebaseEnabled.value || currentChildId.value.isEmpty) return;
    
    try {
      await FirebaseService().updateStats(
        currentChildId.value,
        wordsLearned: count,
      );
    } catch (e) {
      debugPrint('Error tracking word learned: $e');
    }
  }
  
  Future<void> trackLevelCompleted(String gameType, String newLevel) async {
    if (!firebaseEnabled.value || currentChildId.value.isEmpty) return;
    
    try {
      await FirebaseService().updateStats(
        currentChildId.value,
        levelsCompleted: 1,
        currentLevel: newLevel,
      );
      
      // Also track game-specific progress
      await FirebaseService().updateStats(
        currentChildId.value,
      );
    } catch (e) {
      debugPrint('Error tracking level completed: $e');
    }
  }
  
  Future<void> trackScore(int score) async {
    if (!firebaseEnabled.value || currentChildId.value.isEmpty) return;
    
    try {
      await FirebaseService().updateStats(
        currentChildId.value,
        score: score,
      );
    } catch (e) {
      debugPrint('Error tracking score: $e');
    }
  }
  
  Future<void> trackAchievement(String achievement) async {
    if (!firebaseEnabled.value || currentChildId.value.isEmpty) return;
    
    try {
      // This would need to be implemented in FirebaseService
      // For now, we'll just log it
      debugPrint('Achievement unlocked: $achievement');
    } catch (e) {
      debugPrint('Error tracking achievement: $e');
    }
  }
  
  void loadChildProfile() {
    final profile = StorageService.instance.getChildProfile();
    if (profile != null) {
      currentChildId.value = profile['childId'] ?? '';
      currentChildName.value = profile['childName'] ?? '';
      currentParentEmail.value = profile['parentEmail'] ?? '';
      firebaseEnabled.value = profile['childId'] != null && profile['childId']!.isNotEmpty;
    }
  }
}
