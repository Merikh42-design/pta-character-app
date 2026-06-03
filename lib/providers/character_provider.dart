import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../services/data_service.dart';

class CharacterNotifier extends Notifier<Character> {
  @override
  Character build() => const Character();

  Future<void> selectClass(String className) async {
    final stats = await DataService.getClassByName(className);
    state = state.copyWith(
      className: className,
      startingStats: stats,
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