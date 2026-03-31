import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/concept.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/review_card.dart';
import '../../domain/repositories/concept_repository.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../../domain/repositories/review_repository.dart';

/// Loads JSON seed content from assets into the database on first run.
class ContentSeeder {
  final ConceptRepository _conceptRepo;
  final QuizRepository _quizRepo;
  final ReviewRepository _reviewRepo;

  ContentSeeder({
    required ConceptRepository conceptRepo,
    required QuizRepository quizRepo,
    required ReviewRepository reviewRepo,
  })  : _conceptRepo = conceptRepo,
        _quizRepo = quizRepo,
        _reviewRepo = reviewRepo;

  /// Seeds the database if it's empty.
  Future<void> seedIfNeeded() async {
    final conceptCount = await _conceptRepo.getConceptCount();
    if (conceptCount > 0) return; // Already seeded

    await _seedConcepts();
    await _seedQuizzes();
  }

  Future<void> _seedConcepts() async {
    final domains = [
      'rl',
      'robot_learning',
      'perception',
      'foundation_models',
      'generative_control',
      'systems',
    ];

    final allConcepts = <Concept>[];

    for (final domain in domains) {
      try {
        final jsonStr = await rootBundle
            .loadString('assets/content/concepts/$domain.json');
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        final concepts =
            jsonList.map((j) => Concept.fromJson(j as Map<String, dynamic>)).toList();
        allConcepts.addAll(concepts);
      } catch (e) {
        // Skip missing domain files gracefully
        continue;
      }
    }

    if (allConcepts.isEmpty) return;

    await _conceptRepo.insertConcepts(allConcepts);

    // Create review cards for each concept, due immediately
    final now = DateTime.now();
    final reviewCards = allConcepts
        .map((c) => ReviewCard(
              id: 0, // auto-increment
              conceptId: c.id,
              nextReviewDate: now,
            ))
        .toList();
    await _reviewRepo.insertCards(reviewCards);
  }

  Future<void> _seedQuizzes() async {
    final domains = [
      'rl',
      'robot_learning',
      'perception',
      'foundation_models',
      'generative_control',
      'systems',
    ];

    final allQuestions = <QuizQuestion>[];

    for (final domain in domains) {
      try {
        final jsonStr = await rootBundle
            .loadString('assets/content/quizzes/${domain}_quiz.json');
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        final questions = jsonList
            .map((j) => QuizQuestion.fromJson(j as Map<String, dynamic>))
            .toList();
        allQuestions.addAll(questions);
      } catch (e) {
        continue;
      }
    }

    if (allQuestions.isEmpty) return;
    await _quizRepo.insertQuestions(allQuestions);
  }
}
