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
          children: [
            const RadialWheel(),
            const SizedBox(height: 20),

            // ABC Summary
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Character Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    _infoRow('Class', character.className),
                    _infoRow('Ancestry', character.ancestry),
                    _infoRow('Background', character.background),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Starting Stats
            if (character.startingStats != null) ...[
              const Text('Starting Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildStatChips(character.startingStats!),
              ),
            ],
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

  List<Widget> _buildStatChips(Map<String, dynamic> stats) {
    final chips = <Widget>[];
    stats.forEach((key, value) {
      chips.add(Chip(label: Text('$key: $value')));
    });
    return chips;
  }
}