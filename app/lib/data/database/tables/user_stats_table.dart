import 'package:drift/drift.dart';

class UserStatsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSessionDate => dateTime().nullable()();
  IntColumn get totalSessions => integer().withDefault(const Constant(0))();
  IntColumn get totalReviews => integer().withDefault(const Constant(0))();

  @override
  String get tableName => 'user_stats';

  @override
  Set<Column> get primaryKey => {id};
}
