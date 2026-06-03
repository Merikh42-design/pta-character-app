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
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Painted wheel (segments + parchment)
              CustomPaint(
                size: const Size(280, 280),
                painter: _RadialWheelPainter(),
              ),
              // Celtic knot logo in the center
              Image.asset(
                'assets/images/paths_knot.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ],
          ),
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

    // Three colored segments using official colors from Jon
    final segmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 38;

    // Body - Green #42b278
    segmentPaint.color = const Color(0xFF42b278);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 18), -1.57, 2.09, false, segmentPaint);

    // Mind - Blue #87cdfe
    segmentPaint.color = const Color(0xFF87cdfe);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 18), 0.52, 2.09, false, segmentPaint);

    // Spirit - Gold #c3b15b
    segmentPaint.color = const Color(0xFFc3b15b);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 18), 2.61, 2.09, false, segmentPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}