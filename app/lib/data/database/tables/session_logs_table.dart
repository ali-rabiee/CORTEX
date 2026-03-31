import 'package:drift/drift.dart';

class SessionLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get cardsReviewed => integer()();
  IntColumn get quizCorrect => integer()();
  IntColumn get quizTotal => integer()();
  IntColumn get durationMinutes => integer()();
  RealColumn get averageQuality => real()();
}
