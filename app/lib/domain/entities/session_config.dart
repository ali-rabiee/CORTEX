import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_config.freezed.dart';
part 'session_config.g.dart';

/// Phases of a daily training session.
enum SessionPhase { warmup, coreReview, challenge, cooldown }

@freezed
class SessionConfig with _$SessionConfig {
  const factory SessionConfig({
    @Default(30) int durationMinutes,
    @Default(4) int warmupCards,
    @Default(10) int coreReviewCards,
    @Default(5) int challengeQuestions,
  }) = _SessionConfig;

  factory SessionConfig.fromJson(Map<String, dynamic> json) =>
      _$SessionConfigFromJson(json);
}

@freezed
class SessionResult with _$SessionResult {
  const factory SessionResult({
    required int cardsReviewed,
    required int quizCorrect,
    required int quizTotal,
    required int durationMinutes,
    required double averageQuality,
    required DateTime date,
  }) = _SessionResult;

  factory SessionResult.fromJson(Map<String, dynamic> json) =>
      _$SessionResultFromJson(json);
}
