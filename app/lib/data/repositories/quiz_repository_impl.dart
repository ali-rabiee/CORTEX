import 'dart:convert';

import '../../domain/entities/quiz_question.dart' as entity;
import '../../domain/repositories/quiz_repository.dart';
import '../database/app_database.dart';
import '../database/daos/quiz_dao.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizDao _dao;

  QuizRepositoryImpl(this._dao);

  @override
  Future<List<entity.QuizQuestion>> getAllQuestions() async {
    final rows = await _dao.getAllQuestions();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<entity.QuizQuestion>> getQuestionsByConceptIds(
      List<String> conceptIds) async {
    final rows = await _dao.getQuestionsByConceptIds(conceptIds);
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<entity.QuizQuestion>> getQuestionsByDomain(
      String domain) async {
    final rows = await _dao.getQuestionsByDomain(domain);
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> insertQuestions(List<entity.QuizQuestion> questions) async {
    final companions = questions.map(_toCompanion).toList();
    await _dao.insertAllQuestions(companions);
  }

  @override
  Future<void> recordAttempt({
    required String questionId,
    required int selectedAnswer,
    required bool correct,
  }) async {
    await _dao.recordAttempt(
      QuizAttemptsCompanion.insert(
        questionId: questionId,
        selectedAnswer: selectedAnswer,
        correct: correct,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Future<int> getQuestionCount() => _dao.getCount();

  entity.QuizQuestion _toDomain(QuizQuestion row) {
    return entity.QuizQuestion(
      id: row.id,
      question: row.question,
      options: (jsonDecode(row.options) as List).cast<String>(),
      correctAnswer: row.correctAnswer,
      explanation: row.explanation,
      conceptIds: (jsonDecode(row.conceptIds) as List).cast<String>(),
      difficulty: row.difficulty,
      tags: (jsonDecode(row.tags) as List).cast<String>(),
    );
  }

  QuizQuestionsCompanion _toCompanion(entity.QuizQuestion q) {
    return QuizQuestionsCompanion.insert(
      id: q.id,
      question: q.question,
      options: jsonEncode(q.options),
      correctAnswer: q.correctAnswer,
      explanation: q.explanation,
      conceptIds: jsonEncode(q.conceptIds),
      difficulty: q.difficulty,
      tags: jsonEncode(q.tags),
    );
  }
}
