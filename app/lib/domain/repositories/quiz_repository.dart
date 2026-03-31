import '../entities/quiz_question.dart';

/// Interface for quiz data access.
abstract class QuizRepository {
  Future<List<QuizQuestion>> getAllQuestions();
  Future<List<QuizQuestion>> getQuestionsByConceptIds(List<String> conceptIds);
  Future<List<QuizQuestion>> getQuestionsByDomain(String domain);
  Future<void> insertQuestions(List<QuizQuestion> questions);
  Future<void> recordAttempt({
    required String questionId,
    required int selectedAnswer,
    required bool correct,
  });
  Future<int> getQuestionCount();
}
