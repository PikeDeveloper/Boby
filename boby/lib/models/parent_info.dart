class ParentInfo {
  final String email;
  final String name;
  final List<String> childrenIds;
  final DateTime createdAt;
  final bool emailEnabled;
  final String frequency; // 'daily', 'weekly', 'monthly'

  ParentInfo({
    required this.email,
    required this.name,
    List<String>? childrenIds,
    DateTime? createdAt,
    this.emailEnabled = true,
    this.frequency = 'weekly',
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
    );
  }

  ParentInfo copyWith({
    String? email,
    String? name,
    List<String>? childrenIds,
    DateTime? createdAt,
    bool? emailEnabled,
    String? frequency,
  }) {
    return ParentInfo(
      email: email ?? this.email,
      name: name ?? this.name,
      childrenIds: childrenIds ?? this.childrenIds,
      createdAt: createdAt ?? this.createdAt,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      frequency: frequency ?? this.frequency,
    );
  }
}