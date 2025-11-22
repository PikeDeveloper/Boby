import 'package:boby/ui/screens/setting_screen/widgets/background_settins.dart';
import 'package:boby/ui/screens/setting_screen/widgets/badge_setting.dart';
import 'package:boby/ui/screens/setting_screen/widgets/match_it.sattings.dart';
import 'package:boby/ui/screens/setting_screen/widgets/memory_settings.dart';
import 'package:boby/ui/screens/setting_screen/widgets/more_apps.dart';
import 'package:flutter/material.dart';

import '../../shared/word_of_images.dart';

class SettingScreen extends StatelessWidget {
  static const String route = '/setting_screen';
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF1E88E5),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD), // Light Blue
              Color(0xFFBBDEFB), // Blue 100
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Header
                const SizedBox(height: 10),
                const WordOfImages(letters: "SETTINGS", letterSize: 35),
                const SizedBox(height: 30),

                // Background Settings
                _buildSection(
                  title: "BACKGROUNDS",
                  content: const BackgroundSettings(),
                  color: Colors.blue,
                ),
                const SizedBox(height: 25),

                // Memory Settings
                _buildSection(
                  title: "MEMORY",
                  content: const MemrySettings(),
                  color: Colors.purple,
                ),
                const SizedBox(height: 25),

                // Match Settings
                _buildSection(
                  title: "MATCH",
                  content: const MatchItSettings(),
                  color: Colors.orange,
                ),
                const SizedBox(height: 25),

                // Badge Settings
                _buildSection(
                  title: "BADGE",
                  content: const BadgeSettings(),
                  color: Colors.green,
                ),
                const SizedBox(height: 25),

                // More Apps
                _buildSection(
                  title: "MORE",
                  content: const MoreApps(),
                  color: Colors.pink,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // Section Content
          Padding(padding: const EdgeInsets.all(20), child: content),
        ],
      ),
    );
  }
}
