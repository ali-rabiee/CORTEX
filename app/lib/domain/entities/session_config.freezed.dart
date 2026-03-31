// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionConfig _$SessionConfigFromJson(Map<String, dynamic> json) {
  return _SessionConfig.fromJson(json);
}

/// @nodoc
mixin _$SessionConfig {
  int get durationMinutes => throw _privateConstructorUsedError;
  int get warmupCards => throw _privateConstructorUsedError;
  int get coreReviewCards => throw _privateConstructorUsedError;
  int get challengeQuestions => throw _privateConstructorUsedError;

  /// Serializes this SessionConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionConfigCopyWith<SessionConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionConfigCopyWith<$Res> {
  factory $SessionConfigCopyWith(
    SessionConfig value,
    $Res Function(SessionConfig) then,
  ) = _$SessionConfigCopyWithImpl<$Res, SessionConfig>;
  @useResult
  $Res call({
    int durationMinutes,
    int warmupCards,
    int coreReviewCards,
    int challengeQuestions,
  });
}

/// @nodoc
class _$SessionConfigCopyWithImpl<$Res, $Val extends SessionConfig>
    implements $SessionConfigCopyWith<$Res> {
  _$SessionConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationMinutes = null,
    Object? warmupCards = null,
    Object? coreReviewCards = null,
    Object? challengeQuestions = null,
  }) {
    return _then(
      _value.copyWith(
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            warmupCards: null == warmupCards
                ? _value.warmupCards
                : warmupCards // ignore: cast_nullable_to_non_nullable
                      as int,
            coreReviewCards: null == coreReviewCards
                ? _value.coreReviewCards
                : coreReviewCards // ignore: cast_nullable_to_non_nullable
                      as int,
            challengeQuestions: null == challengeQuestions
                ? _value.challengeQuestions
                : challengeQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionConfigImplCopyWith<$Res>
    implements $SessionConfigCopyWith<$Res> {
  factory _$$SessionConfigImplCopyWith(
    _$SessionConfigImpl value,
    $Res Function(_$SessionConfigImpl) then,
  ) = __$$SessionConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int durationMinutes,
    int warmupCards,
    int coreReviewCards,
    int challengeQuestions,
  });
}

/// @nodoc
class __$$SessionConfigImplCopyWithImpl<$Res>
    extends _$SessionConfigCopyWithImpl<$Res, _$SessionConfigImpl>
    implements _$$SessionConfigImplCopyWith<$Res> {
  __$$SessionConfigImplCopyWithImpl(
    _$SessionConfigImpl _value,
    $Res Function(_$SessionConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationMinutes = null,
    Object? warmupCards = null,
    Object? coreReviewCards = null,
    Object? challengeQuestions = null,
  }) {
    return _then(
      _$SessionConfigImpl(
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        warmupCards: null == warmupCards
            ? _value.warmupCards
            : warmupCards // ignore: cast_nullable_to_non_nullable
                  as int,
        coreReviewCards: null == coreReviewCards
            ? _value.coreReviewCards
            : coreReviewCards // ignore: cast_nullable_to_non_nullable
                  as int,
        challengeQuestions: null == challengeQuestions
            ? _value.challengeQuestions
            : challengeQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionConfigImpl implements _SessionConfig {
  const _$SessionConfigImpl({
    this.durationMinutes = 30,
    this.warmupCards = 4,
    this.coreReviewCards = 10,
    this.challengeQuestions = 5,
  });

  factory _$SessionConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionConfigImplFromJson(json);

  @override
  @JsonKey()
  final int durationMinutes;
  @override
  @JsonKey()
  final int warmupCards;
  @override
  @JsonKey()
  final int coreReviewCards;
  @override
  @JsonKey()
  final int challengeQuestions;

  @override
  String toString() {
    return 'SessionConfig(durationMinutes: $durationMinutes, warmupCards: $warmupCards, coreReviewCards: $coreReviewCards, challengeQuestions: $challengeQuestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionConfigImpl &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.warmupCards, warmupCards) ||
                other.warmupCards == warmupCards) &&
            (identical(other.coreReviewCards, coreReviewCards) ||
                other.coreReviewCards == coreReviewCards) &&
            (identical(other.challengeQuestions, challengeQuestions) ||
                other.challengeQuestions == challengeQuestions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    durationMinutes,
    warmupCards,
    coreReviewCards,
    challengeQuestions,
  );

  /// Create a copy of SessionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionConfigImplCopyWith<_$SessionConfigImpl> get copyWith =>
      __$$SessionConfigImplCopyWithImpl<_$SessionConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionConfigImplToJson(this);
  }
}

abstract class _SessionConfig implements SessionConfig {
  const factory _SessionConfig({
    final int durationMinutes,
    final int warmupCards,
    final int coreReviewCards,
    final int challengeQuestions,
  }) = _$SessionConfigImpl;

  factory _SessionConfig.fromJson(Map<String, dynamic> json) =
      _$SessionConfigImpl.fromJson;

  @override
  int get durationMinutes;
  @override
  int get warmupCards;
  @override
  int get coreReviewCards;
  @override
  int get challengeQuestions;

  /// Create a copy of SessionConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionConfigImplCopyWith<_$SessionConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionResult _$SessionResultFromJson(Map<String, dynamic> json) {
  return _SessionResult.fromJson(json);
}

/// @nodoc
mixin _$SessionResult {
  int get cardsReviewed => throw _privateConstructorUsedError;
  int get quizCorrect => throw _privateConstructorUsedError;
  int get quizTotal => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  double get averageQuality => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  /// Serializes this SessionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionResultCopyWith<SessionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionResultCopyWith<$Res> {
  factory $SessionResultCopyWith(
    SessionResult value,
    $Res Function(SessionResult) then,
  ) = _$SessionResultCopyWithImpl<$Res, SessionResult>;
  @useResult
  $Res call({
    int cardsReviewed,
    int quizCorrect,
    int quizTotal,
    int durationMinutes,
    double averageQuality,
    DateTime date,
  });
}

/// @nodoc
class _$SessionResultCopyWithImpl<$Res, $Val extends SessionResult>
    implements $SessionResultCopyWith<$Res> {
  _$SessionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardsReviewed = null,
    Object? quizCorrect = null,
    Object? quizTotal = null,
    Object? durationMinutes = null,
    Object? averageQuality = null,
    Object? date = null,
  }) {
    return _then(
      _value.copyWith(
            cardsReviewed: null == cardsReviewed
                ? _value.cardsReviewed
                : cardsReviewed // ignore: cast_nullable_to_non_nullable
                      as int,
            quizCorrect: null == quizCorrect
                ? _value.quizCorrect
                : quizCorrect // ignore: cast_nullable_to_non_nullable
                      as int,
            quizTotal: null == quizTotal
                ? _value.quizTotal
                : quizTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            averageQuality: null == averageQuality
                ? _value.averageQuality
                : averageQuality // ignore: cast_nullable_to_non_nullable
                      as double,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionResultImplCopyWith<$Res>
    implements $SessionResultCopyWith<$Res> {
  factory _$$SessionResultImplCopyWith(
    _$SessionResultImpl value,
    $Res Function(_$SessionResultImpl) then,
  ) = __$$SessionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int cardsReviewed,
    int quizCorrect,
    int quizTotal,
    int durationMinutes,
    double averageQuality,
    DateTime date,
  });
}

/// @nodoc
class __$$SessionResultImplCopyWithImpl<$Res>
    extends _$SessionResultCopyWithImpl<$Res, _$SessionResultImpl>
    implements _$$SessionResultImplCopyWith<$Res> {
  __$$SessionResultImplCopyWithImpl(
    _$SessionResultImpl _value,
    $Res Function(_$SessionResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardsReviewed = null,
    Object? quizCorrect = null,
    Object? quizTotal = null,
    Object? durationMinutes = null,
    Object? averageQuality = null,
    Object? date = null,
  }) {
    return _then(
      _$SessionResultImpl(
        cardsReviewed: null == cardsReviewed
            ? _value.cardsReviewed
            : cardsReviewed // ignore: cast_nullable_to_non_nullable
                  as int,
        quizCorrect: null == quizCorrect
            ? _value.quizCorrect
            : quizCorrect // ignore: cast_nullable_to_non_nullable
                  as int,
        quizTotal: null == quizTotal
            ? _value.quizTotal
            : quizTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        averageQuality: null == averageQuality
            ? _value.averageQuality
            : averageQuality // ignore: cast_nullable_to_non_nullable
                  as double,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionResultImpl implements _SessionResult {
  const _$SessionResultImpl({
    required this.cardsReviewed,
    required this.quizCorrect,
    required this.quizTotal,
    required this.durationMinutes,
    required this.averageQuality,
    required this.date,
  });

  factory _$SessionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionResultImplFromJson(json);

  @override
  final int cardsReviewed;
  @override
  final int quizCorrect;
  @override
  final int quizTotal;
  @override
  final int durationMinutes;
  @override
  final double averageQuality;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'SessionResult(cardsReviewed: $cardsReviewed, quizCorrect: $quizCorrect, quizTotal: $quizTotal, durationMinutes: $durationMinutes, averageQuality: $averageQuality, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionResultImpl &&
            (identical(other.cardsReviewed, cardsReviewed) ||
                other.cardsReviewed == cardsReviewed) &&
            (identical(other.quizCorrect, quizCorrect) ||
                other.quizCorrect == quizCorrect) &&
            (identical(other.quizTotal, quizTotal) ||
                other.quizTotal == quizTotal) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.averageQuality, averageQuality) ||
                other.averageQuality == averageQuality) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cardsReviewed,
    quizCorrect,
    quizTotal,
    durationMinutes,
    averageQuality,
    date,
  );

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionResultImplCopyWith<_$SessionResultImpl> get copyWith =>
      __$$SessionResultImplCopyWithImpl<_$SessionResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionResultImplToJson(this);
  }
}

abstract class _SessionResult implements SessionResult {
  const factory _SessionResult({
    required final int cardsReviewed,
    required final int quizCorrect,
    required final int quizTotal,
    required final int durationMinutes,
    required final double averageQuality,
    required final DateTime date,
  }) = _$SessionResultImpl;

  factory _SessionResult.fromJson(Map<String, dynamic> json) =
      _$SessionResultImpl.fromJson;

  @override
  int get cardsReviewed;
  @override
  int get quizCorrect;
  @override
  int get quizTotal;
  @override
  int get durationMinutes;
  @override
  double get averageQuality;
  @override
  DateTime get date;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionResultImplCopyWith<_$SessionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
