import 'package:drift/drift.dart';

import '../../domain/entities/review_card.dart' as entity;
import '../../domain/entities/user_progress.dart' as entity;
import '../../domain/repositories/review_repository.dart';
import '../database/app_database.dart';
import '../database/daos/review_dao.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewDao _dao;

  ReviewRepositoryImpl(this._dao);

  @override
  Future<List<entity.ReviewCard>> getDueCards(DateTime asOf) async {
    final rows = await _dao.getDueCards(asOf);
    return rows.map(_cardToDomain).toList();
  }

  @override
  Future<List<entity.ReviewCard>> getEasyCards({int limit = 10}) async {
    final rows = await _dao.getEasyCards(limit: limit);
    return rows.map(_cardToDomain).toList();
  }

  @override
  Future<List<entity.ReviewCard>> getCardsByDomain(String domain) async {
    // This requires joining with concepts table; for now use concept IDs
    // Will be refined when we add domain filtering at the DAO level
    final allCards = await _dao.getAllCards();
    return allCards.map(_cardToDomain).toList();
  }

  @override
  Future<entity.ReviewCard?> getCardByConceptId(String conceptId) async {
    final row = await _dao.getCardByConceptId(conceptId);
    return row != null ? _cardToDomain(row) : null;
  }

  @override
  Future<void> updateCard(entity.ReviewCard card) async {
    await _dao.updateCard(
      ReviewCardsCompanion(
        conceptId: Value(card.conceptId),
        easeFactor: Value(card.easeFactor),
        interval: Value(card.interval),
        nextReviewDate: Value(card.nextReviewDate),
        repetitions: Value(card.repetitions),
        lastQuality: Value(card.lastQuality),
      ),
      card.id,
    );
  }

  @override
  Future<void> insertCard(entity.ReviewCard card) async {
    await _dao.insertCard(
      ReviewCardsCompanion.insert(
        conceptId: card.conceptId,
        nextReviewDate: card.nextReviewDate,
        easeFactor: Value(card.easeFactor),
        interval: Value(card.interval),
        repetitions: Value(card.repetitions),
        lastQuality: Value(card.lastQuality),
      ),
    );
  }

  @override
  Future<void> insertCards(List<entity.ReviewCard> cards) async {
    final companions = cards
        .map((c) => ReviewCardsCompanion.insert(
              conceptId: c.conceptId,
              nextReviewDate: c.nextReviewDate,
            ))
        .toList();
    await _dao.insertAllCards(companions);
  }

  @override
  Future<List<entity.ReviewCard>> getAllCards() async {
    final rows = await _dao.getAllCards();
    return rows.map(_cardToDomain).toList();
  }

  @override
  Future<void> logConfidence(entity.ConfidenceLog log) async {
    await _dao.insertConfidenceLog(
      ConfidenceLogsCompanion.insert(
        conceptId: log.conceptId,
        confidence: log.confidence,
        quality: log.quality,
        timestamp: log.timestamp,
      ),
    );
  }

  @override
  Future<List<entity.ConfidenceLog>> getConfidenceLogs(
      {String? domain, int? limit}) async {
    final rows = await _dao.getConfidenceLogs(limit: limit);
    return rows.map(_confidenceToDomain).toList();
  }

  @override
  Future<List<entity.ReviewCard>> getAtRiskCards({int daysAhead = 7}) async {
    final rows = await _dao.getAtRiskCards(daysAhead: daysAhead);
    return rows.map(_cardToDomain).toList();
  }

  entity.ReviewCard _cardToDomain(ReviewCard row) {
    return entity.ReviewCard(
      id: row.id,
      conceptId: row.conceptId,
      easeFactor: row.easeFactor,
      interval: row.interval,
      nextReviewDate: row.nextReviewDate,
      repetitions: row.repetitions,
      lastQuality: row.lastQuality,
    );
  }

  entity.ConfidenceLog _confidenceToDomain(ConfidenceLog row) {
    return entity.ConfidenceLog(
      id: row.id,
      conceptId: row.conceptId,
      confidence: row.confidence,
      quality: row.quality,
      timestamp: row.timestamp,
    );
  }
}
