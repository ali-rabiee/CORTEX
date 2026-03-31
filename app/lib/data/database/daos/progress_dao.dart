import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/domain_progress_table.dart';
import '../tables/session_logs_table.dart';
import '../tables/user_stats_table.dart';

part 'progress_dao.g.dart';

@DriftAccessor(tables: [DomainProgressTable, SessionLogs, UserStatsTable])
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  ProgressDao(super.db);

  // User stats
  Future<UserStatsTableData> getUserStats() =>
      (select(userStatsTable)..where((s) => s.id.equals(1))).getSingle();

  Future<void> updateUserStats(UserStatsTableCompanion entry) =>
      (update(userStatsTable)..where((s) => s.id.equals(1))).write(entry);

  // Domain progress
  Future<List<DomainProgressTableData>> getAllDomainProgress() =>
      select(domainProgressTable).get();

  Future<DomainProgressTableData> getDomainProgress(String domain) =>
      (select(domainProgressTable)..where((d) => d.domain.equals(domain)))
          .getSingle();

  Future<void> updateDomainProgress(DomainProgressTableCompanion entry,
      String domain) =>
      (update(domainProgressTable)..where((d) => d.domain.equals(domain)))
          .write(entry);

  // Session logs
  Future<void> insertSessionLog(SessionLogsCompanion entry) =>
      into(sessionLogs).insert(entry);

  Future<List<SessionLog>> getSessionHistory({int limit = 30}) =>
      (select(sessionLogs)
            ..orderBy([(s) => OrderingTerm.desc(s.date)])
            ..limit(limit))
          .get();
}
