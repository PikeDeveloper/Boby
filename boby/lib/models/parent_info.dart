class ParentInfo {
  final String email;
  final String name;
  final List<String> childrenIds;
  final DateTime createdAt;
  final bool emailEnabled;
  final String frequency; // 'daily', 'weekly', 'monthly'
  final DateTime? lastReportSentAt;

  ParentInfo({
    required this.email,
    required this.name,
    List<String>? childrenIds,
    DateTime? createdAt,
    this.emailEnabled = true,
    this.frequency = 'weekly',
    this.lastReportSentAt,
  }) : childrenIds = childrenIds ?? [],
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'childrenIds': childrenIds,
      'createdAt': createdAt.toIso8601String(),
      'emailEnabled': emailEnabled,
      'frequency': frequency,
      'lastReportSentAt': lastReportSentAt?.toIso8601String(),
    };
  }

  factory ParentInfo.fromMap(Map<String, dynamic> map) {
    return ParentInfo(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      childrenIds: List<String>.from(map['childrenIds'] ?? []),
      createdAt: map['createdAt'] is DateTime 
          ? map['createdAt'] 
          : DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      emailEnabled: map['emailEnabled'] ?? true,
      frequency: map['frequency'] ?? 'weekly',
      lastReportSentAt: map['lastReportSentAt'] != null 
          ? DateTime.parse(map['lastReportSentAt']) 
          : null,
    );
  }

  ParentInfo copyWith({
    String? email,
    String? name,
    List<String>? childrenIds,
    DateTime? createdAt,
    bool? emailEnabled,
    String? frequency,
    DateTime? lastReportSentAt,
  }) {
    return ParentInfo(
      email: email ?? this.email,
      name: name ?? this.name,
      childrenIds: childrenIds ?? this.childrenIds,
      createdAt: createdAt ?? this.createdAt,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      frequency: frequency ?? this.frequency,
      lastReportSentAt: lastReportSentAt ?? this.lastReportSentAt,
    );
  }
}