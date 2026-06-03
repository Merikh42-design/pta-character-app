class Character {
  final String? className;
  final Map<String, dynamic>? startingStats;

  const Character({this.className, this.startingStats});

  Character copyWith({
    String? className,
    Map<String, dynamic>? startingStats,
  }) {
    return Character(
      className: className ?? this.className,
      startingStats: startingStats ?? this.startingStats,
    );
  }
}