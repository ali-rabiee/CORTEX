import '../entities/concept.dart';

/// Interface for concept data access.
abstract class ConceptRepository {
  Future<List<Concept>> getAllConcepts();
  Future<Concept?> getConceptById(String id);
  Future<List<Concept>> getConceptsByDomain(String domain);
  Future<List<Concept>> searchConcepts(String query);
  Future<void> insertConcepts(List<Concept> concepts);
  Future<int> getConceptCount();
}
