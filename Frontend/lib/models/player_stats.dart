// Frontend/lib/models/player_stats.dart (Corrected Model)

class StatsAttributes {
  final int strength;
  final int agility;
  final int vigor;
  final int stamina;
  final int defense;

  StatsAttributes({
    required this.strength,
    required this.agility,
    required this.vigor,
    required this.stamina,
    required this.defense,
  });

  factory StatsAttributes.fromJson(Map<String, dynamic> json) {
    return StatsAttributes(
      strength: (json['strength'] as num?)?.toInt() ?? 5,
      agility: (json['agility'] as num?)?.toInt() ?? 5,
      vigor: (json['vigor'] as num?)?.toInt() ?? 5,
      stamina: (json['stamina'] as num?)?.toInt() ?? 5,
      defense: (json['defense'] as num?)?.toInt() ?? 5,
    );
  }
}

class PlayerStats {
  final String userId;
  final int level;
  final int xp;
  final int tasksCompleted;
  final int questsFailed;
  final StatsAttributes attributes;

  PlayerStats({
    required this.userId,
    required this.level,
    required this.xp,
    required this.tasksCompleted,
    required this.questsFailed,
    required this.attributes,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      userId: json['userId'] as String,
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      tasksCompleted: (json['tasksCompleted'] as num?)?.toInt() ?? 0,
      questsFailed: (json['questsFailed'] as num?)?.toInt() ?? 0,
      attributes: StatsAttributes.fromJson(json['stats']),
    );
  }
}
