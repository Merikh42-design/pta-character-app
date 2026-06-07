import 'dart:convert';
import 'package:flutter/services.dart';

/// Centralized data loading for Pathways to Adventure
/// 
/// Architecture:
/// - class_abilities.json     = Which classes have access to which abilities (matrix)
/// - maneuverslibrary.json    = Detailed data for all Maneuvers
/// - spellslibrary.json       = Detailed data for all Spells
/// - chantlibrary.json        = Detailed data for all Chants
/// - free_reaction_library.json = Detailed data for Free Actions & Reactions
class DataService {
  // ==================== CLASS AVAILABILITY MATRIX ====================

  static Future<Map<String, dynamic>> loadClassAbilities() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/class_abilities.json');
    return json.decode(jsonString);
  }

  // ==================== DETAILED LIBRARIES ====================

  static Future<List<Map<String, dynamic>>> loadManeuverLibrary() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/maneuverslibrary.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonMap['maneuvers'] ?? jsonMap.values.first ?? []);
  }

  static Future<List<Map<String, dynamic>>> loadSpellLibrary() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/spellslibrary.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonMap['spells'] ?? jsonMap.values.first ?? []);
  }

  static Future<List<Map<String, dynamic>>> loadChantLibrary() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/chantlibrary.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonMap['chants'] ?? jsonMap.values.first ?? []);
  }

  static Future<List<Map<String, dynamic>>> loadFreeActionReactionLibrary() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/free_reaction_library.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(
        jsonMap['free_actions'] ?? jsonMap['reactions'] ?? jsonMap.values.first ?? []);
  }

  // ==================== EXISTING CLASS / ANCESTRY / BACKGROUND ====================

  static Future<List<Map<String, dynamic>>> loadClassDescriptors() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/class_descriptors.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonMap['classes'] ?? []);
  }

  static Future<List<Map<String, dynamic>>> loadClasses() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/classes.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonMap['classes'] ?? []);
  }

  static Future<List<Map<String, dynamic>>> loadAncestries() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/ancestries.json');
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  static Future<List<Map<String, dynamic>>> loadBackgrounds() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/backgrounds.json');
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  static Future<Map<String, dynamic>?> getClassByName(String name) async {
    final classes = await loadClasses();
    try {
      return classes.firstWhere((c) => c['Class'] == name);
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getAncestryByName(String name) async {
    final ancestries = await loadAncestries();
    try {
      return ancestries.firstWhere((a) => a['name'] == name);
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getBackgroundByName(String name) async {
    final backgrounds = await loadBackgrounds();
    try {
      return backgrounds.firstWhere((b) => b['Name'] == name);
    } catch (_) {
      return null;
    }
  }

  // ==================== ABILITY FILTERING (uses class_abilities.json matrix) ====================

  static Future<List<Map<String, dynamic>>> getFreeActionsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final freeActions = abilities['free_actions'] as List? ?? [];
    return freeActions.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getReactionsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final reactions = abilities['reactions'] as List? ?? [];
    return reactions.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getMartialManeuversForClass(String className) async {
    final abilities = await loadClassAbilities();
    final maneuvers = abilities['martial_attack_maneuvers'] as List? ?? [];
    return maneuvers.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getProjectileManeuversForClass(String className) async {
    final abilities = await loadClassAbilities();
    final maneuvers = abilities['projectile_attack_maneuvers'] as List? ?? [];
    return maneuvers.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getTacticalManeuversForClass(String className) async {
    final abilities = await loadClassAbilities();
    final maneuvers = abilities['tactical_maneuvers'] as List? ?? [];
    return maneuvers.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getSkillManeuversForClass(String className) async {
    final abilities = await loadClassAbilities();
    final maneuvers = abilities['skill_maneuvers'] as List? ?? [];
    return maneuvers.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getAttackSpellsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final spells = abilities['attack_spells'] as List? ?? [];
    return spells.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getTacticalSpellsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final spells = abilities['tactical_spells'] as List? ?? [];
    return spells.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getSkillSpellsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final spells = abilities['skill_spells'] as List? ?? [];
    return spells.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getAttackChantsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final chants = abilities['attack_chants'] as List? ?? [];
    return chants.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getTacticalChantsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final chants = abilities['tactical_chants'] as List? ?? [];
    return chants.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getSkillChantsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final chants = abilities['skill_chants'] as List? ?? [];
    return chants.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }
}