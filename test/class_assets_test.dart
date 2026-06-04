import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Validates class portrait filenames match ABC wizard conventions.
void main() {
  test('class image assets exist for every descriptor', () {
    final descriptorsFile = File('data_packs/core/class_descriptors.json');
    expect(descriptorsFile.existsSync(), isTrue);

    final jsonMap =
        json.decode(descriptorsFile.readAsStringSync()) as Map<String, dynamic>;
    final classes =
        List<Map<String, dynamic>>.from(jsonMap['classes'] as List);

    final classesDir = Directory('assets/images/classes');
    expect(
      classesDir.existsSync(),
      isTrue,
      reason: 'Create assets/images/classes/ and add class PNGs',
    );

    final missing = <String>[];
    for (final cls in classes) {
      final name = cls['name'] as String;
      final fileName =
          '${name.toLowerCase().replaceAll(' ', '_')}.png';
      final file = File('assets/images/classes/$fileName');
      if (!file.existsSync()) {
        missing.add(fileName);
      }
    }

    expect(
      missing,
      isEmpty,
      reason: 'Missing class images:\n${missing.join('\n')}',
    );
  });

}