import 'package:flutter/material.dart';
import 'package:parlai/controller/home/home_controller.dart';
import 'package:parlai/view/grade/more_stats_screen.dart';
import 'package:parlai/wdiget/glass_back_button.dart';
import 'package:parlai/wdiget/primaryButton.dart';

class FullAnalysisScreen extends StatelessWidget {
  final BetAnalysis betData;

  const FullAnalysisScreen({Key? key, required this.betData}) : super(key: key);

  Color _getRiskColor(String riskLevel) {
    if (riskLevel == "Safe") return const Color(0xFF4CAF50);
    if (riskLevel == "Moderate") return const Color(0xFFFFC107);
    return const Color(0xFFEF5350);
  }

  Color _getMatchupColor(String difficulty) {
    if (difficulty == "Great" || difficulty == "Easy") {
      return const Color(0xFF4CAF50);
    }
    if (difficulty == "Moderate" || difficulty == "Good") {
      return const Color(0xFFFFC107);
    }
    return const Color(0xFFEF5350);
  }

  @override
  Widget build(BuildContext context) {
    final stats = betData.advancedStats;
    final riskColor = _getRiskColor(betData.riskLevel);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Row(
                    children: [
                      GlassBackButton(),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Full Analysis',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Main Analysis Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[800]!, width: 1),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Player header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                betData.playerName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                betData.propDescription,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.trending_up, color: riskColor, size: 20),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 8,
                          child: LinearProgressIndicator(
                            value: betData.confidenceScore / 100,
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              riskColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Analysis items from API
                      AnalysisItem(
                        icon: Icons.schedule,
                        title: 'Expected minutes: ${stats.expectedMinutes}',
                      ),
                      const SizedBox(height: 16),

                      AnalysisItem(
                        icon: Icons.bar_chart,
                        title:
                            'Avg vs opponent: ${stats.avgVsOpponent} (line ${betData.playerPoint})',
                      ),
                      const SizedBox(height: 16),

                      AnalysisItem(
                        icon: Icons.trending_up,
                        title: stats.usageRateChange,
                      ),
                      const SizedBox(height: 16),

                      AnalysisItem(
                        icon: Icons.shield,
                        title: 'Matchup difficulty: ',
                        highlightText: stats.matchupDifficulty,
                        highlightColor: _getMatchupColor(
                          stats.matchupDifficulty,
                        ),
                      ),
                      const SizedBox(height: 16),

                      AnalysisItem(
                        icon: Icons.location_on,
                        title: 'Home / Away split: ${stats.homeAwaySplit}',
                      ),
                      const SizedBox(height: 16),

                      AnalysisItem(
                        icon: Icons.healing,
                        title: 'Injury status: ',
                        highlightText: stats.injuryStatus,
                        highlightColor: stats.injuryStatus == "Fully healthy"
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFEF5350),
                      ),
                      const SizedBox(height: 16),

                      AnalysisItem(
                        icon: Icons.calendar_today,
                        title: 'Days rest: ${stats.daysRest}',
                      ),
                      const SizedBox(height: 16),

                      AnalysisItem(
                        icon: Icons.speed,
                        title: 'Game tempo: ${stats.gameTempo}',
                      ),
                      const SizedBox(height: 16),

                      AnalysisItem(
                        icon: Icons.sports,
                        title:
                            'Opponent defense rank: ${stats.opponentDefenseRank}',
                      ),
                      const SizedBox(height: 16),

                      AnalysisItem(
                        icon: Icons.show_chart,
                        title: stats.lineMovement,
                      ),

                      const SizedBox(height: 32),

                      // View even more stats button
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          label: "View Even More Stats",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MoreStatsScreen(betData: betData),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnalysisItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? highlightText;
  final Color? highlightColor;

  const AnalysisItem({
    Key? key,
    required this.icon,
    required this.title,
    this.highlightText,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, right: 12),
          child: Icon(icon, color: Colors.grey[600], size: 20),
        ),
        Expanded(
          child: highlightText != null
              ? RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[300],
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: highlightText,
                        style: TextStyle(
                          fontSize: 14,
                          color: highlightColor,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  title,
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
