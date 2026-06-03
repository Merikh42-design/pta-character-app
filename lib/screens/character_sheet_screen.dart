import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/character_provider.dart';
import '../widgets/radial_wheel.dart';

class CharacterSheetScreen extends ConsumerWidget {
  const CharacterSheetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    final stats = character.startingStats ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(character.className ?? 'Character Sheet'),
        backgroundColor: Colors.brown[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const RadialWheel(),
            const SizedBox(height: 24),
            const Text(
              'Starting Stats',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (stats['Physique'] != null) _statChip('Physique', stats['Physique']),
                if (stats['Technique'] != null) _statChip('Technique', stats['Technique']),
                if (stats['Intellect'] != null) _statChip('Intellect', stats['Intellect']),
                if (stats['Willpower'] != null) _statChip('Willpower', stats['Willpower']),
                if (stats['Max Stamina'] != null) _statChip('Stamina', stats['Max Stamina']),
                if (stats['Max Mana'] != null) _statChip('Mana', stats['Max Mana']),
                if (stats['Max Morale'] != null) _statChip('Morale', stats['Max Morale']),
                if (stats['Defense'] != null) _statChip('Defense', stats['Defense']),
                if (stats['Run'] != null) _statChip('Run', stats['Run']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, dynamic value) {
    return Chip(
      label: Text('$label: $value'),
      visualDensity: VisualDensity.compact,
    );
  }
}