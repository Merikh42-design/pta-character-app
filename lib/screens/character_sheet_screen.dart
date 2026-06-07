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
          children: [
            const RadialWheel(),

            const SizedBox(height: 24),

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

            // Skills Section (P / M)
            if (character.skills.isNotEmpty)
              _buildSkillsSection(character.skills),

            const SizedBox(height: 24),

            // Body / Mind / Spirit Stats
            if (character.startingStats != null)
              _buildThemedStatsSection(character.startingStats!),

            const SizedBox(height: 24),

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
            const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
            const Divider(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.entries.map((entry) {
                final value = entry.value; // P or M
                return Chip(
                  label: Text('${entry.key}: $value'),
                  backgroundColor: value == 'M' ? Colors.amber[100] : Colors.green[100],
                  labelStyle: const TextStyle(fontSize: 13),
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
        const SizedBox(height: 12),
        _buildStatGroup(
          title: 'MIND',
          color: const Color(0xFF87CDFE),
          stats: stats,
          keys: ['Intellect', 'Acuity', 'Resilience', 'Max Mana'],
        ),
        const SizedBox(height: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: filtered.map((k) => Chip(label: Text('$k: ${stats[k]}'))).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
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
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(value ?? 'Not selected'),
        ],
      ),
    );
  }
}