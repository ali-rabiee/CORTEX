import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import 'session_provider.dart';
import 'widgets/concept_recall_card.dart';
import 'widgets/quality_rating_bar.dart';
import 'widgets/confidence_rating_bar.dart';
import 'widgets/session_summary.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  int? _selectedQuality;
  int? _selectedConfidence;
  int? _selectedQuizAnswer;
  bool _quizAnswered = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_phaseTitle(session.status)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: switch (session.status) {
        SessionStatus.loading => const Center(
            child: CircularProgressIndicator()),
        SessionStatus.warmup || SessionStatus.coreReview =>
          _buildReviewPhase(context, session),
        SessionStatus.challenge =>
          _buildChallengePhase(context, session),
        SessionStatus.cooldown || SessionStatus.finished =>
          SessionSummary(
            cardsReviewed: session.cardsReviewed,
            quizCorrect: session.quizCorrect,
            quizTotal: session.quizTotal,
            averageQuality: session.averageQuality,
            onFinish: () {
              ref.read(sessionProvider.notifier).finishSession();
              context.pop();
            },
          ),
      },
    );
  }

  Widget _buildReviewPhase(BuildContext context, SessionState session) {
    final cards = session.currentPhaseCards;
    if (session.currentIndex >= cards.length) {
      return const Center(child: Text('No cards to review'));
    }

    final card = cards[session.currentIndex];
    final concept = session.conceptMap[card.conceptId];
    if (concept == null) {
      return const Center(child: Text('Concept not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          _PhaseProgress(
            current: session.currentIndex + 1,
            total: cards.length,
            phase: session.status == SessionStatus.warmup
                ? 'Warmup'
                : 'Core Review',
          ),
          const SizedBox(height: 20),

          // Concept card
          ConceptRecallCard(
            concept: concept,
            revealed: session.cardRevealed,
            onReveal: () =>
                ref.read(sessionProvider.notifier).revealCard(),
          ),

          // Rating bars (shown after reveal)
          if (session.cardRevealed) ...[
            const SizedBox(height: 20),
            const Text(
              'How well did you know this?',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            QualityRatingBar(
              selected: _selectedQuality,
              onSelect: (q) => setState(() => _selectedQuality = q),
            ),
            const SizedBox(height: 16),
            const Text(
              'How confident were you?',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ConfidenceRatingBar(
              selected: _selectedConfidence,
              onSelect: (c) => setState(() => _selectedConfidence = c),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (_selectedQuality != null && _selectedConfidence != null)
                        ? () {
                            ref.read(sessionProvider.notifier).rateCard(
                                  _selectedQuality!,
                                  _selectedConfidence!,
                                );
                            setState(() {
                              _selectedQuality = null;
                              _selectedConfidence = null;
                            });
                          }
                        : null,
                child: const Text('Next'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChallengePhase(BuildContext context, SessionState session) {
    if (session.currentIndex >= session.challengeQuestions.length) {
      return SessionSummary(
        cardsReviewed: session.cardsReviewed,
        quizCorrect: session.quizCorrect,
        quizTotal: session.quizTotal,
        averageQuality: session.averageQuality,
        onFinish: () {
          ref.read(sessionProvider.notifier).finishSession();
          context.pop();
        },
      );
    }

    final question = session.challengeQuestions[session.currentIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PhaseProgress(
            current: session.currentIndex + 1,
            total: session.challengeQuestions.length,
            phase: 'Challenge',
          ),
          const SizedBox(height: 20),

          // Question
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
            final isSelected = _selectedQuizAnswer == i;
            final isCorrect = i == question.correctAnswer;

            Color borderColor = AppColors.borderDark;
            Color bgColor = AppColors.cardDark;
            if (_quizAnswered) {
              if (isCorrect) {
                borderColor = AppColors.success;
                bgColor = AppColors.success.withValues(alpha: 0.1);
              } else if (isSelected && !isCorrect) {
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
                onTap: _quizAnswered
                    ? null
                    : () => setState(() => _selectedQuizAnswer = i),
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

          if (!_quizAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedQuizAnswer != null
                    ? () => setState(() => _quizAnswered = true)
                    : null,
                child: const Text('Submit Answer'),
              ),
            ),

          if (_quizAnswered) ...[
            // Explanation
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
                    _selectedQuizAnswer == question.correctAnswer
                        ? 'Correct!'
                        : 'Incorrect',
                    style: TextStyle(
                      color: _selectedQuizAnswer == question.correctAnswer
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
                onPressed: () {
                  final correct =
                      _selectedQuizAnswer == question.correctAnswer;
                  ref.read(sessionProvider.notifier).answerQuiz(
                        _selectedQuizAnswer!,
                        correct,
                      );
                  setState(() {
                    _selectedQuizAnswer = null;
                    _quizAnswered = false;
                  });
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _phaseTitle(SessionStatus status) {
    switch (status) {
      case SessionStatus.loading:
        return 'Loading...';
      case SessionStatus.warmup:
        return 'Warmup';
      case SessionStatus.coreReview:
        return 'Core Review';
      case SessionStatus.challenge:
        return 'Challenge';
      case SessionStatus.cooldown:
      case SessionStatus.finished:
        return 'Session Complete';
    }
  }
}

class _PhaseProgress extends StatelessWidget {
  final int current;
  final int total;
  final String phase;

  const _PhaseProgress({
    required this.current,
    required this.total,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              phase,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$current / $total',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: total > 0 ? current / total : 0,
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
