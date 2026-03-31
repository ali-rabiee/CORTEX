import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_card.freezed.dart';
part 'review_card.g.dart';

@freezed
class ReviewCard with _$ReviewCard {
  const factory ReviewCard({
    required int id,
    required String conceptId,
    @Default(2.5) double easeFactor,
    @Default(1) int interval,
    required DateTime nextReviewDate,
    @Default(0) int repetitions,
    @Default(0) int lastQuality,
  }) = _ReviewCard;

  factory ReviewCard.fromJson(Map<String, dynamic> json) =>
      _$ReviewCardFromJson(json);
}
