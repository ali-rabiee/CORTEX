import 'dart:convert';

import '../../domain/entities/concept.dart' as entity;
import '../../domain/repositories/concept_repository.dart';
import '../database/app_database.dart';
import '../database/daos/concept_dao.dart';

class ConceptRepositoryImpl implements ConceptRepository {
  final ConceptDao _dao;

  ConceptRepositoryImpl(this._dao);

  @override
  Future<List<entity.Concept>> getAllConcepts() async {
    final rows = await _dao.getAllConcepts();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<entity.Concept?> getConceptById(String id) async {
    final row = await _dao.getConceptById(id);
    return row != null ? _toDomain(row) : null;
  }

  @override
  Future<List<entity.Concept>> getConceptsByDomain(String domain) async {
    final rows = await _dao.getConceptsByDomain(domain);
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<entity.Concept>> searchConcepts(String query) async {
    final rows = await _dao.searchConcepts(query);
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> insertConcepts(List<entity.Concept> concepts) async {
    final companions = concepts.map(_toCompanion).toList();
    await _dao.insertAllConcepts(companions);
  }

  @override
  Future<int> getConceptCount() => _dao.getCount();

  entity.Concept _toDomain(Concept row) {
    return entity.Concept(
      id: row.id,
      title: row.title,
      definition: row.definition,
      intuition: row.intuition,
      practicalExample: row.practicalExample,
      failureMode: row.failureMode,
      interviewAnswer: row.interviewAnswer,
      tags: (jsonDecode(row.tags) as List).cast<String>(),
      difficulty: row.difficulty,
      importance: row.importance,
      relatedConceptIds:
          (jsonDecode(row.relatedConceptIds) as List).cast<String>(),
    );
  }

  ConceptsCompanion _toCompanion(entity.Concept concept) {
    return ConceptsCompanion.insert(
      id: concept.id,
      title: concept.title,
      definition: concept.definition,
      intuition: concept.intuition,
      practicalExample: concept.practicalExample,
      failureMode: concept.failureMode,
      interviewAnswer: concept.interviewAnswer,
      tags: jsonEncode(concept.tags),
      difficulty: concept.difficulty,
      importance: concept.importance,
      relatedConceptIds: jsonEncode(concept.relatedConceptIds),
    );
  }
}
