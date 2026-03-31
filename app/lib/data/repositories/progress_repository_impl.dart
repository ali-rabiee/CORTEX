import 'package:drift/drift.dart';

import '../../domain/entities/session_config.dart' as entity;
import '../../domain/entities/user_progress.dart' as entity;
import '../../domain/repositories/progress_repository.dart';
import '../database/app_database.dart';
import '../database/daos/progress_dao.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressDao _dao;

  ProgressRepositoryImpl(this._dao);

  @override
  Future<entity.UserStats> getUserStats() async {
    final row = await _dao.getUserStats();
    return entity.UserStats(
      currentStreak: row.currentStreak,
      longestStreak: row.longestStreak,
      lastSessionDate: row.lastSessionDate,
      totalSessions: row.totalSessions,
      totalReviews: row.totalReviews,
    );
  }

  @override
  Future<void> updateUserStats(entity.UserStats stats) async {
    await _dao.updateUserStats(
      UserStatsTableCompanion(
        currentStreak: Value(stats.currentStreak),
        longestStreak: Value(stats.longestStreak),
        lastSessionDate: Value(stats.lastSessionDate),
        totalSessions: Value(stats.totalSessions),
        totalReviews: Value(stats.totalReviews),
      ),
    );
  }

  @override
  Future<List<entity.DomainMastery>> getAllDomainMastery() async {
    final rows = await _dao.getAllDomainProgress();
    return rows.map(_masteryToDomain).toList();
  }

  @override
  Future<entity.DomainMastery> getDomainMastery(String domain) async {
    final row = await _dao.getDomainProgress(domain);
    return _masteryToDomain(row);
  }

  @override
  Future<void> updateDomainMastery(entity.DomainMastery mastery) async {
    await _dao.updateDomainProgress(
      DomainProgressTableCompanion(
        masteryScore: Value(mastery.masteryScore),
        totalReviews: Value(mastery.totalReviews),
        correctQuizAnswers: Value(mastery.correctQuizAnswers),
        totalQuizAnswers: Value(mastery.totalQuizAnswers),
      ),
      mastery.domain,
    );
  }

  @override
  Future<void> logSession(entity.SessionResult result) async {
    await _dao.insertSessionLog(
      SessionLogsCompanion.insert(
        date: result.date,
        cardsReviewed: result.cardsReviewed,
        quizCorrect: result.quizCorrect,
        quizTotal: result.quizTotal,
        durationMinutes: result.durationMinutes,
        averageQuality: result.averageQuality,
      ),
    );
  }

  @override
  Future<List<entity.SessionResult>> getSessionHistory(
      {int limit = 30}) async {
    final rows = await _dao.getSessionHistory(limit: limit);
    return rows
        .map((r) => entity.SessionResult(
              cardsReviewed: r.cardsReviewed,
              quizCorrect: r.quizCorrect,
              quizTotal: r.quizTotal,
              durationMinutes: r.durationMinutes,
              averageQuality: r.averageQuality,
              date: r.date,
            ))
        .toList();
  }

  @override
  Future<void> updateStreak() async {
    final stats = await _dao.getUserStats();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int newStreak;
    if (stats.lastSessionDate == null) {
      newStreak = 1;
    } else {
      final lastDate = stats.lastSessionDate!;
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final diff = today.difference(lastDay).inDays;

      if (diff == 0) {
        // Already reviewed today
        newStreak = stats.currentStreak;
      } else if (diff == 1) {
        // Consecutive day
        newStreak = stats.currentStreak + 1;
      } else {
        // Streak broken
        newStreak = 1;
      }
    }

    final newLongest =
        newStreak > stats.longestStreak ? newStreak : stats.longestStreak;

    await _dao.updateUserStats(
      UserStatsTableCompanion(
        currentStreak: Value(newStreak),
        longestStreak: Value(newLongest),
        lastSessionDate: Value(today),
        totalSessions: Value(stats.totalSessions + 1),
      ),
    );
  }

  entity.DomainMastery _masteryToDomain(DomainProgressTableData row) {
    return entity.DomainMastery(
      domain: row.domain,
      masteryScore: row.masteryScore,
      totalReviews: row.totalReviews,
      correctQuizAnswers: row.correctQuizAnswers,
      totalQuizAnswers: row.totalQuizAnswers,
    );
  }
}
