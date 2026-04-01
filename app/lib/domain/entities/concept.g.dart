// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConceptImpl _$$ConceptImplFromJson(Map<String, dynamic> json) =>
    _$ConceptImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      definition: json['definition'] as String,
      intuition: json['intuition'] as String,
      practicalExample: json['practical_example'] as String,
      failureMode: json['failure_mode'] as String,
      interviewAnswer: json['interview_answer'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      difficulty: (json['difficulty'] as num).toInt(),
      importance: (json['importance'] as num).toInt(),
      relatedConceptIds: (json['related_concept_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ConceptImplToJson(_$ConceptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'definition': instance.definition,
      'intuition': instance.intuition,
      'practical_example': instance.practicalExample,
      'failure_mode': instance.failureMode,
      'interview_answer': instance.interviewAnswer,
      'tags': instance.tags,
      'difficulty': instance.difficulty,
      'importance': instance.importance,
      'related_concept_ids': instance.relatedConceptIds,
    };
