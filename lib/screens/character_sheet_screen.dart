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
            // Class Portrait (full official art)
            if (character.className != null)
              _buildClassPortrait(character.className!),

            // Pie-style layout with Body on top, Mind & Spirit on bottom
            SizedBox(
              height: 400,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Central Radial Wheel
                  const SizedBox(
                    width: 260,
                    height: 260,
                    child: RadialWheel(),
                  ),

                  // === BODY (Green) - Top third ===
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _buildPieSliceStat(
                        title: 'BODY',
                        color: const Color(0xFF42B278),
                        stats: character.startingStats ?? {},
                        keys: ['Physique', 'Technique', 'Endurance', 'Max Stamina'],
                      ),
                    ),
                  ),

                  // === MIND (Blue) - Bottom-left ===
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 16),
                      child: _buildPieSliceStat(
                        title: 'MIND',
                        color: const Color(0xFF87CDFE),
                        stats: character.startingStats ?? {},
                        keys: ['Intellect', 'Acuity', 'Resilience', 'Max Mana'],
                      ),
                    ),
                  ),

                  // === SPIRIT (Gold) - Bottom-right ===
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12, right: 16),
                      child: _buildPieSliceStat(
                        title: 'SPIRIT',
                        color: const Color(0xFFC3B15B),
                        stats: character.startingStats ?? {},
                        keys: ['Willpower', 'Attunement', 'Resolve', 'Max Morale'],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

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

            const SizedBox(height: 16),

            // Skills
            if (character.skills.isNotEmpty)
              _buildSkillsSection(character.skills),

            const SizedBox(height: 16),

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

  Widget _buildClassPortrait(String className) {
    final imagePath = 'assets/images/class_art/${className.toLowerCase()}.png';

    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          height: 320,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.brown[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 56, color: Colors.brown[300]),
                  const SizedBox(height: 12),
                  Text(
                    'Official art for $className\ncoming soon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.brown[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieSliceStat({
    required String title,
    required Color color,
    required Map<String, dynamic> stats,
    required List<String> keys,
  }) {
    final filtered = keys.where((k) => stats.containsKey(k) && stats[k] != null).toList();
    if (filtered.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.92),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
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