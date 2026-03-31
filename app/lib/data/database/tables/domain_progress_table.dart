import 'package:drift/drift.dart';

class DomainProgressTable extends Table {
  TextColumn get domain => text()();
  RealColumn get masteryScore => real().withDefault(const Constant(0.0))();
  IntColumn get totalReviews => integer().withDefault(const Constant(0))();
  IntColumn get correctQuizAnswers =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalQuizAnswers =>
      integer().withDefault(const Constant(0))();

  @override
  String get tableName => 'domain_progress';

  @override
  Set<Column> get primaryKey => {domain};
}
