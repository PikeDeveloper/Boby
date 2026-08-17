import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:boby/services/storage_service.dart';

class DailyReportService {
  static const Map<String, String> _gameNames = {
    'DragAndDrop': 'Drag & Drop',
    'ScrambleWord': 'Scramble Word',
    'Tales': 'Tales',
    'Math': 'Math',
    'Memory': 'Memory',
    'MatchIt': 'Match It',
    'WordGuess': 'Word Guess',
  };

  static Future<void> checkAndSendDailyReport() async {
    try {
      // 1. Get Parent Profile
      final profile = StorageService.instance.getChildProfile();
      final parentEmail = profile?['parentEmail'] ?? StorageService.instance.getParentEmail();
      final childName = profile?['childName'] ?? StorageService.instance.getChildName();

      if (parentEmail == null || parentEmail.trim().isEmpty) {
        debugPrint('[DailyReportService] No parent email set. Skipping report.');
        return;
      }

      final cleanChildName = (childName != null && childName.trim().isNotEmpty) ? childName.trim() : 'El niño';

      // 2. Check if already sent today
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final lastReportDate = StorageService.instance.getLastReportDate();

      if (lastReportDate == dateKey) {
        debugPrint('[DailyReportService] Report already sent today ($dateKey). Skipping.');
        return;
      }

      debugPrint('[DailyReportService] Checking progress for $cleanChildName ($parentEmail)...');

      // 3. Calculate Streak
      final lastPlayDate = StorageService.instance.getLastPlayDate();
      int currentStreak = StorageService.instance.getDayStreak();

      if (lastPlayDate == null) {
        currentStreak = 1;
      } else {
        try {
          final lastPlayDateTime = DateTime.parse(lastPlayDate);
          final difference = today.difference(lastPlayDateTime).inDays;

          if (difference == 1) {
            currentStreak += 1;
          } else if (difference > 1) {
            currentStreak = 1;
          }
          // if difference == 0, keep currentStreak as is
        } catch (e) {
          currentStreak = 1;
        }
      }

      // Save updated play date and streak
      await StorageService.instance.setLastPlayDate(dateKey);
      await StorageService.instance.setDayStreak(currentStreak);

      // 4. Gather Stats
      final Map<String, Map<String, dynamic>> gameStats = {};
      final List<String> newMilestones = [];
      final Set<String> achievedMilestones = StorageService.instance.getAchievedMilestones().toSet();

      // Check Streak Milestone
      if (currentStreak >= 2) {
        final streakKey = 'streak_$currentStreak';
        if (!achievedMilestones.contains(streakKey)) {
          newMilestones.add('$cleanChildName ha conseguido una racha de $currentStreak días seguidos practicando inglés! 🔥');
          achievedMilestones.add(streakKey);
        }
      }

      // Helper to fetch scores per game
      void processGameStats(String gameKey, int correct, int wrong) {
        final total = correct + wrong;
        final accuracy = total > 0 ? (correct / total) : 0.0;

        gameStats[gameKey] = {
          'correct': correct,
          'wrong': wrong,
          'total': total,
          'accuracy': accuracy,
        };

        // Check correct count milestones
        final thresholds = [10, 25, 50, 100, 250, 500];
        for (final threshold in thresholds) {
          if (correct >= threshold) {
            final milestoneKey = 'correct_${threshold}_$gameKey';
            if (!achievedMilestones.contains(milestoneKey)) {
              newMilestones.add('$cleanChildName ha respondido correctamente $threshold palabras en ${_gameNames[gameKey]}! 🌟');
              achievedMilestones.add(milestoneKey);
            }
          }
        }

        // Check level milestones (requires at least 10 attempts to be valid)
        if (total >= 10) {
          String? level;
          if (accuracy >= 0.90) {
            level = 'Diamante';
          } else if (accuracy >= 0.80) {
            level = 'Oro';
          } else if (accuracy >= 0.50) {
            level = 'Plata';
          }

          if (level != null) {
            final milestoneKey = 'level_${level}_$gameKey';
            if (!achievedMilestones.contains(milestoneKey)) {
              newMilestones.add('$cleanChildName ha alcanzado el nivel $level en ${_gameNames[gameKey]}! 🏆');
              achievedMilestones.add(milestoneKey);
            }
          }
        }
      }

      // Populate game stats
      processGameStats('DragAndDrop', StorageService.instance.getSoundCardsCorrect(), StorageService.instance.getSoundCardsWrong());
      processGameStats('ScrambleWord', StorageService.instance.getScrambleWordCorrect(), StorageService.instance.getScrambleWordWrong());
      processGameStats('Tales', StorageService.instance.getTalesCorrect(), StorageService.instance.getTalesWrong());
      processGameStats('Math', StorageService.instance.getMathCorrect(), StorageService.instance.getMathWrong());
      processGameStats('Memory', StorageService.instance.getMemoryCorrect(), StorageService.instance.getMemoryWrong());
      processGameStats('MatchIt', StorageService.instance.getMatchItCorrect(), StorageService.instance.getMatchItWrong());
      processGameStats('WordGuess', StorageService.instance.getWordGuessCorrect(), StorageService.instance.getWordGuessWrong());

      // 5. Check if any activity has happened today (or since last report)
      // If total answers across all games is 0, we can still report if they just started,
      // but let's make sure we don't send empty reports repeatedly.
      int totalAnswers = 0;
      gameStats.forEach((key, val) {
        totalAnswers += (val['total'] as int);
      });

      if (totalAnswers == 0 && newMilestones.isEmpty) {
        debugPrint('[DailyReportService] No activity found yet. Skipping report.');
        return;
      }

      // 6. Write report to Firestore daily_reports collection
      await FirebaseFirestore.instance.collection('daily_reports').add({
        'parentEmail': parentEmail,
        'childName': cleanChildName,
        'date': dateKey,
        'createdAt': FieldValue.serverTimestamp(),
        'streak': currentStreak,
        'newMilestones': newMilestones,
        'stats': gameStats,
        'status': 'pending',
      });

      // 7. Save Daily Report State
      await StorageService.instance.setAchievedMilestones(achievedMilestones.toList());
      await StorageService.instance.setLastReportDate(dateKey);

      debugPrint('[DailyReportService] Daily report successfully queued for $parentEmail');
    } catch (e) {
      debugPrint('[DailyReportService] Error generating daily report: $e');
    }
  }
}
