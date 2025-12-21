import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parlai/view/grade/full_analysis_screen.dart';

import 'package:parlai/wdiget/glass_back_button.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class PlayerDetailScreen extends StatelessWidget {
  const PlayerDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: Row(children: [GlassBackButton()]),
              ),
              const SizedBox(height: 20),
              // Hexagon with helmet icon
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Stack(
                  alignment: Alignment.center,
                  children: [Image.asset('assets/images/player.png')],
                ),
              ),
              const SizedBox(height: 32),
              // Player name
              const Text(
                'G. LIMON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              // Stat description
              Text(
                'Points - Higher than 22.5',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
              const SizedBox(height: 40),
              // Analysis section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Analysis header
                    const Text(
                      'ANALYSIS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Analysis points
                    AnalysisPoint(
                      text: 'Projected to contribute as main scoring option.',
                    ),
                    const SizedBox(height: 16),
                    AnalysisPoint(
                      text: 'Averaging 24.5 PPG over the last 10 games.',
                    ),
                    const SizedBox(height: 16),
                    AnalysisPoint(
                      text: 'Facing a team with a below average defense.',
                    ),
                    const SizedBox(height: 16),
                    AnalysisPoint(
                      text:
                          'Expected to play 35+ minutes in close-fought contest',
                    ),
                    const SizedBox(height: 16),
                    AnalysisPoint(
                      text:
                          'Expected to play 35+ minutes in close-fought contest',
                    ),
                    const SizedBox(height: 40),
                    // Full analysis button
                    SizedBox(
                      width: double.infinity,

                      child: PrimaryButton(
                        label: "Full analysis",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FullAnalysisScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnalysisPoint extends StatelessWidget {
  final String text;

  const AnalysisPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 12),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final Color glowColor;

  HexagonPainter({required this.color, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw glow effect
    final glowPaint = Paint()
      ..color = glowColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 1.1, glowPaint);

    // Draw hexagon outline
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * 3.14159 / 180;
      final x = center.dx + radius * 0.85 * cos(angle);
      final y = center.dy + radius * 0.85 * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HexagonPainter oldDelegate) => false;
}
