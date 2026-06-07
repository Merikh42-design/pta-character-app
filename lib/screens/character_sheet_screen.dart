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
            // Artistic layout: Wheel in center with stats surrounding it
            SizedBox(
              height: 380,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Central Radial Wheel with knot
                  const SizedBox(
                    width: 280,
                    height: 280,
                    child: RadialWheel(),
                  ),

                  // BODY stats - positioned bottom-left of wheel
                  Positioned(
                    left: 10,
                    bottom: 20,
                    child: _buildCompactStatGroup(
                      title: 'BODY',
                      color: const Color(0xFF42B278),
                      stats: character.startingStats ?? {},
                      keys: ['Physique', 'Technique', 'Endurance', 'Max Stamina'],
                    ),
                  ),

                  // MIND stats - positioned top-left of wheel
                  Positioned(
                    left: 10,
                    top: 20,
                    child: _buildCompactStatGroup(
                      title: 'MIND',
                      color: const Color(0xFF87CDFE),
                      stats: character.startingStats ?? {},
                      keys: ['Intellect', 'Acuity', 'Resilience', 'Max Mana'],
                    ),
                  ),

                  // SPIRIT stats - positioned right side of wheel
                  Positioned(
                    right: 10,
                    top: 60,
                    child: _buildCompactStatGroup(
                      title: 'SPIRIT',
                      color: const Color(0xFFC3B15B),
                      stats: character.startingStats ?? {},
                      keys: ['Willpower', 'Attunement', 'Resolve', 'Max Morale'],
                    ),
                  ),
                ],
              ),
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

            // Skills
            if (character.skills.isNotEmpty)
              _buildSkillsSection(character.skills),

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

  Widget _buildCompactStatGroup({
    required String title,
    required Color color,
    required Map<String, dynamic> stats,
    required List<String> keys,
  }) {
    final filtered = keys.where((k) => stats.containsKey(k) && stats[k] != null).toList();
    if (filtered.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 3,
      color: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            ...filtered.map((k) => Text('$k: ${stats[k]}', style: const TextStyle(fontSize: 12, color: Colors.black87))).toList(),
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