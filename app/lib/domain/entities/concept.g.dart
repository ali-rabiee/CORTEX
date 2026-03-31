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
      practicalExample: json['practicalExample'] as String,
      failureMode: json['failureMode'] as String,
      interviewAnswer: json['interviewAnswer'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      difficulty: (json['difficulty'] as num).toInt(),
      importance: (json['importance'] as num).toInt(),
      relatedConceptIds: (json['relatedConceptIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ConceptImplToJson(_$ConceptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'definition': instance.definition,
      'intuition': instance.intuition,
      'practicalExample': instance.practicalExample,
      'failureMode': instance.failureMode,
      'interviewAnswer': instance.interviewAnswer,
      'tags': instance.tags,
      'difficulty': instance.difficulty,
      'importance': instance.importance,
      'relatedConceptIds': instance.relatedConceptIds,
    };
