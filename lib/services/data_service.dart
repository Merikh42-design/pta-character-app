import 'dart:convert';
import 'package:flutter/services.dart';

/// Centralized data loading for Pathways to Adventure
/// 
/// Current files in data_packs/core/:
/// - class_abilities.json     → Class availability matrix
/// - maneuvers.json           → Detailed Maneuvers
/// - spells.json              → Detailed Spells
/// - chants.json              → Detailed Chants
/// - free_reactions.json      → Free Actions & Reactions
/// - classes.json, ancestries.json, backgrounds.json, etc.
class DataService {
  // ==================== CLASS AVAILABILITY MATRIX ====================

  static Future<Map<String, dynamic>> loadClassAbilities() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/class_abilities.json');
    return json.decode(jsonString);
  }

  // ==================== DETAILED ABILITY LIBRARIES ====================

  static Future<List<Map<String, dynamic>>> loadManeuverLibrary() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/maneuvers.json');
    final dynamic decoded = json.decode(jsonString);
    if (decoded is List) return decoded.cast<Map<String, dynamic>>();
    if (decoded is Map) return List<Map<String, dynamic>>.from(decoded.values.first ?? []);
    return [];
  }

  static Future<List<Map<String, dynamic>>> loadSpellLibrary() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/spells.json');
    final dynamic decoded = json.decode(jsonString);
    if (decoded is List) return decoded.cast<Map<String, dynamic>>();
    if (decoded is Map) return List<Map<String, dynamic>>.from(decoded.values.first ?? []);
    return [];
  }

  static Future<List<Map<String, dynamic>>> loadChantLibrary() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/chants.json');
    final dynamic decoded = json.decode(jsonString);
    if (decoded is List) return decoded.cast<Map<String, dynamic>>();
    if (decoded is Map) return List<Map<String, dynamic>>.from(decoded.values.first ?? []);
    return [];
  }

  static Future<List<Map<String, dynamic>>> loadFreeActionReactionLibrary() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/free_reactions.json');
    final dynamic decoded = json.decode(jsonString);
    if (decoded is List) return decoded.cast<Map<String, dynamic>>();
    if (decoded is Map) return List<Map<String, dynamic>>.from(decoded.values.first ?? []);
    return [];
  }

  // ==================== OTHER DATA ====================

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

  // ==================== ABILITY FILTERING (from class_abilities.json) ====================

  static Future<List<Map<String, dynamic>>> getFreeActionsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['free_actions'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getReactionsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['reactions'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getMartialManeuversForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['martial_attack_maneuvers'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getProjectileManeuversForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['projectile_attack_maneuvers'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getTacticalManeuversForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['tactical_maneuvers'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getSkillManeuversForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['skill_maneuvers'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getAttackSpellsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['attack_spells'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getTacticalSpellsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['tactical_spells'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getSkillSpellsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['skill_spells'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getAttackChantsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['attack_chants'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getTacticalChantsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['tactical_chants'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }

  static Future<List<Map<String, dynamic>>> getSkillChantsForClass(String className) async {
    final abilities = await loadClassAbilities();
    final list = abilities['skill_chants'] as List? ?? [];
    return list.where((a) => (a['classes'] as List).contains(className)).cast<Map<String, dynamic>>().toList();
  }
}