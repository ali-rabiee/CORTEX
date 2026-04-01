// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionConfigImpl _$$SessionConfigImplFromJson(Map<String, dynamic> json) =>
    _$SessionConfigImpl(
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 30,
      warmupCards: (json['warmup_cards'] as num?)?.toInt() ?? 4,
      coreReviewCards: (json['core_review_cards'] as num?)?.toInt() ?? 10,
      challengeQuestions: (json['challenge_questions'] as num?)?.toInt() ?? 5,
    );

Map<String, dynamic> _$$SessionConfigImplToJson(_$SessionConfigImpl instance) =>
    <String, dynamic>{
      'duration_minutes': instance.durationMinutes,
      'warmup_cards': instance.warmupCards,
      'core_review_cards': instance.coreReviewCards,
      'challenge_questions': instance.challengeQuestions,
    };

_$SessionResultImpl _$$SessionResultImplFromJson(Map<String, dynamic> json) =>
    _$SessionResultImpl(
      cardsReviewed: (json['cards_reviewed'] as num).toInt(),
      quizCorrect: (json['quiz_correct'] as num).toInt(),
      quizTotal: (json['quiz_total'] as num).toInt(),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      averageQuality: (json['average_quality'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$SessionResultImplToJson(_$SessionResultImpl instance) =>
    <String, dynamic>{
      'cards_reviewed': instance.cardsReviewed,
      'quiz_correct': instance.quizCorrect,
      'quiz_total': instance.quizTotal,
      'duration_minutes': instance.durationMinutes,
      'average_quality': instance.averageQuality,
      'date': instance.date.toIso8601String(),
    };
