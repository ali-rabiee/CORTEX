import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/concepts_table.dart';

part 'concept_dao.g.dart';

@DriftAccessor(tables: [Concepts])
class ConceptDao extends DatabaseAccessor<AppDatabase>
    with _$ConceptDaoMixin {
  ConceptDao(super.db);

  Future<List<Concept>> getAllConcepts() => select(concepts).get();

  Future<Concept?> getConceptById(String id) =>
      (select(concepts)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<List<Concept>> getConceptsByDomain(String domain) =>
      (select(concepts)..where((c) => c.tags.like('%$domain%'))).get();

  Future<List<Concept>> searchConcepts(String query) {
    final pattern = '%$query%';
    return (select(concepts)
          ..where(
            (c) => c.title.like(pattern) | c.definition.like(pattern),
          ))
        .get();
  }

  Future<void> insertAllConcepts(List<ConceptsCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(concepts, entries, mode: InsertMode.insertOrReplace);
    });
  }

  Future<int> getCount() async {
    final count = concepts.id.count();
    final query = selectOnly(concepts)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count)!;
  }
}
