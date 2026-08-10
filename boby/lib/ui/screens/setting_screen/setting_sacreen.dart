import 'package:boby/ui/screens/setting_screen/widgets/background_settins.dart';
import 'package:boby/ui/screens/setting_screen/widgets/badge_setting.dart';
import 'package:boby/ui/screens/setting_screen/widgets/bonus_setting.dart';
import 'package:boby/ui/screens/setting_screen/widgets/memory_settings.dart';
import 'package:boby/ui/screens/setting_screen/widgets/more_apps.dart';
import 'package:boby/ui/screens/setting_screen/widgets/scramble_setting.dart';
import 'package:boby/ui/screens/setting_screen/widgets/parent_email.dart';
import 'package:flutter/material.dart';

import '../../shared/word_of_images.dart';

class SettingScreen extends StatelessWidget {
  static const String route = '/setting_screen';
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              title: "BACKGROUNDS IMAGES",
              content: const BackgroundSettings(),
              color: Colors.blue,
            ),
            const SizedBox(height: 25),

            // Memory Settings
            _buildSection(
              title: "MEMORY LEVEL",
              content: const MemrySettings(),
              color: Colors.purple,
            ),
            const SizedBox(height: 25),

            // Match Settings
            _buildSection(
              title: "WORD ORGANIZATION",
              content: const ScrambleSettings(),
              color: Colors.orange,
            ),
            const SizedBox(height: 25),

            // Badge Settings
            _buildSection(
              title: "BADGE INFORMATION",
              content: const BadgeSettings(),
              color: Colors.green,
            ),
            const SizedBox(height: 25),
            
            // Parent Email
            _buildSection(
              title: "PARENT EMAIL",
              content: const ParentEmail(),
              color: Colors.blue,
            ),
            const SizedBox(height: 25),
            // Bonus Settings
            _buildSection(
              title: "BONUS INFORMATION",
              content: const BonusSettings(),
              color: Colors.green,
            ),
            const SizedBox(height: 25),

            // More Apps
            _buildSection(
              title: "MORE APPS",
              content: const MoreApps(),
              color: Colors.pink,
            ),
            const SizedBox(height: 50),
          ],
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
            color: color.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: content,
          ),
        ],
      ),
    );
  }
}
