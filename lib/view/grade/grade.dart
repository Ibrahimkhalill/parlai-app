import 'package:flutter/material.dart';
import 'package:parlai/controller/home/home_controller.dart';
import 'package:parlai/wdiget/player_stat_card.dart';

class GradeScreen extends StatefulWidget {
  final SlipAnalysisResponse result;

  const GradeScreen({Key? key, required this.result}) : super(key: key);

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<int> _scoreAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation =
        Tween<double>(
          begin: 0.0,
          end: widget.result.overallParlayScore / 100,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _scoreAnimation = IntTween(begin: 0, end: widget.result.overallParlayScore)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getColorForScore(String score) {
    if (score == "Safe") return const Color(0xFF4CAF50); // Green - Safe
    if (score == "Moderate") return const Color(0xFFFFC107); // Yellow - Medium
    return const Color(0xFFEF5350); // Red - Risky
  }

  @override
  Widget build(BuildContext context) {
    final bets = widget.result.bets;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

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

                // Animated Circular Progress
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(180, 180),
                            painter: GradientCircularProgressPainter(
                              progress: _progressAnimation.value,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${_scoreAnimation.value}',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Out of 100',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 50),

                // Player Stats from API
                if (bets.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No bets found in the slip',
                      style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 16),
                    ),
                  )
                else
                  ...bets.asMap().entries.map((entry) {
                    final bet = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PlayerStatCard(
                        name: bet.playerName,
                        stat: bet.propDescription,
                        progress: bet.confidenceScore / 100,
                        color: _getColorForScore(bet.riskLevel),
                        riskLevel: bet.riskLevel,
                        confidenceScore: bet.confidenceScore,
                        betData: bet,
                      ),
                    );
                  }).toList(),

                const SizedBox(height: 30),
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

    /// Background ring
    final bgPaint = Paint()
      ..color = const Color(0xFF1E3D22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Only draw progress arc if progress > 0
    if (progress > 0) {
      /// Arc geometry
      final rect = Rect.fromCircle(center: center, radius: radius);
      const startAngle = -1.57; // top
      final sweepAngle = (2 * 3.1415926 * progress) - 0.25; // small gap

      /// Glow shadow (draw FIRST)
      final glowPaint = Paint()
        ..shader = const SweepGradient(
          colors: [Color(0xFF00FF6A), Color(0xFF7CFF3A)],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

      canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);

      /// Main gradient ring
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
