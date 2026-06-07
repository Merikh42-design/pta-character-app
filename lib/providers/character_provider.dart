import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../services/data_service.dart';

class CharacterNotifier extends Notifier<Character> {
  @override
  Character build() => const Character();

  Future<void> selectClass(String className) async {
    state = state.copyWith(isLoadingAbilities: true);

    final stats = await DataService.getClassByName(className);

    final freeActions = await DataService.getFreeActionsForClass(className);
    final reactions = await DataService.getReactionsForClass(className);
    final martialManeuvers = await DataService.getMartialManeuversForClass(className);
    final projectileManeuvers = await DataService.getProjectileManeuversForClass(className);
    final tacticalManeuvers = await DataService.getTacticalManeuversForClass(className);
    final skillManeuvers = await DataService.getSkillManeuversForClass(className);
    final attackSpells = await DataService.getAttackSpellsForClass(className);
    final tacticalSpells = await DataService.getTacticalSpellsForClass(className);
    final skillSpells = await DataService.getSkillSpellsForClass(className);
    final attackChants = await DataService.getAttackChantsForClass(className);
    final tacticalChants = await DataService.getTacticalChantsForClass(className);
    final skillChants = await DataService.getSkillChantsForClass(className);

    // Calculate skills from class (true = P)
    final Map<String, String> newSkills = _calculateSkillsFromClass(stats);

    state = state.copyWith(
      className: className,
      startingStats: stats,
      freeActions: freeActions,
      reactions: reactions,
      martialManeuvers: martialManeuvers,
      projectileManeuvers: projectileManeuvers,
      tacticalManeuvers: tacticalManeuvers,
      skillManeuvers: skillManeuvers,
      attackSpells: attackSpells,
      tacticalSpells: tacticalSpells,
      skillSpells: skillSpells,
      attackChants: attackChants,
      tacticalChants: tacticalChants,
      skillChants: skillChants,
      skills: newSkills,
      isLoadingAbilities: false,
    );
  }

  Future<void> selectAncestry(String ancestryName) async {
    final newSkills = _mergeSkillsWithAncestryOrBackground(state.skills, ancestryName, isAncestry: true);

    state = state.copyWith(
      ancestry: ancestryName,
      skills: newSkills,
    );
  }

  Future<void> selectBackground(String backgroundName) async {
    final newSkills = _mergeSkillsWithAncestryOrBackground(state.skills, backgroundName, isAncestry: false);

    state = state.copyWith(
      background: backgroundName,
      skills: newSkills,
    );
  }

  // Helper: Get skills from class (where value == true)
  Map<String, String> _calculateSkillsFromClass(Map<String, dynamic>? stats) {
    if (stats == null) return {};

    final Map<String, String> result = {};

    // List of known skill fields in classes.json
    final skillFields = [
      'Arcana', 'Control', 'Focus', 'Knowledge', 'Medicine', 'Intuition',
      'Investigate', 'Perception', 'Research', 'Summon',
      'Athletic', 'Balance', 'Grapple', 'Larceny', 'Precision', 'Mount', 'Stealth',
      'Commune', 'Conjure', 'Deception', 'Empathy', 'Intimidation',
      'Leadership', 'Perform', 'Persuasion', 'Piety', 'Survival'
    ];

    for (final field in skillFields) {
      if (stats[field] == true) {
        result[field] = 'P';
      }
    }

    return result;
  }

  // Helper: Merge ancestry or background skills (upgrade to M if overlap)
  Map<String, String> _mergeSkillsWithAncestryOrBackground(
    Map<String, String> currentSkills,
    String name,
    {required bool isAncestry},
  ) {
    // For now, we only upgrade if ancestry/background has the skill
    // Full implementation would require loading ancestry/background skill lists
    // This is a placeholder that can be expanded
    return currentSkills;
  }

  final characterProvider = NotifierProvider<CharacterNotifier, Character>(
    CharacterNotifier.new,
  );
}