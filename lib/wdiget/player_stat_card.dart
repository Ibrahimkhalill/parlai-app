import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parlai/view/grade/player_detail.dart';

class PlayerStatCard extends StatelessWidget {
  final String name;
  final String stat;
  final double progress;
  final Color color;

  const PlayerStatCard({
    Key? key,
    required this.name,
    required this.stat,
    required this.progress,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PlayerDetailScreen()),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15), // Premium rounded look
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.35), // Base glass tint
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.2,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.05),
                ],
              ),
              boxShadow: [
                // Inner dark shadow → content ডুবে থাকবে (inset feel)
                BoxShadow(
                  color: Colors.black.withOpacity(0.7),
                  blurRadius: 20,
                  spreadRadius: -8, // Negative for inner effect
                  offset: const Offset(0, 8),
                ),
                // Top light highlight → border উপরে/raised মনে হবে
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, -6),
                ),
                // Bottom outer shadow for depth
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.trending_up, color: color, size: 18),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stat,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[300],
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 10,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[700]!.withOpacity(0.6),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
