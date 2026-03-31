import 'package:drift/drift.dart';

class QuizQuestions extends Table {
  TextColumn get id => text()();
  TextColumn get question => text()();
  TextColumn get options => text()(); // JSON array
  IntColumn get correctAnswer => integer()();
  TextColumn get explanation => text()();
  TextColumn get conceptIds => text()(); // JSON array
  IntColumn get difficulty => integer()();
  TextColumn get tags => text()(); // JSON array

  @override
  Set<Column> get primaryKey => {id};
}
