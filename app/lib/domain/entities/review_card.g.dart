// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewCardImpl _$$ReviewCardImplFromJson(Map<String, dynamic> json) =>
    _$ReviewCardImpl(
      id: (json['id'] as num).toInt(),
      conceptId: json['conceptId'] as String,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
      repetitions: (json['repetitions'] as num?)?.toInt() ?? 0,
      lastQuality: (json['lastQuality'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReviewCardImplToJson(_$ReviewCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conceptId': instance.conceptId,
      'easeFactor': instance.easeFactor,
      'interval': instance.interval,
      'nextReviewDate': instance.nextReviewDate.toIso8601String(),
      'repetitions': instance.repetitions,
      'lastQuality': instance.lastQuality,
    };
