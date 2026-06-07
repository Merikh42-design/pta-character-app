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
        backgroundColor: Colors.brown[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Central Radial Wheel
            const RadialWheel(),

            const SizedBox(height: 24),

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

            const SizedBox(height: 24),

            // Body / Mind / Spirit Stat Groups (themed around the wheel)
            if (character.startingStats != null)
              _buildThemedStatsSection(character.startingStats!),

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
          ],
        ),
      ),
    );
  }

  Widget _buildThemedStatsSection(Map<String, dynamic> stats) {
    return Column(
      children: [
        // BODY - Green
        _buildStatGroup(
          title: 'BODY',
          color: const Color(0xFF42B278),
          stats: stats,
          keys: ['Physique', 'Technique', 'Endurance', 'Max Stamina'],
        ),

        const SizedBox(height: 16),

        // MIND - Blue
        _buildStatGroup(
          title: 'MIND',
          color: const Color(0xFF87CDFE),
          stats: stats,
          keys: ['Intellect', 'Acuity', 'Resilience', 'Max Mana'],
        ),

        const SizedBox(height: 16),

        // SPIRIT - Gold
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
    final filteredStats = keys.where((k) => stats.containsKey(k) && stats[k] != null).toList();

    if (filteredStats.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: filteredStats.map((key) {
                return Chip(
                  label: Text('$key: ${stats[key]}'),
                  backgroundColor: color.withOpacity(0.1),
                  labelStyle: const TextStyle(fontSize: 13),
                );
              }).toList(),
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
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown[800])),
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
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.brown[800]))),
          Expanded(child: Text(value ?? 'Not selected', style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}