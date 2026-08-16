import 'package:animate_do/animate_do.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Header animated ──────────────────────────────
            BounceInDown(
              duration: const Duration(milliseconds: 700),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFFD54F), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.settings_rounded, color: Color(0xFFFFB300), size: 28),
                      const SizedBox(width: 10),
                      const WordOfImages(letters: "SETTINGS", letterSize: 32),
                      const SizedBox(width: 10),
                      const Icon(Icons.settings_rounded, color: Color(0xFFFFB300), size: 28),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Sections ─────────────────────────────────────
            FadeInUp(delay: const Duration(milliseconds: 100), child: _buildSection(
              title: "Backgrounds",
              icon: Icons.wallpaper_rounded,
              gradient: const LinearGradient(colors: [Color(0xFF29B6F6), Color(0xFF0277BD)]),
              content: const BackgroundSettings(),
            )),

            const SizedBox(height: 18),

            FadeInUp(delay: const Duration(milliseconds: 200), child: _buildSection(
              title: "Memory Level",
              icon: Icons.grid_view_rounded,
              gradient: const LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFF6A1B9A)]),
              content: const MemrySettings(),
            )),

            const SizedBox(height: 18),

            FadeInUp(delay: const Duration(milliseconds: 300), child: _buildSection(
              title: "Word Organization",
              icon: Icons.sort_by_alpha_rounded,
              gradient: const LinearGradient(colors: [Color(0xFFFF9F43), Color(0xFFE67E22)]),
              content: const ScrambleSettings(),
            )),

            const SizedBox(height: 18),

            FadeInUp(delay: const Duration(milliseconds: 400), child: _buildSection(
              title: "Badges",
              icon: Icons.emoji_events_rounded,
              gradient: const LinearGradient(colors: [Color(0xFF26C281), Color(0xFF1A8A58)]),
              content: const BadgeSettings(),
            )),

            const SizedBox(height: 18),

            FadeInUp(delay: const Duration(milliseconds: 500), child: _buildSection(
              title: "Parent Email",
              icon: Icons.email_rounded,
              gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1565C0)]),
              content: const ParentEmail(),
              trailing: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 10,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE3F2FD),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.mark_email_unread_rounded, size: 48, color: Color(0xFF1E88E5)),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Parent Email',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'We use this email to send progress updates to your parents! 📬',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E88E5),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Got it!',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),

            const SizedBox(height: 18),

            FadeInUp(delay: const Duration(milliseconds: 600), child: _buildSection(
              title: "Bonus Games",
              icon: Icons.stars_rounded,
              gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)]),
              content: const BonusSettings(),
            )),

            const SizedBox(height: 18),

            FadeInUp(delay: const Duration(milliseconds: 700), child: _buildSection(
              title: "More Apps",
              icon: Icons.apps_rounded,
              gradient: const LinearGradient(colors: [Color(0xFFEC407A), Color(0xFFC2185B)]),
              content: const MoreApps(),
            )),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Gradient gradient,
    required Widget content,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.13),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header with gradient ──────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.8,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) const Spacer(),
                if (trailing != null) trailing,
              ],
            ),
          ),

          // ── Section content ───────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: content,
          ),
        ],
      ),
    );
  }
}
