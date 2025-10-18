import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:boby/services/storage_service.dart';

class AppController extends GetxController {
  //------------General------------------------------
  var currenteImage = 'assets/images/dog.jpg'.obs;
  var backGroundImage = "".obs;
  var currentPage = 0.obs;
  var cardSelected = "".obs;
  var menuOpen = false.obs;
  var celebrationVisible = false.obs; // controls celebration overlay visibility
  
  //------------Audio Player para sonidos globales------------------------------
  final AudioPlayer _menuAudioPlayer = AudioPlayer();
  
  @override
  void onInit() {
    super.onInit();
    // Cargar background persistido
    final saved = StorageService.instance.getBackground();
    if (saved != null && saved.isNotEmpty) {
      backGroundImage.value = saved;
    }
  }

  @override
  void onClose() {
    _menuAudioPlayer.dispose();
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

  Future<void> showCelebration({Duration duration = const Duration(seconds: 1)}) async {
    try {
      celebrationVisible.value = true;
      await Future.delayed(duration);
    } finally {
      celebrationVisible.value = false;
    }
  }
}
