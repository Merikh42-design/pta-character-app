import 'package:flutter_test/flutter_test.dart';
import 'package:pta_character_app/services/data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('core data packs load with expected content', () async {
    final classes = await DataService.loadClassDescriptors();
    final ancestries = await DataService.loadAncestries();
    final backgrounds = await DataService.loadBackgrounds();
    final fullClasses = await DataService.loadClasses();
    final states = await DataService.loadStates();
    final equipment = await DataService.loadEquipment();

    expect(classes, isNotEmpty);
    expect(ancestries, isNotEmpty);
    expect(backgrounds, isNotEmpty);
    expect(fullClasses, isNotEmpty);
    expect(states, isNotEmpty);
    expect(equipment, isNotEmpty);

    expect(classes.first.containsKey('name'), isTrue);
    expect(ancestries.first.containsKey('name'), isTrue);
    expect(backgrounds.first.containsKey('Name'), isTrue);
  });

  test('getClassByName returns matching class', () async {
    final classes = await DataService.loadClasses();
    final firstName = classes.first['Class'] as String;

    final found = await DataService.getClassByName(firstName);
    expect(found, isNotNull);
    expect(found!['Class'], firstName);
  });
}