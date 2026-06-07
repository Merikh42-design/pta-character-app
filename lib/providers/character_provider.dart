import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../services/data_service.dart';

class CharacterNotifier extends Notifier<Character> {
  @override
  Character build() => const Character();

  Future<void> selectClass(String className) async {
    state = state.copyWith(isLoadingAbilities: true);

    final stats = await DataService.getClassByName(className);

    // Load from matrix
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

    // Enrich with full details from separate libraries
    final enrichedFreeActions = await _enrichAbilities(freeActions, 'free_action');
    final enrichedReactions = await _enrichAbilities(reactions, 'reaction');
    final enrichedMartial = await _enrichAbilities(martialManeuvers, 'maneuver');
    final enrichedProjectile = await _enrichAbilities(projectileManeuvers, 'maneuver');
    final enrichedTacticalManeuvers = await _enrichAbilities(tacticalManeuvers, 'maneuver');
    final enrichedSkillManeuvers = await _enrichAbilities(skillManeuvers, 'maneuver');
    final enrichedAttackSpells = await _enrichAbilities(attackSpells, 'spell');
    final enrichedTacticalSpells = await _enrichAbilities(tacticalSpells, 'spell');
    final enrichedSkillSpells = await _enrichAbilities(skillSpells, 'spell');
    final enrichedAttackChants = await _enrichAbilities(attackChants, 'chant');
    final enrichedTacticalChants = await _enrichAbilities(tacticalChants, 'chant');
    final enrichedSkillChants = await _enrichAbilities(skillChants, 'chant');

    final classSkills = _calculateSkillsFromClass(stats);

    state = state.copyWith(
      className: className,
      startingStats: stats,
      freeActions: enrichedFreeActions,
      reactions: enrichedReactions,
      martialManeuvers: enrichedMartial,
      projectileManeuvers: enrichedProjectile,
      tacticalManeuvers: enrichedTacticalManeuvers,
      skillManeuvers: enrichedSkillManeuvers,
      attackSpells: enrichedAttackSpells,
      tacticalSpells: enrichedTacticalSpells,
      skillSpells: enrichedSkillSpells,
      attackChants: enrichedAttackChants,
      tacticalChants: enrichedTacticalChants,
      skillChants: enrichedSkillChants,
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

  // Enrich ability with details from the correct library
  Future<List<Map<String, dynamic>>> _enrichAbilities(
    List<Map<String, dynamic>> abilities,
    String type,
  ) async {
    if (abilities.isEmpty) return [];

    List<Map<String, dynamic>> library = [];
    String nameKey = 'name'; // default

    switch (type) {
      case 'maneuver':
        library = await DataService.loadManeuverLibrary();
        nameKey = 'maneuver';
        break;
      case 'spell':
        library = await DataService.loadSpellLibrary();
        nameKey = 'spell';
        break;
      case 'chant':
        library = await DataService.loadChantLibrary();
        nameKey = 'chant';
        break;
      case 'free_action':
      case 'reaction':
        library = await DataService.loadFreeActionReactionLibrary();
        nameKey = 'name'; // or adjust if they use different key
        break;
    }

    if (library.isEmpty) return abilities;

    return abilities.map((ability) {
      final abilityName = ability['name'] ?? ability['maneuver'] ?? ability['spell'] ?? ability['chant'];
      try {
        final detail = library.firstWhere((item) => item[nameKey] == abilityName);
        return {...ability, ...detail};
      } catch (_) {
        return ability;
      }
    }).toList();
  }

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

  List<String> _extractSkillsFromData(Map<String, dynamic>? data) {
    if (data == null) return [];
    final skills = data['skills'];
    if (skills is List) {
      return skills.map((e) => e.toString()).toList();
    }
    return [];
  }

  Map<String, String> _mergeSkills(Map<String, String> current, List<String> newSkills) {
    final Map<String, String> result = Map.from(current);
    for (final skill in newSkills) {
      if (result.containsKey(skill)) {
        result[skill] = 'M';
      } else {
        result[skill] = 'P';
      }
    }
    return result;
  }

  final characterProvider = NotifierProvider<CharacterNotifier, Character>(
    CharacterNotifier.new,
  );
}