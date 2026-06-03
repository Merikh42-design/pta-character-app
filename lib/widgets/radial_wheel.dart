import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/character_provider.dart';

class RadialWheel extends ConsumerWidget {
  const RadialWheel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);
    final stats = character.startingStats;

    if (stats == null) {
      return const Center(
        child: Text('Select a class in the ABC Wizard to see the Radial Wheel'),
      );
    }

    return CustomPaint(
      size: const Size(300, 300),
      painter: _RadialWheelPainter(stats: stats),
    );
  }
}

class _RadialWheelPainter extends CustomPainter {
  final Map<String, dynamic> stats;

  _RadialWheelPainter({required this.stats});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background
    final bgPaint = Paint()
      ..color = const Color(0xFFF5E8C7) // Parchment
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Simple three segments (placeholder for now)
    final segmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;

    // Body - Green
    segmentPaint.color = const Color(0xFF4A7C59);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      -1.57, 2.09, false, segmentPaint,
    );

    // Mind - Blue
    segmentPaint.color = const Color(0xFF3F5E8C);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      0.52, 2.09, false, segmentPaint,
    );

    // Spirit - Gold
    segmentPaint.color = const Color(0xFFC9A94D);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      2.61, 2.09, false, segmentPaint,
    );

    // Center text
    final textPainter = TextPainter(
      text: TextSpan(
        text: stats['Class'] ?? 'Class',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}