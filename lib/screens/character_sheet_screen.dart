import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/character_provider.dart';
import '../widgets/radial_wheel.dart';

class CharacterSheetScreen extends ConsumerWidget {
  const CharacterSheetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    if (character.isLoadingAbilities) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(character.className ?? 'Character Sheet'),
        backgroundColor: Colors.brown[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Prominent Radial Wheel
            const SizedBox(
              width: 320,
              height: 320,
              child: RadialWheel(),
            ),

            const SizedBox(height: 16),

            // View Abilities Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/abilities'),
                icon: const Icon(Icons.list_alt),
                label: const Text('View Abilities & Features'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[800],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Skills Section
            if (character.skills.isNotEmpty)
              _buildSkillsSection(character.skills),

            const SizedBox(height: 20),

            // Body / Mind / Spirit Stats - positioned closer to wheel
            if (character.startingStats != null)
              _buildThemedStatsSection(character.startingStats!),

            const SizedBox(height: 20),

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
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(Map<String, String> skills) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const Divider(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.entries.map((entry) {
                final value = entry.value;
                return Chip(
                  label: Text('${entry.key}: $value'),
                  backgroundColor: value == 'M' ? Colors.amber[200] : Colors.green[100],
                  labelStyle: const TextStyle(fontSize: 13, color: Colors.black),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemedStatsSection(Map<String, dynamic> stats) {
    return Column(
      children: [
        _buildStatGroup(
          title: 'BODY',
          color: const Color(0xFF42B278),
          stats: stats,
          keys: ['Physique', 'Technique', 'Endurance', 'Max Stamina'],
        ),
        const SizedBox(height: 10),
        _buildStatGroup(
          title: 'MIND',
          color: const Color(0xFF87CDFE),
          stats: stats,
          keys: ['Intellect', 'Acuity', 'Resilience', 'Max Mana'],
        ),
        const SizedBox(height: 10),
        _buildStatGroup(
          title: 'SPIRIT',
          color: const Color(0xFFC3B15B),
          stats: stats,
          keys: ['Willpower', 'Attunement', 'Resolve', 'Max Morale'],
        ),
      ],
    );
  }

  Widget _buildStatGroup({
    required String title,
    required Color color,
    required Map<String, dynamic> stats,
    required List<String> keys,
  }) {
    final filtered = keys.where((k) => stats.containsKey(k) && stats[k] != null).toList();
    if (filtered.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: filtered.map((k) => Chip(
                label: Text('$k: ${stats[k]}', style: const TextStyle(color: Colors.black)),
                backgroundColor: color.withOpacity(0.15),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black))),
          Text(value ?? 'Not selected'),
        ],
      ),
    );
  }
}