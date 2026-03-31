import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/quiz_questions_table.dart';
import '../tables/quiz_attempts_table.dart';

part 'quiz_dao.g.dart';

@DriftAccessor(tables: [QuizQuestions, QuizAttempts])
class QuizDao extends DatabaseAccessor<AppDatabase> with _$QuizDaoMixin {
  QuizDao(super.db);

  Future<List<QuizQuestion>> getAllQuestions() =>
      select(quizQuestions).get();

  Future<List<QuizQuestion>> getQuestionsByDomain(String domain) =>
      (select(quizQuestions)..where((q) => q.tags.like('%$domain%'))).get();

  Future<List<QuizQuestion>> getQuestionsByConceptIds(
      List<String> conceptIds) {
    // Match questions that reference any of the given concept IDs
    return (select(quizQuestions)..where((q) {
      Expression<bool>? expr;
      for (final id in conceptIds) {
        final condition = q.conceptIds.like('%$id%');
        expr = expr == null ? condition : (expr | condition);
      }
      return expr ?? const Constant(false);
    })).get();
  }

  Future<void> insertAllQuestions(
      List<QuizQuestionsCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(quizQuestions, entries, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> recordAttempt(QuizAttemptsCompanion entry) =>
      into(quizAttempts).insert(entry);

  Future<int> getCount() async {
    final count = quizQuestions.id.count();
    final query = selectOnly(quizQuestions)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count)!;
  }
}
