import 'package:freezed_annotation/freezed_annotation.dart';

part 'concept.freezed.dart';
part 'concept.g.dart';

@freezed
class Concept with _$Concept {
  const factory Concept({
    required String id,
    required String title,
    required String definition,
    required String intuition,
    required String practicalExample,
    required String failureMode,
    required String interviewAnswer,
    required List<String> tags,
    required int difficulty,
    required int importance,
    required List<String> relatedConceptIds,
  }) = _Concept;

  factory Concept.fromJson(Map<String, dynamic> json) =>
      _$ConceptFromJson(json);
}
