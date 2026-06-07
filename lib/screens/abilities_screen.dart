import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/character_provider.dart';

class AbilitiesScreen extends ConsumerWidget {
  const AbilitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Abilities & Features'),
          backgroundColor: Colors.brown[800],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Actions'),
              Tab(text: 'Maneuvers'),
              Tab(text: 'Spells'),
              Tab(text: 'Chants'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildActionsTab(character),
            _buildManeuversTab(character),
            _buildSpellsTab(character),
            _buildChantsTab(character),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsTab(character) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAbilitySection('Free Actions', character.freeActions),
          const SizedBox(height: 24),
          _buildAbilitySection('Reactions', character.reactions),
        ],
      ),
    );
  }

  Widget _buildManeuversTab(character) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAbilitySection('Martial Attack Maneuvers', character.martialManeuvers),
          const SizedBox(height: 16),
          _buildAbilitySection('Projectile Attack Maneuvers', character.projectileManeuvers),
          const SizedBox(height: 16),
          _buildAbilitySection('Tactical Maneuvers', character.tacticalManeuvers),
          const SizedBox(height: 16),
          _buildAbilitySection('Skill Maneuvers', character.skillManeuvers),
        ],
      ),
    );
  }

  Widget _buildSpellsTab(character) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAbilitySection('Attack Spells', character.attackSpells),
          const SizedBox(height: 16),
          _buildAbilitySection('Tactical Spells', character.tacticalSpells),
          const SizedBox(height: 16),
          _buildAbilitySection('Skill Spells', character.skillSpells),
        ],
      ),
    );
  }

  Widget _buildChantsTab(character) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAbilitySection('Attack Chants', character.attackChants),
          const SizedBox(height: 16),
          _buildAbilitySection('Tactical Chants', character.tacticalChants),
          const SizedBox(height: 16),
          _buildAbilitySection('Skill Chants', character.skillChants),
        ],
      ),
    );
  }

  Widget _buildAbilitySection(String title, List<Map<String, dynamic>> abilities) {
    if (abilities.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('No $title available for this class.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown[800])),
        const SizedBox(height: 8),
        ...abilities.map((ability) => _buildExpandableAbilityCard(ability)).toList(),
      ],
    );
  }

  Widget _buildExpandableAbilityCard(Map<String, dynamic> ability) {
    final name = ability['name'] ?? 'Unknown';
    final skill = ability['skill'] ?? '';
    final cost = ability['cost'] ?? '';
    final trigger = ability['trigger'] ?? '';
    final effect = ability['effect'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (cost.isNotEmpty)
              Chip(
                label: Text(cost, style: const TextStyle(fontSize: 12)),
                visualDensity: VisualDensity.compact,
                backgroundColor: Colors.brown[100],
              ),
          ],
        ),
        subtitle: skill.isNotEmpty ? Text('Skill: $skill', style: const TextStyle(fontSize: 13, color: Colors.grey)) : null,
        children: [
          if (trigger.isNotEmpty || effect.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (trigger.isNotEmpty)
                    Text('Trigger: $trigger', style: const TextStyle(fontSize: 14)),
                  if (effect.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('Effect: $effect', style: const TextStyle(fontSize: 14)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}