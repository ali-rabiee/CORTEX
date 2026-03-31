import 'package:drift/drift.dart';

class ConfidenceLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conceptId => text()();
  IntColumn get confidence => integer()();
  IntColumn get quality => integer()();
  DateTimeColumn get timestamp => dateTime()();
}
