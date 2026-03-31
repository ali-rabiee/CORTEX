import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../data/database/daos/concept_dao.dart';
import '../data/database/daos/review_dao.dart';
import '../data/database/daos/quiz_dao.dart';
import '../data/database/daos/progress_dao.dart';
import '../data/repositories/concept_repository_impl.dart';
import '../data/repositories/review_repository_impl.dart';
import '../data/repositories/quiz_repository_impl.dart';
import '../data/repositories/progress_repository_impl.dart';
import '../data/seeders/content_seeder.dart';
import '../domain/repositories/concept_repository.dart';
import '../domain/repositories/review_repository.dart';
import '../domain/repositories/quiz_repository.dart';
import '../domain/repositories/progress_repository.dart';
import '../domain/usecases/sm2_algorithm.dart';
import '../domain/usecases/generate_session.dart';
import '../domain/usecases/calculate_mastery.dart';
import '../domain/usecases/confidence_calibration.dart';

// Database
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// DAOs
final conceptDaoProvider = Provider<ConceptDao>((ref) {
  return ConceptDao(ref.watch(databaseProvider));
});

final reviewDaoProvider = Provider<ReviewDao>((ref) {
  return ReviewDao(ref.watch(databaseProvider));
});

final quizDaoProvider = Provider<QuizDao>((ref) {
  return QuizDao(ref.watch(databaseProvider));
});

final progressDaoProvider = Provider<ProgressDao>((ref) {
  return ProgressDao(ref.watch(databaseProvider));
});

// Repositories
final conceptRepositoryProvider = Provider<ConceptRepository>((ref) {
  return ConceptRepositoryImpl(ref.watch(conceptDaoProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewDaoProvider));
});

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepositoryImpl(ref.watch(quizDaoProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl(ref.watch(progressDaoProvider));
});

// Use cases
final sm2AlgorithmProvider = Provider<Sm2Algorithm>((ref) {
  return const Sm2Algorithm();
});

final generateSessionProvider = Provider<GenerateSession>((ref) {
  return const GenerateSession();
});

final calculateMasteryProvider = Provider<CalculateMastery>((ref) {
  return const CalculateMastery();
});

final confidenceCalibrationProvider = Provider<ConfidenceCalibration>((ref) {
  return const ConfidenceCalibration();
});

// Content seeder
final contentSeederProvider = Provider<ContentSeeder>((ref) {
  return ContentSeeder(
    conceptRepo: ref.watch(conceptRepositoryProvider),
    quizRepo: ref.watch(quizRepositoryProvider),
    reviewRepo: ref.watch(reviewRepositoryProvider),
  );
});

// App initialization
final appInitProvider = FutureProvider<void>((ref) async {
  final seeder = ref.watch(contentSeederProvider);
  await seeder.seedIfNeeded();
});
