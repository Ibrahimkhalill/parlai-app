import 'package:flutter/material.dart';
import 'package:parlai/wdiget/player_stat_card.dart';

class GradeScreen extends StatelessWidget {
  const GradeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Icon
                Image.asset('assets/images/logo.png', width: 80, height: 80),

                const SizedBox(height: 30),
                // Title
                const Text(
                  'Your ParlAI Performance\nScore',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                // Circular Progress
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(180, 180),
                        painter: GradientCircularProgressPainter(
                          progress: 0.92,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '92',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Out of 100',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Player Stats
                PlayerStatCard(
                  name: 'G. LIMON',
                  stat: 'PTS over 22.5',
                  progress: 0.85,
                  color: const Color(0xFF4CAF50),
                ),
                const SizedBox(height: 16),
                PlayerStatCard(
                  name: 'M. Lewis',
                  stat: 'AST Under 6.5',
                  progress: 0.65,
                  color: const Color(0xFF66BB6A),
                ),
                const SizedBox(height: 16),
                PlayerStatCard(
                  name: 'A. Barnes',
                  stat: 'REB Over 10.5',
                  progress: 0.45,
                  color: const Color(0xFFFFC107),
                ),
                const SizedBox(height: 16),
                PlayerStatCard(
                  name: 'P. Mitchell',
                  stat: '3PM Under 3.5',
                  progress: 0.25,
                  color: const Color(0xFFEF5350),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0

  GradientCircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 20.0;
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth / 2;

    /// =========================
    /// Background ring
    /// =========================
    final bgPaint = Paint()
      ..color = const Color(0xFF1E3D22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    /// =========================
    /// Arc geometry
    /// =========================
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -1.57; // top
    final sweepAngle = (2 * 3.1415926 * progress) - 0.25; // small gap

    /// =========================
    /// Glow shadow (draw FIRST)
    /// =========================
    final glowPaint = Paint()
      ..shader = const SweepGradient(
        colors: [Color(0xFF00FF6A), Color(0xFF7CFF3A)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);

    /// =========================
    /// Main gradient ring
    /// =========================
    final ringPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -1.57,
        endAngle: 4.71,
        colors: [
          Color(0xFF7CFF3A), // bright green
          Color(0xFF3EE577), // mid green
          Color(0xFF7CFF3A),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
