import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parlai/controller/home/home_controller.dart';
import 'package:parlai/view/grade/full_analysis_screen.dart';
import 'package:parlai/wdiget/glass_back_button.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class PlayerDetailScreen extends StatelessWidget {
  final BetAnalysis? betData;

  const PlayerDetailScreen({Key? key, this.betData}) : super(key: key);

  Color _getRiskColor(String riskLevel) {
    if (riskLevel == "Safe") return const Color(0xFF4CAF50);
    if (riskLevel == "Moderate") return const Color(0xFFFFC107);
    return const Color(0xFFEF5350);
  }

  @override
  Widget build(BuildContext context) {
    // Show error state if no data
    if (betData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'No player data available',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final riskColor = _getRiskColor(betData!.riskLevel);

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

              // Player avatar
              Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Stack(
                  alignment: Alignment.center,
                  children: [Image.asset('assets/images/player.png')],
                ),
              ),
              const SizedBox(height: 22),

              // Player name
              Text(
                betData!.playerName.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),

              // Stat description
              Text(
                betData!.propDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              // Confidence badge
              const SizedBox(height: 30),

              // Analysis section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Analysis header
                    Center(
                      child: Text(
                        'ANALYSIS',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(133, 240, 172, 1),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Analysis points from API
                    if (betData!.insights.isEmpty)
                      const Text(
                        'No insights available',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      )
                    else
                      ...betData!.insights.map((insight) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: AnalysisPoint(
                            text: insight,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),

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
                              builder: (_) =>
                                  FullAnalysisScreen(betData: betData!),
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
  final Color color;

  const AnalysisPoint({
    Key? key,
    required this.text,
    this.color = const Color(0xFF4CAF50),
  }) : super(key: key);

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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
