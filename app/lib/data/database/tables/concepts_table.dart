import 'package:drift/drift.dart';

class Concepts extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get definition => text()();
  TextColumn get intuition => text()();
  TextColumn get practicalExample => text()();
  TextColumn get failureMode => text()();
  TextColumn get interviewAnswer => text()();
  TextColumn get tags => text()(); // JSON array
  IntColumn get difficulty => integer()();
  IntColumn get importance => integer()();
  TextColumn get relatedConceptIds => text()(); // JSON array

  @override
  Set<Column> get primaryKey => {id};
}
