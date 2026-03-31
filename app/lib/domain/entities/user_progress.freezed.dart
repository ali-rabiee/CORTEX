// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DomainMastery _$DomainMasteryFromJson(Map<String, dynamic> json) {
  return _DomainMastery.fromJson(json);
}

/// @nodoc
mixin _$DomainMastery {
  String get domain => throw _privateConstructorUsedError;
  double get masteryScore => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  int get correctQuizAnswers => throw _privateConstructorUsedError;
  int get totalQuizAnswers => throw _privateConstructorUsedError;

  /// Serializes this DomainMastery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DomainMastery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DomainMasteryCopyWith<DomainMastery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DomainMasteryCopyWith<$Res> {
  factory $DomainMasteryCopyWith(
    DomainMastery value,
    $Res Function(DomainMastery) then,
  ) = _$DomainMasteryCopyWithImpl<$Res, DomainMastery>;
  @useResult
  $Res call({
    String domain,
    double masteryScore,
    int totalReviews,
    int correctQuizAnswers,
    int totalQuizAnswers,
  });
}

/// @nodoc
class _$DomainMasteryCopyWithImpl<$Res, $Val extends DomainMastery>
    implements $DomainMasteryCopyWith<$Res> {
  _$DomainMasteryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DomainMastery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? domain = null,
    Object? masteryScore = null,
    Object? totalReviews = null,
    Object? correctQuizAnswers = null,
    Object? totalQuizAnswers = null,
  }) {
    return _then(
      _value.copyWith(
            domain: null == domain
                ? _value.domain
                : domain // ignore: cast_nullable_to_non_nullable
                      as String,
            masteryScore: null == masteryScore
                ? _value.masteryScore
                : masteryScore // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            correctQuizAnswers: null == correctQuizAnswers
                ? _value.correctQuizAnswers
                : correctQuizAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQuizAnswers: null == totalQuizAnswers
                ? _value.totalQuizAnswers
                : totalQuizAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DomainMasteryImplCopyWith<$Res>
    implements $DomainMasteryCopyWith<$Res> {
  factory _$$DomainMasteryImplCopyWith(
    _$DomainMasteryImpl value,
    $Res Function(_$DomainMasteryImpl) then,
  ) = __$$DomainMasteryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String domain,
    double masteryScore,
    int totalReviews,
    int correctQuizAnswers,
    int totalQuizAnswers,
  });
}

/// @nodoc
class __$$DomainMasteryImplCopyWithImpl<$Res>
    extends _$DomainMasteryCopyWithImpl<$Res, _$DomainMasteryImpl>
    implements _$$DomainMasteryImplCopyWith<$Res> {
  __$$DomainMasteryImplCopyWithImpl(
    _$DomainMasteryImpl _value,
    $Res Function(_$DomainMasteryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DomainMastery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? domain = null,
    Object? masteryScore = null,
    Object? totalReviews = null,
    Object? correctQuizAnswers = null,
    Object? totalQuizAnswers = null,
  }) {
    return _then(
      _$DomainMasteryImpl(
        domain: null == domain
            ? _value.domain
            : domain // ignore: cast_nullable_to_non_nullable
                  as String,
        masteryScore: null == masteryScore
            ? _value.masteryScore
            : masteryScore // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        correctQuizAnswers: null == correctQuizAnswers
            ? _value.correctQuizAnswers
            : correctQuizAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQuizAnswers: null == totalQuizAnswers
            ? _value.totalQuizAnswers
            : totalQuizAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DomainMasteryImpl implements _DomainMastery {
  const _$DomainMasteryImpl({
    required this.domain,
    this.masteryScore = 0.0,
    this.totalReviews = 0,
    this.correctQuizAnswers = 0,
    this.totalQuizAnswers = 0,
  });

  factory _$DomainMasteryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DomainMasteryImplFromJson(json);

  @override
  final String domain;
  @override
  @JsonKey()
  final double masteryScore;
  @override
  @JsonKey()
  final int totalReviews;
  @override
  @JsonKey()
  final int correctQuizAnswers;
  @override
  @JsonKey()
  final int totalQuizAnswers;

  @override
  String toString() {
    return 'DomainMastery(domain: $domain, masteryScore: $masteryScore, totalReviews: $totalReviews, correctQuizAnswers: $correctQuizAnswers, totalQuizAnswers: $totalQuizAnswers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DomainMasteryImpl &&
            (identical(other.domain, domain) || other.domain == domain) &&
            (identical(other.masteryScore, masteryScore) ||
                other.masteryScore == masteryScore) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.correctQuizAnswers, correctQuizAnswers) ||
                other.correctQuizAnswers == correctQuizAnswers) &&
            (identical(other.totalQuizAnswers, totalQuizAnswers) ||
                other.totalQuizAnswers == totalQuizAnswers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    domain,
    masteryScore,
    totalReviews,
    correctQuizAnswers,
    totalQuizAnswers,
  );

  /// Create a copy of DomainMastery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DomainMasteryImplCopyWith<_$DomainMasteryImpl> get copyWith =>
      __$$DomainMasteryImplCopyWithImpl<_$DomainMasteryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DomainMasteryImplToJson(this);
  }
}

abstract class _DomainMastery implements DomainMastery {
  const factory _DomainMastery({
    required final String domain,
    final double masteryScore,
    final int totalReviews,
    final int correctQuizAnswers,
    final int totalQuizAnswers,
  }) = _$DomainMasteryImpl;

  factory _DomainMastery.fromJson(Map<String, dynamic> json) =
      _$DomainMasteryImpl.fromJson;

  @override
  String get domain;
  @override
  double get masteryScore;
  @override
  int get totalReviews;
  @override
  int get correctQuizAnswers;
  @override
  int get totalQuizAnswers;

  /// Create a copy of DomainMastery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DomainMasteryImplCopyWith<_$DomainMasteryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime? get lastSessionDate => throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call({
    int currentStreak,
    int longestStreak,
    DateTime? lastSessionDate,
    int totalSessions,
    int totalReviews,
  });
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastSessionDate = freezed,
    Object? totalSessions = null,
    Object? totalReviews = null,
  }) {
    return _then(
      _value.copyWith(
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastSessionDate: freezed == lastSessionDate
                ? _value.lastSessionDate
                : lastSessionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            totalSessions: null == totalSessions
                ? _value.totalSessions
                : totalSessions // ignore: cast_nullable_to_non_nullable
                      as int,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
    _$UserStatsImpl value,
    $Res Function(_$UserStatsImpl) then,
  ) = __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStreak,
    int longestStreak,
    DateTime? lastSessionDate,
    int totalSessions,
    int totalReviews,
  });
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
    _$UserStatsImpl _value,
    $Res Function(_$UserStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastSessionDate = freezed,
    Object? totalSessions = null,
    Object? totalReviews = null,
  }) {
    return _then(
      _$UserStatsImpl(
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastSessionDate: freezed == lastSessionDate
            ? _value.lastSessionDate
            : lastSessionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        totalSessions: null == totalSessions
            ? _value.totalSessions
            : totalSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastSessionDate,
    this.totalSessions = 0,
    this.totalReviews = 0,
  });

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  final DateTime? lastSessionDate;
  @override
  @JsonKey()
  final int totalSessions;
  @override
  @JsonKey()
  final int totalReviews;

  @override
  String toString() {
    return 'UserStats(currentStreak: $currentStreak, longestStreak: $longestStreak, lastSessionDate: $lastSessionDate, totalSessions: $totalSessions, totalReviews: $totalReviews)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastSessionDate, lastSessionDate) ||
                other.lastSessionDate == lastSessionDate) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStreak,
    longestStreak,
    lastSessionDate,
    totalSessions,
    totalReviews,
  );

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(this);
  }
}

abstract class _UserStats implements UserStats {
  const factory _UserStats({
    final int currentStreak,
    final int longestStreak,
    final DateTime? lastSessionDate,
    final int totalSessions,
    final int totalReviews,
  }) = _$UserStatsImpl;

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime? get lastSessionDate;
  @override
  int get totalSessions;
  @override
  int get totalReviews;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConfidenceLog _$ConfidenceLogFromJson(Map<String, dynamic> json) {
  return _ConfidenceLog.fromJson(json);
}

/// @nodoc
mixin _$ConfidenceLog {
  int get id => throw _privateConstructorUsedError;
  String get conceptId => throw _privateConstructorUsedError;
  int get confidence => throw _privateConstructorUsedError;
  int get quality => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ConfidenceLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfidenceLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfidenceLogCopyWith<ConfidenceLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfidenceLogCopyWith<$Res> {
  factory $ConfidenceLogCopyWith(
    ConfidenceLog value,
    $Res Function(ConfidenceLog) then,
  ) = _$ConfidenceLogCopyWithImpl<$Res, ConfidenceLog>;
  @useResult
  $Res call({
    int id,
    String conceptId,
    int confidence,
    int quality,
    DateTime timestamp,
  });
}

/// @nodoc
class _$ConfidenceLogCopyWithImpl<$Res, $Val extends ConfidenceLog>
    implements $ConfidenceLogCopyWith<$Res> {
  _$ConfidenceLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfidenceLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptId = null,
    Object? confidence = null,
    Object? quality = null,
    Object? timestamp = null,
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
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as int,
            quality: null == quality
                ? _value.quality
                : quality // ignore: cast_nullable_to_non_nullable
                      as int,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConfidenceLogImplCopyWith<$Res>
    implements $ConfidenceLogCopyWith<$Res> {
  factory _$$ConfidenceLogImplCopyWith(
    _$ConfidenceLogImpl value,
    $Res Function(_$ConfidenceLogImpl) then,
  ) = __$$ConfidenceLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String conceptId,
    int confidence,
    int quality,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$ConfidenceLogImplCopyWithImpl<$Res>
    extends _$ConfidenceLogCopyWithImpl<$Res, _$ConfidenceLogImpl>
    implements _$$ConfidenceLogImplCopyWith<$Res> {
  __$$ConfidenceLogImplCopyWithImpl(
    _$ConfidenceLogImpl _value,
    $Res Function(_$ConfidenceLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConfidenceLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conceptId = null,
    Object? confidence = null,
    Object? quality = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$ConfidenceLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        conceptId: null == conceptId
            ? _value.conceptId
            : conceptId // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as int,
        quality: null == quality
            ? _value.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as int,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfidenceLogImpl implements _ConfidenceLog {
  const _$ConfidenceLogImpl({
    required this.id,
    required this.conceptId,
    required this.confidence,
    required this.quality,
    required this.timestamp,
  });

  factory _$ConfidenceLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfidenceLogImplFromJson(json);

  @override
  final int id;
  @override
  final String conceptId;
  @override
  final int confidence;
  @override
  final int quality;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'ConfidenceLog(id: $id, conceptId: $conceptId, confidence: $confidence, quality: $quality, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfidenceLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conceptId, conceptId) ||
                other.conceptId == conceptId) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, conceptId, confidence, quality, timestamp);

  /// Create a copy of ConfidenceLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfidenceLogImplCopyWith<_$ConfidenceLogImpl> get copyWith =>
      __$$ConfidenceLogImplCopyWithImpl<_$ConfidenceLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfidenceLogImplToJson(this);
  }
}

abstract class _ConfidenceLog implements ConfidenceLog {
  const factory _ConfidenceLog({
    required final int id,
    required final String conceptId,
    required final int confidence,
    required final int quality,
    required final DateTime timestamp,
  }) = _$ConfidenceLogImpl;

  factory _ConfidenceLog.fromJson(Map<String, dynamic> json) =
      _$ConfidenceLogImpl.fromJson;

  @override
  int get id;
  @override
  String get conceptId;
  @override
  int get confidence;
  @override
  int get quality;
  @override
  DateTime get timestamp;

  /// Create a copy of ConfidenceLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfidenceLogImplCopyWith<_$ConfidenceLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
