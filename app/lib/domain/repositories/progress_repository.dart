import '../entities/session_config.dart';
import '../entities/user_progress.dart';

/// Interface for progress and stats data access.
abstract class ProgressRepository {
  Future<UserStats> getUserStats();
  Future<void> updateUserStats(UserStats stats);

  Future<List<DomainMastery>> getAllDomainMastery();
  Future<DomainMastery> getDomainMastery(String domain);
  Future<void> updateDomainMastery(DomainMastery mastery);

  Future<void> logSession(SessionResult result);
  Future<List<SessionResult>> getSessionHistory({int limit = 30});

  Future<void> updateStreak();
}
