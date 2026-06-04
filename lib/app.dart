import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/theme_provider.dart';
import 'screens/character_sheet_screen.dart';
import 'screens/abc_wizard_screen.dart';

class PtaApp extends ConsumerWidget {
  const PtaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Pathways to Adventure',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const ABCWizardScreen(),
        '/character_sheet': (context) => const CharacterSheetScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
