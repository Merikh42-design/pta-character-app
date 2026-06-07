import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../services/data_service.dart';

final characterProvider = NotifierProvider<CharacterNotifier, Character>(
  CharacterNotifier.new,
);

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

    final classSkills = _calculateSkillsFromClass(stats);

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
      skills: classSkills,
      isLoadingAbilities: false,
    );
  }

  Future<void> selectAncestry(String ancestryName) async {
    final ancestryData = await DataService.getAncestryByName(ancestryName);
    final ancestrySkills = _extractSkillsFromData(ancestryData);

    final mergedSkills = _mergeSkills(state.skills, ancestrySkills);

    state = state.copyWith(
      ancestry: ancestryName,
      skills: mergedSkills,
    );
  }

  Future<void> selectBackground(String backgroundName) async {
    final backgroundData = await DataService.getBackgroundByName(backgroundName);
    final backgroundSkills = _extractSkillsFromData(backgroundData);

    final mergedSkills = _mergeSkills(state.skills, backgroundSkills);

    state = state.copyWith(
      background: backgroundName,
      skills: mergedSkills,
    );
  }

  // Get skills where value == true from class stats
  Map<String, String> _calculateSkillsFromClass(Map<String, dynamic>? stats) {
    if (stats == null) return {};

    final Map<String, String> result = {};
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

  // Extract skills array from ancestry or background data
  List<String> _extractSkillsFromData(Map<String, dynamic>? data) {
    if (data == null) return [];
    final skills = data['skills'];
    if (skills is List) {
      return skills.map((e) => e.toString()).toList();
    }
    return [];
  }

  // Merge: upgrade to M if skill exists in both
  Map<String, String> _mergeSkills(Map<String, String> current, List<String> newSkills) {
    final Map<String, String> result = Map.from(current);

    for (final skill in newSkills) {
      if (result.containsKey(skill)) {
        result[skill] = 'M'; // Upgrade to Mastered
      } else {
        result[skill] = 'P'; // New skill from ancestry/background
      }
    }
    return result;
  }
}