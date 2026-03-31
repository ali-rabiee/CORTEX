import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_question.freezed.dart';
part 'quiz_question.g.dart';

@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    required String question,
    required List<String> options,
    required int correctAnswer,
    required String explanation,
    required List<String> conceptIds,
    required int difficulty,
    required List<String> tags,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}
