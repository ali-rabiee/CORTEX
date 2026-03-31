// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionConfigImpl _$$SessionConfigImplFromJson(Map<String, dynamic> json) =>
    _$SessionConfigImpl(
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 30,
      warmupCards: (json['warmupCards'] as num?)?.toInt() ?? 4,
      coreReviewCards: (json['coreReviewCards'] as num?)?.toInt() ?? 10,
      challengeQuestions: (json['challengeQuestions'] as num?)?.toInt() ?? 5,
    );

Map<String, dynamic> _$$SessionConfigImplToJson(_$SessionConfigImpl instance) =>
    <String, dynamic>{
      'durationMinutes': instance.durationMinutes,
      'warmupCards': instance.warmupCards,
      'coreReviewCards': instance.coreReviewCards,
      'challengeQuestions': instance.challengeQuestions,
    };

_$SessionResultImpl _$$SessionResultImplFromJson(Map<String, dynamic> json) =>
    _$SessionResultImpl(
      cardsReviewed: (json['cardsReviewed'] as num).toInt(),
      quizCorrect: (json['quizCorrect'] as num).toInt(),
      quizTotal: (json['quizTotal'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      averageQuality: (json['averageQuality'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$SessionResultImplToJson(_$SessionResultImpl instance) =>
    <String, dynamic>{
      'cardsReviewed': instance.cardsReviewed,
      'quizCorrect': instance.quizCorrect,
      'quizTotal': instance.quizTotal,
      'durationMinutes': instance.durationMinutes,
      'averageQuality': instance.averageQuality,
      'date': instance.date.toIso8601String(),
    };
