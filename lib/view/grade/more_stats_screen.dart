import 'package:flutter/material.dart';
import 'package:parlai/controller/home/home_controller.dart';
import 'package:parlai/wdiget/glass_back_button.dart';

class MoreStatsScreen extends StatelessWidget {
  final BetAnalysis betData;

  const MoreStatsScreen({Key? key, required this.betData}) : super(key: key);

  // Calculate season average from last 10 games
  double _calculateSeasonAverage() {
    if (betData.last10Graph.values.isEmpty) return 0.0;
    final sum = betData.last10Graph.values.reduce((a, b) => a + b);
    return sum / betData.last10Graph.values.length;
  }

  @override
  Widget build(BuildContext context) {
    final stats = betData.advancedStats;
    final seasonAvg = _calculateSeasonAverage();

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
                          'More Stats',
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
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    seasonAvg.toStringAsFixed(1),
                                    style: const TextStyle(
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
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    betData.playerPoint.toStringAsFixed(1),
                                    style: const TextStyle(
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
                              painter: LineChartPainter(
                                data: betData.last10Graph.values,
                                trendLine: betData.last10Graph.trendLine,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                betData.last10Graph.labels.isNotEmpty
                                    ? betData.last10Graph.labels.first
                                    : 'Game 1',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                betData.last10Graph.labels.isNotEmpty
                                    ? betData.last10Graph.labels.last
                                    : 'Game 10',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: betData.last10Graph.values
                                .map(
                                  (value) => ScoreLabel(
                                    value: value.toString(),
                                    highlighted: value > betData.playerPoint,
                                  ),
                                )
                                .toList(),
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
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${stats.avgVsOpponent.toStringAsFixed(1)} AVG',
                            style: const TextStyle(
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
                            stats.lineMovement,
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
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  stats.injuryStatus,
                                  style: const TextStyle(
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
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  stats.daysRest,
                                  style: const TextStyle(
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
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  stats.gameTempo,
                                  style: const TextStyle(
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
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  stats.opponentDefenseRank,
                                  style: const TextStyle(
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
  final List<int> data;
  final double trendLine;

  LineChartPainter({required this.data, required this.trendLine});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

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

    // Calculate min and max for normalization
    final minVal = data.reduce((a, b) => a < b ? a : b).toDouble();
    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();
    final range = maxVal - minVal;

    final path = Path();
    final points = <Offset>[];

    // Create points
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = range > 0
          ? size.height - ((data[i] - minVal) / range) * (size.height - 30)
          : size.height / 2;
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

    // Draw trend line (dashed)
    final trendY = range > 0
        ? size.height - ((trendLine - minVal) / range) * (size.height - 30)
        : size.height / 2;

    final dashPaint = Paint()
      ..color = const Color(0xFF00D492)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dashPath = Path()
      ..moveTo(0, trendY)
      ..lineTo(size.width, trendY);

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
  bool shouldRepaint(LineChartPainter oldDelegate) =>
      data != oldDelegate.data || trendLine != oldDelegate.trendLine;
}
