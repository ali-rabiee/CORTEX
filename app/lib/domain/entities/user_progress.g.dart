// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DomainMasteryImpl _$$DomainMasteryImplFromJson(Map<String, dynamic> json) =>
    _$DomainMasteryImpl(
      domain: json['domain'] as String,
      masteryScore: (json['masteryScore'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      correctQuizAnswers: (json['correctQuizAnswers'] as num?)?.toInt() ?? 0,
      totalQuizAnswers: (json['totalQuizAnswers'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DomainMasteryImplToJson(_$DomainMasteryImpl instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'masteryScore': instance.masteryScore,
      'totalReviews': instance.totalReviews,
      'correctQuizAnswers': instance.correctQuizAnswers,
      'totalQuizAnswers': instance.totalQuizAnswers,
    };

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastSessionDate: json['lastSessionDate'] == null
          ? null
          : DateTime.parse(json['lastSessionDate'] as String),
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastSessionDate': instance.lastSessionDate?.toIso8601String(),
      'totalSessions': instance.totalSessions,
      'totalReviews': instance.totalReviews,
    };

_$ConfidenceLogImpl _$$ConfidenceLogImplFromJson(Map<String, dynamic> json) =>
    _$ConfidenceLogImpl(
      id: (json['id'] as num).toInt(),
      conceptId: json['conceptId'] as String,
      confidence: (json['confidence'] as num).toInt(),
      quality: (json['quality'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ConfidenceLogImplToJson(_$ConfidenceLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conceptId': instance.conceptId,
      'confidence': instance.confidence,
      'quality': instance.quality,
      'timestamp': instance.timestamp.toIso8601String(),
    };
