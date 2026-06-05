import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../services/data_service.dart';

class CharacterNotifier extends Notifier<Character> {
  @override
  Character build() => const Character();

  Future<void> selectClass(String className) async {
    // Load starting stats
    final stats = await DataService.getClassByName(className);

    // Load and filter all abilities for this class
    final freeActions = await DataService.getFreeActionsForClass(className);
    final reactions = await DataService.getReactionsForClass(className);
    final martialManeuvers = await DataService.getMartialManeuversForClass(className);
    final projectileManeuvers = await DataService.getProjectileManeuversForClass(className);
    final tacticalManeuvers = await DataService.getTacticalManeuversForClass(className);
    final skillManeuvers = await DataService.getSkillManeuversForClass(className);
    final attackSpells = await DataService.getAttackSpellsForClass(className);
    final tacticalSpells = await DataService.getTacticalSpellsForClass(className);
    final skillSpells = await DataService.getSkillSpellsForClass(className);
    final attackChants = await DataService.getAttackChantsForClass(className);
    final tacticalChants = await DataService.getTacticalChantsForClass(className);
    final skillChants = await DataService.getSkillChantsForClass(className);

    state = state.copyWith(
      className: className,
      startingStats: stats,
      freeActions: freeActions,
      reactions: reactions,
      martialManeuvers: martialManeuvers,
      projectileManeuvers: projectileManeuvers,
      tacticalManeuvers: tacticalManeuvers,
      skillManeuvers: skillManeuvers,
      attackSpells: attackSpells,
      tacticalSpells: tacticalSpells,
      skillSpells: skillSpells,
      attackChants: attackChants,
      tacticalChants: tacticalChants,
      skillChants: skillChants,
    );
  }

  Future<void> selectAncestry(String ancestryName) async {
    state = state.copyWith(ancestry: ancestryName);
  }

  Future<void> selectBackground(String backgroundName) async {
    state = state.copyWith(background: backgroundName);
  }
}

final characterProvider = NotifierProvider<CharacterNotifier, Character>(
  CharacterNotifier.new,
);