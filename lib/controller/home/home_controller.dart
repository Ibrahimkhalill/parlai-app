import 'dart:io';
import 'package:dio/dio.dart';
import 'package:parlai/wdiget/appCredentilas.dart';

class HomeController {
  late final Dio dio;
  // -----------------------
  // Analyze Betting Slip
  // -----------------------
  Future<SlipAnalysisResponse> analyzeSlip({required File imageFile}) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await Dio().post(
        '$aiBaseUrl/api/v1/analyze-slip',
        data: formData, // ✅ FIX HERE
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      return SlipAnalysisResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      throw _handleError(e);
    }
  }

  // -----------------------
  // Error Handling
  // -----------------------
  Exception _handleError(dynamic e) {
    if (e is DioException) {
      return Exception(e.message ?? "Something went wrong");
    }
    return Exception(e.toString());
  }
}

// -----------------------
// Response Models
// -----------------------
class SlipAnalysisResponse {
  final int overallParlayScore;
  final List<BetAnalysis> bets;

  SlipAnalysisResponse({required this.overallParlayScore, required this.bets});

  factory SlipAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return SlipAnalysisResponse(
      overallParlayScore: json['overall_parlay_score'] ?? 0,
      bets:
          (json['bets'] as List?)
              ?.map((bet) => BetAnalysis.fromJson(bet))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall_parlay_score': overallParlayScore,
      'bets': bets.map((bet) => bet.toJson()).toList(),
    };
  }
}

class BetAnalysis {
  final String playerName;
  final String propDescription;
  final double playerPoint;
  final int confidenceScore;
  final String riskLevel;
  final List<String> insights;
  final AdvancedStats advancedStats;
  final Last10Graph last10Graph;

  BetAnalysis({
    required this.playerName,
    required this.propDescription,
    required this.playerPoint,
    required this.confidenceScore,
    required this.riskLevel,
    required this.insights,
    required this.advancedStats,
    required this.last10Graph,
  });

  factory BetAnalysis.fromJson(Map<String, dynamic> json) {
    return BetAnalysis(
      playerName: json['player_name'] ?? '',
      propDescription: json['prop_description'] ?? '',
      playerPoint: (json['player_point'] ?? 0).toDouble(),
      confidenceScore: json['confidence_score'] ?? 0,
      riskLevel: json['risk_level'] ?? '',
      insights: (json['insights'] as List?)?.cast<String>() ?? [],
      advancedStats: AdvancedStats.fromJson(json['advanced_stats'] ?? {}),
      last10Graph: Last10Graph.fromJson(json['last_10_graph'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_name': playerName,
      'prop_description': propDescription,
      'player_point': playerPoint,
      'confidence_score': confidenceScore,
      'risk_level': riskLevel,
      'insights': insights,
      'advanced_stats': advancedStats.toJson(),
      'last_10_graph': last10Graph.toJson(),
    };
  }
}

class AdvancedStats {
  final String expectedMinutes;
  final double avgVsOpponent;
  final String usageRateChange;
  final String matchupDifficulty;
  final String homeAwaySplit;
  final String injuryStatus;
  final String daysRest;
  final String gameTempo;
  final String opponentDefenseRank;
  final String lineMovement;

  AdvancedStats({
    required this.expectedMinutes,
    required this.avgVsOpponent,
    required this.usageRateChange,
    required this.matchupDifficulty,
    required this.homeAwaySplit,
    required this.injuryStatus,
    required this.daysRest,
    required this.gameTempo,
    required this.opponentDefenseRank,
    required this.lineMovement,
  });

  factory AdvancedStats.fromJson(Map<String, dynamic> json) {
    return AdvancedStats(
      expectedMinutes: json['expected_minutes'] ?? '',
      avgVsOpponent: (json['avg_vs_opponent'] ?? 0).toDouble(),
      usageRateChange: json['usage_rate_change'] ?? '',
      matchupDifficulty: json['matchup_difficulty'] ?? '',
      homeAwaySplit: json['home_away_split'] ?? '',
      injuryStatus: json['injury_status'] ?? '',
      daysRest: json['days_rest'] ?? '',
      gameTempo: json['game_tempo'] ?? '',
      opponentDefenseRank: json['opponent_defense_rank'] ?? '',
      lineMovement: json['line_movement'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expected_minutes': expectedMinutes,
      'avg_vs_opponent': avgVsOpponent,
      'usage_rate_change': usageRateChange,
      'matchup_difficulty': matchupDifficulty,
      'home_away_split': homeAwaySplit,
      'injury_status': injuryStatus,
      'days_rest': daysRest,
      'game_tempo': gameTempo,
      'opponent_defense_rank': opponentDefenseRank,
      'line_movement': lineMovement,
    };
  }
}

class Last10Graph {
  final List<String> labels;
  final List<int> values;
  final double trendLine;

  Last10Graph({
    required this.labels,
    required this.values,
    required this.trendLine,
  });

  factory Last10Graph.fromJson(Map<String, dynamic> json) {
    return Last10Graph(
      labels: (json['labels'] as List?)?.cast<String>() ?? [],
      values: (json['values'] as List?)?.cast<int>() ?? [],
      trendLine: (json['trend_line'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'labels': labels, 'values': values, 'trend_line': trendLine};
  }
}

// Global instance
final homeController = HomeController();
