// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewCardImpl _$$ReviewCardImplFromJson(Map<String, dynamic> json) =>
    _$ReviewCardImpl(
      id: (json['id'] as num).toInt(),
      conceptId: json['concept_id'] as String,
      easeFactor: (json['ease_factor'] as num?)?.toDouble() ?? 2.5,
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      nextReviewDate: DateTime.parse(json['next_review_date'] as String),
      repetitions: (json['repetitions'] as num?)?.toInt() ?? 0,
      lastQuality: (json['last_quality'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReviewCardImplToJson(_$ReviewCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'concept_id': instance.conceptId,
      'ease_factor': instance.easeFactor,
      'interval': instance.interval,
      'next_review_date': instance.nextReviewDate.toIso8601String(),
      'repetitions': instance.repetitions,
      'last_quality': instance.lastQuality,
    };
