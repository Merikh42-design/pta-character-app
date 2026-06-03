class Character {
  final String? className;
  final String? ancestry;
  final String? background;
  final Map<String, dynamic>? startingStats;

  const Character({
    this.className,
    this.ancestry,
    this.background,
    this.startingStats,
  });

  Character copyWith({
    String? className,
    String? ancestry,
    String? background,
    Map<String, dynamic>? startingStats,
  }) {
    return Character(
      className: className ?? this.className,
      ancestry: ancestry ?? this.ancestry,
      background: background ?? this.background,
      startingStats: startingStats ?? this.startingStats,
    );
  }
}