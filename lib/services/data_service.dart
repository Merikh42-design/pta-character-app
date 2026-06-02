import 'dart:convert';
import 'package:flutter/services.dart';

/// Centralized data loading for all JSON packs in data_packs/core/
/// All data is user-provided and loaded at runtime for offline use.
class DataService {
  static Future<List<Map<String, dynamic>>> loadClassDescriptors() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/class_descriptors.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonMap['classes'] ?? []);
  }

  static Future<List<Map<String, dynamic>>> loadClasses() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/classes.json');
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  static Future<Map<String, dynamic>> loadStates() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/states.json');
    return json.decode(jsonString);
  }

  static Future<Map<String, dynamic>> loadEquipment() async {
    final String jsonString =
        await rootBundle.loadString('data_packs/core/equipment.json');
    return json.decode(jsonString);
  }

  // Easy method to get a class by name (for applying starting stats later)
  static Future<Map<String, dynamic>?> getClassByName(String name) async {
    final classes = await loadClasses();
    try {
      return classes.firstWhere((c) => c['Class'] == name);
    } catch (_) {
      return null;
    }
  }
}