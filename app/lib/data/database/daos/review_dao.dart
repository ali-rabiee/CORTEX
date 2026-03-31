import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/review_cards_table.dart';
import '../tables/confidence_logs_table.dart';

part 'review_dao.g.dart';

@DriftAccessor(tables: [ReviewCards, ConfidenceLogs])
class ReviewDao extends DatabaseAccessor<AppDatabase>
    with _$ReviewDaoMixin {
  ReviewDao(super.db);

  Future<List<ReviewCard>> getDueCards(DateTime asOf) =>
      (select(reviewCards)
            ..where((c) => c.nextReviewDate.isSmallerOrEqualValue(asOf))
            ..orderBy([
              (c) => OrderingTerm.asc(c.nextReviewDate),
            ]))
          .get();

  Future<List<ReviewCard>> getEasyCards({int limit = 10}) =>
      (select(reviewCards)
            ..orderBy([
              (c) => OrderingTerm.desc(c.easeFactor),
            ])
            ..limit(limit))
          .get();

  Future<ReviewCard?> getCardByConceptId(String conceptId) =>
      (select(reviewCards)..where((c) => c.conceptId.equals(conceptId)))
          .getSingleOrNull();

  Future<List<ReviewCard>> getAllCards() => select(reviewCards).get();

  Future<List<ReviewCard>> getCardsByConceptIds(List<String> conceptIds) =>
      (select(reviewCards)
            ..where((c) => c.conceptId.isIn(conceptIds)))
          .get();

  Future<void> updateCard(ReviewCardsCompanion entry, int id) =>
      (update(reviewCards)..where((c) => c.id.equals(id))).write(entry);

  Future<int> insertCard(ReviewCardsCompanion entry) =>
      into(reviewCards).insert(entry);

  Future<void> insertAllCards(List<ReviewCardsCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(reviewCards, entries);
    });
  }

  Future<List<ReviewCard>> getAtRiskCards({int daysAhead = 7}) {
    final cutoff = DateTime.now().add(Duration(days: daysAhead));
    return (select(reviewCards)
          ..where((c) =>
              c.nextReviewDate.isSmallerOrEqualValue(cutoff) &
              c.nextReviewDate.isBiggerThanValue(DateTime.now()))
          ..orderBy([(c) => OrderingTerm.asc(c.nextReviewDate)]))
        .get();
  }

  // Confidence logs
  Future<void> insertConfidenceLog(ConfidenceLogsCompanion entry) =>
      into(confidenceLogs).insert(entry);

  Future<List<ConfidenceLog>> getConfidenceLogs({int? limit}) {
    final query = select(confidenceLogs)
      ..orderBy([(c) => OrderingTerm.desc(c.timestamp)]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<List<ConfidenceLog>> getConfidenceLogsByConceptIds(
      List<String> conceptIds) =>
      (select(confidenceLogs)
            ..where((c) => c.conceptId.isIn(conceptIds)))
          .get();
}
