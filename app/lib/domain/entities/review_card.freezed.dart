// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReviewCard _$ReviewCardFromJson(Map<String, dynamic> json) {
  return _ReviewCard.fromJson(json);
}

/// @nodoc
mixin _$ReviewCard {
  int get id => throw _privateConstructorUsedError;
  String get conceptId => throw _privateConstructorUsedError;
  double get easeFactor => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  DateTime get nextReviewDate => throw _privateConstructorUsedError;
  int get repetitions => throw _privateConstructorUsedError;
  int get lastQuality => throw _privateConstructorUsedError;

  /// Serializes this ReviewCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewCardCopyWith<ReviewCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCardCopyWith<$Res> {
  factory $ReviewCardCopyWith(
    ReviewCard value,
    $Res Function(ReviewCard) then,
  ) = _$ReviewCardCopyWithImpl<$Res, ReviewCard>;
  @useResult
  $Res call({
    int id,
    String conceptId,
    double easeFactor,
    int interval,
    DateTime nextReviewDate,
    int repetitions,
    int lastQuality,
  });
}

/// @nodoc
class _$ReviewCardCopyWithImpl<$Res, $Val extends ReviewCard>
    implements $ReviewCardCopyWith<$Res> {
  _$ReviewCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptId = null,
    Object? easeFactor = null,
    Object? interval = null,
    Object? nextReviewDate = null,
    Object? repetitions = null,
    Object? lastQuality = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            conceptId: null == conceptId
                ? _value.conceptId
                : conceptId // ignore: cast_nullable_to_non_nullable
                      as String,
            easeFactor: null == easeFactor
                ? _value.easeFactor
                : easeFactor // ignore: cast_nullable_to_non_nullable
                      as double,
            interval: null == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                      as int,
            nextReviewDate: null == nextReviewDate
                ? _value.nextReviewDate
                : nextReviewDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            repetitions: null == repetitions
                ? _value.repetitions
                : repetitions // ignore: cast_nullable_to_non_nullable
                      as int,
            lastQuality: null == lastQuality
                ? _value.lastQuality
                : lastQuality // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewCardImplCopyWith<$Res>
    implements $ReviewCardCopyWith<$Res> {
  factory _$$ReviewCardImplCopyWith(
    _$ReviewCardImpl value,
    $Res Function(_$ReviewCardImpl) then,
  ) = __$$ReviewCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String conceptId,
    double easeFactor,
    int interval,
    DateTime nextReviewDate,
    int repetitions,
    int lastQuality,
  });
}

/// @nodoc
class __$$ReviewCardImplCopyWithImpl<$Res>
    extends _$ReviewCardCopyWithImpl<$Res, _$ReviewCardImpl>
    implements _$$ReviewCardImplCopyWith<$Res> {
  __$$ReviewCardImplCopyWithImpl(
    _$ReviewCardImpl _value,
    $Res Function(_$ReviewCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptId = null,
    Object? easeFactor = null,
    Object? interval = null,
    Object? nextReviewDate = null,
    Object? repetitions = null,
    Object? lastQuality = null,
  }) {
    return _then(
      _$ReviewCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        conceptId: null == conceptId
            ? _value.conceptId
            : conceptId // ignore: cast_nullable_to_non_nullable
                  as String,
        easeFactor: null == easeFactor
            ? _value.easeFactor
            : easeFactor // ignore: cast_nullable_to_non_nullable
                  as double,
        interval: null == interval
            ? _value.interval
            : interval // ignore: cast_nullable_to_non_nullable
                  as int,
        nextReviewDate: null == nextReviewDate
            ? _value.nextReviewDate
            : nextReviewDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        repetitions: null == repetitions
            ? _value.repetitions
            : repetitions // ignore: cast_nullable_to_non_nullable
                  as int,
        lastQuality: null == lastQuality
            ? _value.lastQuality
            : lastQuality // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewCardImpl implements _ReviewCard {
  const _$ReviewCardImpl({
    required this.id,
    required this.conceptId,
    this.easeFactor = 2.5,
    this.interval = 1,
    required this.nextReviewDate,
    this.repetitions = 0,
    this.lastQuality = 0,
  });

  factory _$ReviewCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewCardImplFromJson(json);

  @override
  final int id;
  @override
  final String conceptId;
  @override
  @JsonKey()
  final double easeFactor;
  @override
  @JsonKey()
  final int interval;
  @override
  final DateTime nextReviewDate;
  @override
  @JsonKey()
  final int repetitions;
  @override
  @JsonKey()
  final int lastQuality;

  @override
  String toString() {
    return 'ReviewCard(id: $id, conceptId: $conceptId, easeFactor: $easeFactor, interval: $interval, nextReviewDate: $nextReviewDate, repetitions: $repetitions, lastQuality: $lastQuality)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conceptId, conceptId) ||
                other.conceptId == conceptId) &&
            (identical(other.easeFactor, easeFactor) ||
                other.easeFactor == easeFactor) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.nextReviewDate, nextReviewDate) ||
                other.nextReviewDate == nextReviewDate) &&
            (identical(other.repetitions, repetitions) ||
                other.repetitions == repetitions) &&
            (identical(other.lastQuality, lastQuality) ||
                other.lastQuality == lastQuality));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conceptId,
    easeFactor,
    interval,
    nextReviewDate,
    repetitions,
    lastQuality,
  );

  /// Create a copy of ReviewCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewCardImplCopyWith<_$ReviewCardImpl> get copyWith =>
      __$$ReviewCardImplCopyWithImpl<_$ReviewCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewCardImplToJson(this);
  }
}

abstract class _ReviewCard implements ReviewCard {
  const factory _ReviewCard({
    required final int id,
    required final String conceptId,
    final double easeFactor,
    final int interval,
    required final DateTime nextReviewDate,
    final int repetitions,
    final int lastQuality,
  }) = _$ReviewCardImpl;

  factory _ReviewCard.fromJson(Map<String, dynamic> json) =
      _$ReviewCardImpl.fromJson;

  @override
  int get id;
  @override
  String get conceptId;
  @override
  double get easeFactor;
  @override
  int get interval;
  @override
  DateTime get nextReviewDate;
  @override
  int get repetitions;
  @override
  int get lastQuality;

  /// Create a copy of ReviewCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewCardImplCopyWith<_$ReviewCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
