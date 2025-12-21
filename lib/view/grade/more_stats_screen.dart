import 'package:flutter/material.dart';
import 'package:parlai/wdiget/glass_back_button.dart';

class MoreStatsScreen extends StatelessWidget {
  const MoreStatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Row(
                  children: [
                    GlassBackButton(),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'More',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Season Average vs Line Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(0, 188, 125, 0.05),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        color: Color.fromRGBO(0, 188, 125, 0.05),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bar_chart,
                                color: const Color(0xFF00D492),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Season Average vs Line',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9F9FA9),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Season Avg',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '28.3',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'vs',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Prop Line',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '27.5',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00D492),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Last 10 Games Performance
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Last 10 Games Performance',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Chart
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(39, 39, 42, 0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromRGBO(39, 39, 42, 0.3),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 180,
                            child: CustomPaint(
                              size: const Size(double.infinity, 180),
                              painter: LineChartPainter(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Game 1',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Game 10',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              ScoreLabel(value: '24'),
                              ScoreLabel(value: '31', highlighted: true),
                              ScoreLabel(value: '27'),
                              ScoreLabel(value: '33', highlighted: true),
                              ScoreLabel(value: '29'),
                              ScoreLabel(value: '26'),
                              ScoreLabel(value: '34', highlighted: true),
                              ScoreLabel(value: '28'),
                              ScoreLabel(value: '32', highlighted: true),
                              ScoreLabel(value: '30'),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // vs This Opponent
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(39, 39, 42, 0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromRGBO(39, 39, 42, 0.3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'vs This Opponent (Season)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '31.5 PPG',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Line Movement
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(39, 39, 42, 0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromRGBO(39, 39, 42, 0.3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.grey[600],
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Line Movement',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Line opened at 26.5, moved to 27.5',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Injury & Rest
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(39, 39, 42, 0.3),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromRGBO(39, 39, 42, 0.3),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Injury Status',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Fully healthy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(39, 39, 42, 0.3),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromRGBO(39, 39, 42, 0.3),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rest',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '1 day rest',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Game Tempo & Defense
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(39, 39, 42, 0.3),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromRGBO(39, 39, 42, 0.3),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Game Tempo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Fast pace (102.3)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(39, 39, 42, 0.3),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromRGBO(39, 39, 42, 0.3),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Opp Defense',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '28th',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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

class ScoreLabel extends StatelessWidget {
  final String value;
  final bool highlighted;

  const ScoreLabel({super.key, required this.value, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: highlighted ? const Color(0xFF00D492) : Colors.grey[600],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D492)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pointPaint = Paint()
      ..color = const Color(0xFF00D492)
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = Color.fromRGBO(39, 39, 42, 0.3)
      ..style = PaintingStyle.fill;

    // Data points (normalized)
    final data = [24, 31, 27, 33, 29, 26, 34, 28, 32, 30];
    final minVal = 24.0;
    final maxVal = 34.0;
    final range = maxVal - minVal;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - ((data[i] - minVal) / range) * (size.height - 30);
      points.add(Offset(x, y));
    }

    // Draw line
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, paint);

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 2.5, dotPaint);
    }

    // Draw dashed line at bottom
    final dashPaint = Paint()
      ..color = const Color(0xFF00D492)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dashPath = Path()
      ..moveTo(0, size.height - 20)
      ..lineTo(size.width, size.height - 20);

    _drawDashedLine(canvas, dashPath, dashPaint);
  }

  void _drawDashedLine(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    final pathMetrics = path.computeMetrics();

    for (final pathMetric in pathMetrics) {
      var distance = 0.0;
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => false;
}
