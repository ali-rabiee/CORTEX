import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/concepts_table.dart';
import 'tables/review_cards_table.dart';
import 'tables/confidence_logs_table.dart';
import 'tables/quiz_questions_table.dart';
import 'tables/quiz_attempts_table.dart';
import 'tables/domain_progress_table.dart';
import 'tables/session_logs_table.dart';
import 'tables/user_stats_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Concepts,
  ReviewCards,
  ConfidenceLogs,
  QuizQuestions,
  QuizAttempts,
  DomainProgressTable,
  SessionLogs,
  UserStatsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Initialize user stats with a single row
        await into(userStatsTable).insert(
          UserStatsTableCompanion.insert(),
        );
        // Initialize domain progress for all 7 domains
        for (final domain in [
          'rl',
          'robot_learning',
          'perception',
          'foundation_models',
          'generative_control',
          'systems',
          'ml_fundamentals',
        ]) {
          await into(domainProgressTable).insert(
            DomainProgressTableCompanion.insert(domain: domain),
          );
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cortex.db'));
    return NativeDatabase.createInBackground(file);
  });
}
