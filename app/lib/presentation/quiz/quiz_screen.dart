import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/quiz_question.dart';
import '../shared/loading_indicator.dart';

final quizQuestionsProvider =
    FutureProvider<List<QuizQuestion>>((ref) async {
  final quizRepo = ref.watch(quizRepositoryProvider);
  final questions = await quizRepo.getAllQuestions();
  questions.shuffle();
  return questions.take(10).toList();
});

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentIndex = 0;
  int _correct = 0;
  int? _selectedAnswer;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(quizQuestionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: questionsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (questions) {
          if (questions.isEmpty) {
            return const Center(
              child: Text(
                'No quiz questions available yet.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          if (_currentIndex >= questions.length) {
            return _buildResult(questions.length);
          }
          return _buildQuestion(questions[_currentIndex], questions.length);
        },
      ),
    );
  }

  Widget _buildQuestion(QuizQuestion question, int total) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentIndex + 1} of $total',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              Text(
                '$_correct correct',
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / total,
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 24),

          // Question text
          Text(
            question.question,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Options
          ...List.generate(question.options.length, (i) {
            final isSelected = _selectedAnswer == i;
            final isCorrect = i == question.correctAnswer;

            Color borderColor = AppColors.borderDark;
            Color bgColor = AppColors.cardDark;
            if (_answered) {
              if (isCorrect) {
                borderColor = AppColors.success;
                bgColor = AppColors.success.withValues(alpha: 0.1);
              } else if (isSelected) {
                borderColor = AppColors.error;
                bgColor = AppColors.error.withValues(alpha: 0.1);
              }
            } else if (isSelected) {
              borderColor = AppColors.primary;
              bgColor = AppColors.primary.withValues(alpha: 0.1);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: _answered
                    ? null
                    : () => setState(() => _selectedAnswer = i),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    question.options[i],
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),

          if (!_answered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedAnswer != null
                    ? () {
                        final correct =
                            _selectedAnswer == question.correctAnswer;
                        setState(() {
                          _answered = true;
                          if (correct) _correct++;
                        });
                        // Record attempt
                        ref.read(quizRepositoryProvider).recordAttempt(
                              questionId: question.id,
                              selectedAnswer: _selectedAnswer!,
                              correct: correct,
                            );
                      }
                    : null,
                child: const Text('Submit Answer'),
              ),
            ),

          if (_answered) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedAnswer == question.correctAnswer
                        ? 'Correct!'
                        : 'Incorrect',
                    style: TextStyle(
                      color: _selectedAnswer == question.correctAnswer
                          ? AppColors.success
                          : AppColors.error,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.explanation,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  _currentIndex++;
                  _selectedAnswer = null;
                  _answered = false;
                }),
                child: Text(
                  _currentIndex + 1 < ref.read(quizQuestionsProvider).value!.length
                      ? 'Next Question'
                      : 'See Results',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResult(int total) {
    final pct = total > 0 ? ((_correct / total) * 100).round() : 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _correct >= total * 0.7
                  ? Icons.check_circle_outline
                  : Icons.info_outline,
              color: _correct >= total * 0.7
                  ? AppColors.success
                  : AppColors.warning,
              size: 64,
            ),
            const SizedBox(height: 20),
            const Text(
              'Quiz Complete',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$_correct / $total correct ($pct%)',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
