import 'package:flutter/material.dart';

class CharacterSheetScreen extends StatelessWidget {
  const CharacterSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pathways to Adventure')),
      body: const Center(
        child: Text(
          'Skeleton Ready!\n\nRadial Wheel + ABC Wizard coming next...',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
