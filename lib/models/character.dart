class Character {
  final String? className;
  final String? ancestry;
  final String? background;
  final Map<String, dynamic>? startingStats;

  // Filtered abilities based on selected class
  final List<Map<String, dynamic>> freeActions;
  final List<Map<String, dynamic>> reactions;
  final List<Map<String, dynamic>> martialManeuvers;
  final List<Map<String, dynamic>> projectileManeuvers;
  final List<Map<String, dynamic>> tacticalManeuvers;
  final List<Map<String, dynamic>> skillManeuvers;
  final List<Map<String, dynamic>> attackSpells;
  final List<Map<String, dynamic>> tacticalSpells;
  final List<Map<String, dynamic>> skillSpells;
  final List<Map<String, dynamic>> attackChants;
  final List<Map<String, dynamic>> tacticalChants;
  final List<Map<String, dynamic>> skillChants;

  const Character({
    this.className,
    this.ancestry,
    this.background,
    this.startingStats,
    this.freeActions = const [],
    this.reactions = const [],
    this.martialManeuvers = const [],
    this.projectileManeuvers = const [],
    this.tacticalManeuvers = const [],
    this.skillManeuvers = const [],
    this.attackSpells = const [],
    this.tacticalSpells = const [],
    this.skillSpells = const [],
    this.attackChants = const [],
    this.tacticalChants = const [],
    this.skillChants = const [],
  });

  Character copyWith({
    String? className,
    String? ancestry,
    String? background,
    Map<String, dynamic>? startingStats,
    List<Map<String, dynamic>>? freeActions,
    List<Map<String, dynamic>>? reactions,
    List<Map<String, dynamic>>? martialManeuvers,
    List<Map<String, dynamic>>? projectileManeuvers,
    List<Map<String, dynamic>>? tacticalManeuvers,
    List<Map<String, dynamic>>? skillManeuvers,
    List<Map<String, dynamic>>? attackSpells,
    List<Map<String, dynamic>>? tacticalSpells,
    List<Map<String, dynamic>>? skillSpells,
    List<Map<String, dynamic>>? attackChants,
    List<Map<String, dynamic>>? tacticalChants,
    List<Map<String, dynamic>>? skillChants,
  }) {
    return Character(
      className: className ?? this.className,
      ancestry: ancestry ?? this.ancestry,
      background: background ?? this.background,
      startingStats: startingStats ?? this.startingStats,
      freeActions: freeActions ?? this.freeActions,
      reactions: reactions ?? this.reactions,
      martialManeuvers: martialManeuvers ?? this.martialManeuvers,
      projectileManeuvers: projectileManeuvers ?? this.projectileManeuvers,
      tacticalManeuvers: tacticalManeuvers ?? this.tacticalManeuvers,
      skillManeuvers: skillManeuvers ?? this.skillManeuvers,
      attackSpells: attackSpells ?? this.attackSpells,
      tacticalSpells: tacticalSpells ?? this.tacticalSpells,
      skillSpells: skillSpells ?? this.skillSpells,
      attackChants: attackChants ?? this.attackChants,
      tacticalChants: tacticalChants ?? this.tacticalChants,
      skillChants: skillChants ?? this.skillChants,
    );
  }
}