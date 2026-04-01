// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswer: (json['correct_answer'] as num).toInt(),
      explanation: json['explanation'] as String,
      conceptIds: (json['concept_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      difficulty: (json['difficulty'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'correct_answer': instance.correctAnswer,
      'explanation': instance.explanation,
      'concept_ids': instance.conceptIds,
      'difficulty': instance.difficulty,
      'tags': instance.tags,
    };
