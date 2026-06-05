import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/character_provider.dart';
import '../widgets/radial_wheel.dart';

class CharacterSheetScreen extends ConsumerWidget {
  const CharacterSheetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(character.className ?? 'Character Sheet'),
        backgroundColor: Colors.brown[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radial Wheel
            Center(child: const RadialWheel()),
            const SizedBox(height: 24),

            // View Abilities Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/abilities');
                },
                icon: const Icon(Icons.list_alt),
                label: const Text('View Abilities & Features'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Character Identity
            _buildSectionCard(
              title: 'Character',
              child: Column(
                children: [
                  _infoRow('Class', character.className),
                  _infoRow('Ancestry', character.ancestry),
                  _infoRow('Background', character.background),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Starting Stats
            if (character.startingStats != null)
              _buildSectionCard(
                title: 'Starting Stats',
                child: _buildStatsGrid(character.startingStats!),
              ),

            const SizedBox(height: 16),

            // Placeholder sections
            _buildSectionCard(
              title: 'Equipment & Inventory',
              child: const Text('Equipment will be displayed here in a future update.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
            const Divider(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value ?? 'Not selected', style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    final importantStats = [
      'Body', 'Physique', 'Technique', 'Endurance',
      'Mind', 'Intellect', 'Acuity', 'Resilience',
      'Spirit', 'Willpower', 'Attunement', 'Resolve',
      'Max Stamina', 'Max Mana', 'Max Morale',
      'Defense', 'Armor', 'Run'
    ];

    final children = <Widget>[];

    for (final key in importantStats) {
      if (stats.containsKey(key) && stats[key] != null) {
        children.add(
          Chip(
            label: Text('$key: ${stats[key]}'),
            backgroundColor: Colors.brown[50],
            labelStyle: const TextStyle(fontSize: 13),
          ),
        );
      }
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: children,
    );
  }
}