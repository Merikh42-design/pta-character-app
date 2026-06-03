import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/character_provider.dart';

class RadialWheel extends ConsumerWidget {
  const RadialWheel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    return Column(
      children: [
        CustomPaint(
          size: const Size(280, 280),
          painter: _RadialWheelPainter(),
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Class', character.className),
        _buildInfoRow('Ancestry', character.ancestry),
        _buildInfoRow('Background', character.background),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'Not selected'),
        ],
      ),
    );
  }
}

class _RadialWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Parchment background
    final bgPaint = Paint()
      ..color = const Color(0xFFF5E8C7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Three colored segments
    final segmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 38;

    // Body - Green
    segmentPaint.color = const Color(0xFF4A7C59);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 18), -1.57, 2.09, false, segmentPaint);

    // Mind - Blue
    segmentPaint.color = const Color(0xFF3F5E8C);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 18), 0.52, 2.09, false, segmentPaint);

    // Spirit - Gold
    segmentPaint.color = const Color(0xFFC9A94D);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 18), 2.61, 2.09, false, segmentPaint);

    // Center label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Body / Mind / Spirit',
        style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}