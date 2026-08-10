class ChildStats {
  final String childId;
  final String childName;
  final String parentId;
  final DateTime date;
  final int wordsLearned;
  final int levelsCompleted;
  final String currentLevel;
  final int score;
  final Map<String, int> gameProgress; // Progreso por juego
  final List<String> achievements;

  ChildStats({
    required this.childId,
    required this.childName,
    required this.parentId,
    required this.date,
    this.wordsLearned = 0,
    this.levelsCompleted = 0,
    this.currentLevel = 'Bronze',
    this.score = 0,
    Map<String, int>? gameProgress,
    List<String>? achievements,
  }) : gameProgress = gameProgress ?? {},
       achievements = achievements ?? [];

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'childName': childName,
      'parentId': parentId,
      'date': date.toIso8601String(),
      'wordsLearned': wordsLearned,
      'levelsCompleted': levelsCompleted,
      'currentLevel': currentLevel,
      'score': score,
      'gameProgress': gameProgress,
      'achievements': achievements,
    };
  }

  factory ChildStats.fromMap(Map<String, dynamic> map) {
    return ChildStats(
      childId: map['childId'] ?? '',
      childName: map['childName'] ?? '',
      parentId: map['parentId'] ?? '',
      date: map['date'] is DateTime 
          ? map['date'] 
          : DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      wordsLearned: map['wordsLearned'] ?? 0,
      levelsCompleted: map['levelsCompleted'] ?? 0,
      currentLevel: map['currentLevel'] ?? 'Bronze',
      score: map['score'] ?? 0,
      gameProgress: Map<String, int>.from(map['gameProgress'] ?? {}),
      achievements: List<String>.from(map['achievements'] ?? []),
    );
  }

  ChildStats copyWith({
    String? childId,
    String? childName,
    String? parentId,
    DateTime? date,
    int? wordsLearned,
    int? levelsCompleted,
    String? currentLevel,
    int? score,
    Map<String, int>? gameProgress,
    List<String>? achievements,
  }) {
    return ChildStats(
      childId: childId ?? this.childId,
      childName: childName ?? this.childName,
      parentId: parentId ?? this.parentId,
      date: date ?? this.date,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      levelsCompleted: levelsCompleted ?? this.levelsCompleted,
      currentLevel: currentLevel ?? this.currentLevel,
      score: score ?? this.score,
      gameProgress: gameProgress ?? this.gameProgress,
      achievements: achievements ?? this.achievements,
    );
  }
}