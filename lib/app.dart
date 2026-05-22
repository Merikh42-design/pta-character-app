import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/theme_provider.dart';
import 'features/sheet/screens/character_sheet_screen.dart';

class PtaApp extends ConsumerWidget {
  const PtaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Pathways to Adventure',
      theme: theme,
      home: const CharacterSheetScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
