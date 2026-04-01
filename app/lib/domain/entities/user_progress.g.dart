// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DomainMasteryImpl _$$DomainMasteryImplFromJson(Map<String, dynamic> json) =>
    _$DomainMasteryImpl(
      domain: json['domain'] as String,
      masteryScore: (json['mastery_score'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      correctQuizAnswers: (json['correct_quiz_answers'] as num?)?.toInt() ?? 0,
      totalQuizAnswers: (json['total_quiz_answers'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DomainMasteryImplToJson(_$DomainMasteryImpl instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'mastery_score': instance.masteryScore,
      'total_reviews': instance.totalReviews,
      'correct_quiz_answers': instance.correctQuizAnswers,
      'total_quiz_answers': instance.totalQuizAnswers,
    };

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
      lastSessionDate: json['last_session_date'] == null
          ? null
          : DateTime.parse(json['last_session_date'] as String),
      totalSessions: (json['total_sessions'] as num?)?.toInt() ?? 0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'current_streak': instance.currentStreak,
      'longest_streak': instance.longestStreak,
      'last_session_date': instance.lastSessionDate?.toIso8601String(),
      'total_sessions': instance.totalSessions,
      'total_reviews': instance.totalReviews,
    };

_$ConfidenceLogImpl _$$ConfidenceLogImplFromJson(Map<String, dynamic> json) =>
    _$ConfidenceLogImpl(
      id: (json['id'] as num).toInt(),
      conceptId: json['concept_id'] as String,
      confidence: (json['confidence'] as num).toInt(),
      quality: (json['quality'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ConfidenceLogImplToJson(_$ConfidenceLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'concept_id': instance.conceptId,
      'confidence': instance.confidence,
      'quality': instance.quality,
      'timestamp': instance.timestamp.toIso8601String(),
    };
