import 'package:drift/drift.dart';

class ReviewCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conceptId => text()();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get interval => integer().withDefault(const Constant(1))();
  DateTimeColumn get nextReviewDate => dateTime()();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get lastQuality => integer().withDefault(const Constant(0))();
}
