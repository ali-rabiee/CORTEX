// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  return _QuizQuestion.fromJson(json);
}

/// @nodoc
mixin _$QuizQuestion {
  String get id => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  int get correctAnswer => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  List<String> get conceptIds => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizQuestionCopyWith<QuizQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionCopyWith<$Res> {
  factory $QuizQuestionCopyWith(
    QuizQuestion value,
    $Res Function(QuizQuestion) then,
  ) = _$QuizQuestionCopyWithImpl<$Res, QuizQuestion>;
  @useResult
  $Res call({
    String id,
    String question,
    List<String> options,
    int correctAnswer,
    String explanation,
    List<String> conceptIds,
    int difficulty,
    List<String> tags,
  });
}

/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res, $Val extends QuizQuestion>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? explanation = null,
    Object? conceptIds = null,
    Object? difficulty = null,
    Object? tags = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            question: null == question
                ? _value.question
                : question // ignore: cast_nullable_to_non_nullable
                      as String,
            options: null == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            correctAnswer: null == correctAnswer
                ? _value.correctAnswer
                : correctAnswer // ignore: cast_nullable_to_non_nullable
                      as int,
            explanation: null == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String,
            conceptIds: null == conceptIds
                ? _value.conceptIds
                : conceptIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as int,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$QuizQuestionImplCopyWith(
    _$QuizQuestionImpl value,
    $Res Function(_$QuizQuestionImpl) then,
  ) = __$$QuizQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String question,
    List<String> options,
    int correctAnswer,
    String explanation,
    List<String> conceptIds,
    int difficulty,
    List<String> tags,
  });
}

/// @nodoc
class __$$QuizQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$QuizQuestionImpl>
    implements _$$QuizQuestionImplCopyWith<$Res> {
  __$$QuizQuestionImplCopyWithImpl(
    _$QuizQuestionImpl _value,
    $Res Function(_$QuizQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? explanation = null,
    Object? conceptIds = null,
    Object? difficulty = null,
    Object? tags = null,
  }) {
    return _then(
      _$QuizQuestionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        question: null == question
            ? _value.question
            : question // ignore: cast_nullable_to_non_nullable
                  as String,
        options: null == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        correctAnswer: null == correctAnswer
            ? _value.correctAnswer
            : correctAnswer // ignore: cast_nullable_to_non_nullable
                  as int,
        explanation: null == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String,
        conceptIds: null == conceptIds
            ? _value._conceptIds
            : conceptIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as int,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizQuestionImpl implements _QuizQuestion {
  const _$QuizQuestionImpl({
    required this.id,
    required this.question,
    required final List<String> options,
    required this.correctAnswer,
    required this.explanation,
    required final List<String> conceptIds,
    required this.difficulty,
    required final List<String> tags,
  }) : _options = options,
       _conceptIds = conceptIds,
       _tags = tags;

  factory _$QuizQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String question;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final int correctAnswer;
  @override
  final String explanation;
  final List<String> _conceptIds;
  @override
  List<String> get conceptIds {
    if (_conceptIds is EqualUnmodifiableListView) return _conceptIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conceptIds);
  }

  @override
  final int difficulty;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'QuizQuestion(id: $id, question: $question, options: $options, correctAnswer: $correctAnswer, explanation: $explanation, conceptIds: $conceptIds, difficulty: $difficulty, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            const DeepCollectionEquality().equals(
              other._conceptIds,
              _conceptIds,
            ) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    question,
    const DeepCollectionEquality().hash(_options),
    correctAnswer,
    explanation,
    const DeepCollectionEquality().hash(_conceptIds),
    difficulty,
    const DeepCollectionEquality().hash(_tags),
  );

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      __$$QuizQuestionImplCopyWithImpl<_$QuizQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizQuestionImplToJson(this);
  }
}

abstract class _QuizQuestion implements QuizQuestion {
  const factory _QuizQuestion({
    required final String id,
    required final String question,
    required final List<String> options,
    required final int correctAnswer,
    required final String explanation,
    required final List<String> conceptIds,
    required final int difficulty,
    required final List<String> tags,
  }) = _$QuizQuestionImpl;

  factory _QuizQuestion.fromJson(Map<String, dynamic> json) =
      _$QuizQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get question;
  @override
  List<String> get options;
  @override
  int get correctAnswer;
  @override
  String get explanation;
  @override
  List<String> get conceptIds;
  @override
  int get difficulty;
  @override
  List<String> get tags;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
