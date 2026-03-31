import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_progress.freezed.dart';
part 'user_progress.g.dart';

@freezed
class DomainMastery with _$DomainMastery {
  const factory DomainMastery({
    required String domain,
    @Default(0.0) double masteryScore,
    @Default(0) int totalReviews,
    @Default(0) int correctQuizAnswers,
    @Default(0) int totalQuizAnswers,
  }) = _DomainMastery;

  factory DomainMastery.fromJson(Map<String, dynamic> json) =>
      _$DomainMasteryFromJson(json);
}

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    DateTime? lastSessionDate,
    @Default(0) int totalSessions,
    @Default(0) int totalReviews,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}

@freezed
class ConfidenceLog with _$ConfidenceLog {
  const factory ConfidenceLog({
    required int id,
    required String conceptId,
    required int confidence,
    required int quality,
    required DateTime timestamp,
  }) = _ConfidenceLog;

  factory ConfidenceLog.fromJson(Map<String, dynamic> json) =>
      _$ConfidenceLogFromJson(json);
}
