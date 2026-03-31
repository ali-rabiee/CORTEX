import 'package:drift/drift.dart';

class QuizAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get questionId => text()();
  IntColumn get selectedAnswer => integer()();
  BoolColumn get correct => boolean()();
  DateTimeColumn get timestamp => dateTime()();
}
