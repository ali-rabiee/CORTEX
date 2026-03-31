// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ConceptsTable extends Concepts with TableInfo<$ConceptsTable, Concept> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConceptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _definitionMeta = const VerificationMeta(
    'definition',
  );
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
    'definition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intuitionMeta = const VerificationMeta(
    'intuition',
  );
  @override
  late final GeneratedColumn<String> intuition = GeneratedColumn<String>(
    'intuition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _practicalExampleMeta = const VerificationMeta(
    'practicalExample',
  );
  @override
  late final GeneratedColumn<String> practicalExample = GeneratedColumn<String>(
    'practical_example',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failureModeMeta = const VerificationMeta(
    'failureMode',
  );
  @override
  late final GeneratedColumn<String> failureMode = GeneratedColumn<String>(
    'failure_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interviewAnswerMeta = const VerificationMeta(
    'interviewAnswer',
  );
  @override
  late final GeneratedColumn<String> interviewAnswer = GeneratedColumn<String>(
    'interview_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importanceMeta = const VerificationMeta(
    'importance',
  );
  @override
  late final GeneratedColumn<int> importance = GeneratedColumn<int>(
    'importance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedConceptIdsMeta = const VerificationMeta(
    'relatedConceptIds',
  );
  @override
  late final GeneratedColumn<String> relatedConceptIds =
      GeneratedColumn<String>(
        'related_concept_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    definition,
    intuition,
    practicalExample,
    failureMode,
    interviewAnswer,
    tags,
    difficulty,
    importance,
    relatedConceptIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'concepts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Concept> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('definition')) {
      context.handle(
        _definitionMeta,
        definition.isAcceptableOrUnknown(data['definition']!, _definitionMeta),
      );
    } else if (isInserting) {
      context.missing(_definitionMeta);
    }
    if (data.containsKey('intuition')) {
      context.handle(
        _intuitionMeta,
        intuition.isAcceptableOrUnknown(data['intuition']!, _intuitionMeta),
      );
    } else if (isInserting) {
      context.missing(_intuitionMeta);
    }
    if (data.containsKey('practical_example')) {
      context.handle(
        _practicalExampleMeta,
        practicalExample.isAcceptableOrUnknown(
          data['practical_example']!,
          _practicalExampleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_practicalExampleMeta);
    }
    if (data.containsKey('failure_mode')) {
      context.handle(
        _failureModeMeta,
        failureMode.isAcceptableOrUnknown(
          data['failure_mode']!,
          _failureModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_failureModeMeta);
    }
    if (data.containsKey('interview_answer')) {
      context.handle(
        _interviewAnswerMeta,
        interviewAnswer.isAcceptableOrUnknown(
          data['interview_answer']!,
          _interviewAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interviewAnswerMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('importance')) {
      context.handle(
        _importanceMeta,
        importance.isAcceptableOrUnknown(data['importance']!, _importanceMeta),
      );
    } else if (isInserting) {
      context.missing(_importanceMeta);
    }
    if (data.containsKey('related_concept_ids')) {
      context.handle(
        _relatedConceptIdsMeta,
        relatedConceptIds.isAcceptableOrUnknown(
          data['related_concept_ids']!,
          _relatedConceptIdsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relatedConceptIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Concept map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Concept(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      definition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition'],
      )!,
      intuition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intuition'],
      )!,
      practicalExample: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}practical_example'],
      )!,
      failureMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failure_mode'],
      )!,
      interviewAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}interview_answer'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      importance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}importance'],
      )!,
      relatedConceptIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_concept_ids'],
      )!,
    );
  }

  @override
  $ConceptsTable createAlias(String alias) {
    return $ConceptsTable(attachedDatabase, alias);
  }
}

class Concept extends DataClass implements Insertable<Concept> {
  final String id;
  final String title;
  final String definition;
  final String intuition;
  final String practicalExample;
  final String failureMode;
  final String interviewAnswer;
  final String tags;
  final int difficulty;
  final int importance;
  final String relatedConceptIds;
  const Concept({
    required this.id,
    required this.title,
    required this.definition,
    required this.intuition,
    required this.practicalExample,
    required this.failureMode,
    required this.interviewAnswer,
    required this.tags,
    required this.difficulty,
    required this.importance,
    required this.relatedConceptIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['definition'] = Variable<String>(definition);
    map['intuition'] = Variable<String>(intuition);
    map['practical_example'] = Variable<String>(practicalExample);
    map['failure_mode'] = Variable<String>(failureMode);
    map['interview_answer'] = Variable<String>(interviewAnswer);
    map['tags'] = Variable<String>(tags);
    map['difficulty'] = Variable<int>(difficulty);
    map['importance'] = Variable<int>(importance);
    map['related_concept_ids'] = Variable<String>(relatedConceptIds);
    return map;
  }

  ConceptsCompanion toCompanion(bool nullToAbsent) {
    return ConceptsCompanion(
      id: Value(id),
      title: Value(title),
      definition: Value(definition),
      intuition: Value(intuition),
      practicalExample: Value(practicalExample),
      failureMode: Value(failureMode),
      interviewAnswer: Value(interviewAnswer),
      tags: Value(tags),
      difficulty: Value(difficulty),
      importance: Value(importance),
      relatedConceptIds: Value(relatedConceptIds),
    );
  }

  factory Concept.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Concept(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      definition: serializer.fromJson<String>(json['definition']),
      intuition: serializer.fromJson<String>(json['intuition']),
      practicalExample: serializer.fromJson<String>(json['practicalExample']),
      failureMode: serializer.fromJson<String>(json['failureMode']),
      interviewAnswer: serializer.fromJson<String>(json['interviewAnswer']),
      tags: serializer.fromJson<String>(json['tags']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      importance: serializer.fromJson<int>(json['importance']),
      relatedConceptIds: serializer.fromJson<String>(json['relatedConceptIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'definition': serializer.toJson<String>(definition),
      'intuition': serializer.toJson<String>(intuition),
      'practicalExample': serializer.toJson<String>(practicalExample),
      'failureMode': serializer.toJson<String>(failureMode),
      'interviewAnswer': serializer.toJson<String>(interviewAnswer),
      'tags': serializer.toJson<String>(tags),
      'difficulty': serializer.toJson<int>(difficulty),
      'importance': serializer.toJson<int>(importance),
      'relatedConceptIds': serializer.toJson<String>(relatedConceptIds),
    };
  }

  Concept copyWith({
    String? id,
    String? title,
    String? definition,
    String? intuition,
    String? practicalExample,
    String? failureMode,
    String? interviewAnswer,
    String? tags,
    int? difficulty,
    int? importance,
    String? relatedConceptIds,
  }) => Concept(
    id: id ?? this.id,
    title: title ?? this.title,
    definition: definition ?? this.definition,
    intuition: intuition ?? this.intuition,
    practicalExample: practicalExample ?? this.practicalExample,
    failureMode: failureMode ?? this.failureMode,
    interviewAnswer: interviewAnswer ?? this.interviewAnswer,
    tags: tags ?? this.tags,
    difficulty: difficulty ?? this.difficulty,
    importance: importance ?? this.importance,
    relatedConceptIds: relatedConceptIds ?? this.relatedConceptIds,
  );
  Concept copyWithCompanion(ConceptsCompanion data) {
    return Concept(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      definition: data.definition.present
          ? data.definition.value
          : this.definition,
      intuition: data.intuition.present ? data.intuition.value : this.intuition,
      practicalExample: data.practicalExample.present
          ? data.practicalExample.value
          : this.practicalExample,
      failureMode: data.failureMode.present
          ? data.failureMode.value
          : this.failureMode,
      interviewAnswer: data.interviewAnswer.present
          ? data.interviewAnswer.value
          : this.interviewAnswer,
      tags: data.tags.present ? data.tags.value : this.tags,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      importance: data.importance.present
          ? data.importance.value
          : this.importance,
      relatedConceptIds: data.relatedConceptIds.present
          ? data.relatedConceptIds.value
          : this.relatedConceptIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Concept(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('definition: $definition, ')
          ..write('intuition: $intuition, ')
          ..write('practicalExample: $practicalExample, ')
          ..write('failureMode: $failureMode, ')
          ..write('interviewAnswer: $interviewAnswer, ')
          ..write('tags: $tags, ')
          ..write('difficulty: $difficulty, ')
          ..write('importance: $importance, ')
          ..write('relatedConceptIds: $relatedConceptIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    definition,
    intuition,
    practicalExample,
    failureMode,
    interviewAnswer,
    tags,
    difficulty,
    importance,
    relatedConceptIds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Concept &&
          other.id == this.id &&
          other.title == this.title &&
          other.definition == this.definition &&
          other.intuition == this.intuition &&
          other.practicalExample == this.practicalExample &&
          other.failureMode == this.failureMode &&
          other.interviewAnswer == this.interviewAnswer &&
          other.tags == this.tags &&
          other.difficulty == this.difficulty &&
          other.importance == this.importance &&
          other.relatedConceptIds == this.relatedConceptIds);
}

class ConceptsCompanion extends UpdateCompanion<Concept> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> definition;
  final Value<String> intuition;
  final Value<String> practicalExample;
  final Value<String> failureMode;
  final Value<String> interviewAnswer;
  final Value<String> tags;
  final Value<int> difficulty;
  final Value<int> importance;
  final Value<String> relatedConceptIds;
  final Value<int> rowid;
  const ConceptsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.definition = const Value.absent(),
    this.intuition = const Value.absent(),
    this.practicalExample = const Value.absent(),
    this.failureMode = const Value.absent(),
    this.interviewAnswer = const Value.absent(),
    this.tags = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.importance = const Value.absent(),
    this.relatedConceptIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConceptsCompanion.insert({
    required String id,
    required String title,
    required String definition,
    required String intuition,
    required String practicalExample,
    required String failureMode,
    required String interviewAnswer,
    required String tags,
    required int difficulty,
    required int importance,
    required String relatedConceptIds,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       definition = Value(definition),
       intuition = Value(intuition),
       practicalExample = Value(practicalExample),
       failureMode = Value(failureMode),
       interviewAnswer = Value(interviewAnswer),
       tags = Value(tags),
       difficulty = Value(difficulty),
       importance = Value(importance),
       relatedConceptIds = Value(relatedConceptIds);
  static Insertable<Concept> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? definition,
    Expression<String>? intuition,
    Expression<String>? practicalExample,
    Expression<String>? failureMode,
    Expression<String>? interviewAnswer,
    Expression<String>? tags,
    Expression<int>? difficulty,
    Expression<int>? importance,
    Expression<String>? relatedConceptIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (definition != null) 'definition': definition,
      if (intuition != null) 'intuition': intuition,
      if (practicalExample != null) 'practical_example': practicalExample,
      if (failureMode != null) 'failure_mode': failureMode,
      if (interviewAnswer != null) 'interview_answer': interviewAnswer,
      if (tags != null) 'tags': tags,
      if (difficulty != null) 'difficulty': difficulty,
      if (importance != null) 'importance': importance,
      if (relatedConceptIds != null) 'related_concept_ids': relatedConceptIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConceptsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? definition,
    Value<String>? intuition,
    Value<String>? practicalExample,
    Value<String>? failureMode,
    Value<String>? interviewAnswer,
    Value<String>? tags,
    Value<int>? difficulty,
    Value<int>? importance,
    Value<String>? relatedConceptIds,
    Value<int>? rowid,
  }) {
    return ConceptsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      definition: definition ?? this.definition,
      intuition: intuition ?? this.intuition,
      practicalExample: practicalExample ?? this.practicalExample,
      failureMode: failureMode ?? this.failureMode,
      interviewAnswer: interviewAnswer ?? this.interviewAnswer,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      importance: importance ?? this.importance,
      relatedConceptIds: relatedConceptIds ?? this.relatedConceptIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    if (intuition.present) {
      map['intuition'] = Variable<String>(intuition.value);
    }
    if (practicalExample.present) {
      map['practical_example'] = Variable<String>(practicalExample.value);
    }
    if (failureMode.present) {
      map['failure_mode'] = Variable<String>(failureMode.value);
    }
    if (interviewAnswer.present) {
      map['interview_answer'] = Variable<String>(interviewAnswer.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (importance.present) {
      map['importance'] = Variable<int>(importance.value);
    }
    if (relatedConceptIds.present) {
      map['related_concept_ids'] = Variable<String>(relatedConceptIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConceptsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('definition: $definition, ')
          ..write('intuition: $intuition, ')
          ..write('practicalExample: $practicalExample, ')
          ..write('failureMode: $failureMode, ')
          ..write('interviewAnswer: $interviewAnswer, ')
          ..write('tags: $tags, ')
          ..write('difficulty: $difficulty, ')
          ..write('importance: $importance, ')
          ..write('relatedConceptIds: $relatedConceptIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewCardsTable extends ReviewCards
    with TableInfo<$ReviewCardsTable, ReviewCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _conceptIdMeta = const VerificationMeta(
    'conceptId',
  );
  @override
  late final GeneratedColumn<String> conceptId = GeneratedColumn<String>(
    'concept_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nextReviewDateMeta = const VerificationMeta(
    'nextReviewDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewDate =
      GeneratedColumn<DateTime>(
        'next_review_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastQualityMeta = const VerificationMeta(
    'lastQuality',
  );
  @override
  late final GeneratedColumn<int> lastQuality = GeneratedColumn<int>(
    'last_quality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conceptId,
    easeFactor,
    interval,
    nextReviewDate,
    repetitions,
    lastQuality,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concept_id')) {
      context.handle(
        _conceptIdMeta,
        conceptId.isAcceptableOrUnknown(data['concept_id']!, _conceptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptIdMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
        _nextReviewDateMeta,
        nextReviewDate.isAcceptableOrUnknown(
          data['next_review_date']!,
          _nextReviewDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextReviewDateMeta);
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('last_quality')) {
      context.handle(
        _lastQualityMeta,
        lastQuality.isAcceptableOrUnknown(
          data['last_quality']!,
          _lastQualityMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      conceptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept_id'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      nextReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_date'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      lastQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_quality'],
      )!,
    );
  }

  @override
  $ReviewCardsTable createAlias(String alias) {
    return $ReviewCardsTable(attachedDatabase, alias);
  }
}

class ReviewCard extends DataClass implements Insertable<ReviewCard> {
  final int id;
  final String conceptId;
  final double easeFactor;
  final int interval;
  final DateTime nextReviewDate;
  final int repetitions;
  final int lastQuality;
  const ReviewCard({
    required this.id,
    required this.conceptId,
    required this.easeFactor,
    required this.interval,
    required this.nextReviewDate,
    required this.repetitions,
    required this.lastQuality,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['concept_id'] = Variable<String>(conceptId);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval'] = Variable<int>(interval);
    map['next_review_date'] = Variable<DateTime>(nextReviewDate);
    map['repetitions'] = Variable<int>(repetitions);
    map['last_quality'] = Variable<int>(lastQuality);
    return map;
  }

  ReviewCardsCompanion toCompanion(bool nullToAbsent) {
    return ReviewCardsCompanion(
      id: Value(id),
      conceptId: Value(conceptId),
      easeFactor: Value(easeFactor),
      interval: Value(interval),
      nextReviewDate: Value(nextReviewDate),
      repetitions: Value(repetitions),
      lastQuality: Value(lastQuality),
    );
  }

  factory ReviewCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewCard(
      id: serializer.fromJson<int>(json['id']),
      conceptId: serializer.fromJson<String>(json['conceptId']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      interval: serializer.fromJson<int>(json['interval']),
      nextReviewDate: serializer.fromJson<DateTime>(json['nextReviewDate']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      lastQuality: serializer.fromJson<int>(json['lastQuality']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conceptId': serializer.toJson<String>(conceptId),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'interval': serializer.toJson<int>(interval),
      'nextReviewDate': serializer.toJson<DateTime>(nextReviewDate),
      'repetitions': serializer.toJson<int>(repetitions),
      'lastQuality': serializer.toJson<int>(lastQuality),
    };
  }

  ReviewCard copyWith({
    int? id,
    String? conceptId,
    double? easeFactor,
    int? interval,
    DateTime? nextReviewDate,
    int? repetitions,
    int? lastQuality,
  }) => ReviewCard(
    id: id ?? this.id,
    conceptId: conceptId ?? this.conceptId,
    easeFactor: easeFactor ?? this.easeFactor,
    interval: interval ?? this.interval,
    nextReviewDate: nextReviewDate ?? this.nextReviewDate,
    repetitions: repetitions ?? this.repetitions,
    lastQuality: lastQuality ?? this.lastQuality,
  );
  ReviewCard copyWithCompanion(ReviewCardsCompanion data) {
    return ReviewCard(
      id: data.id.present ? data.id.value : this.id,
      conceptId: data.conceptId.present ? data.conceptId.value : this.conceptId,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      interval: data.interval.present ? data.interval.value : this.interval,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      lastQuality: data.lastQuality.present
          ? data.lastQuality.value
          : this.lastQuality,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewCard(')
          ..write('id: $id, ')
          ..write('conceptId: $conceptId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('interval: $interval, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('repetitions: $repetitions, ')
          ..write('lastQuality: $lastQuality')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conceptId,
    easeFactor,
    interval,
    nextReviewDate,
    repetitions,
    lastQuality,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewCard &&
          other.id == this.id &&
          other.conceptId == this.conceptId &&
          other.easeFactor == this.easeFactor &&
          other.interval == this.interval &&
          other.nextReviewDate == this.nextReviewDate &&
          other.repetitions == this.repetitions &&
          other.lastQuality == this.lastQuality);
}

class ReviewCardsCompanion extends UpdateCompanion<ReviewCard> {
  final Value<int> id;
  final Value<String> conceptId;
  final Value<double> easeFactor;
  final Value<int> interval;
  final Value<DateTime> nextReviewDate;
  final Value<int> repetitions;
  final Value<int> lastQuality;
  const ReviewCardsCompanion({
    this.id = const Value.absent(),
    this.conceptId = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.interval = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lastQuality = const Value.absent(),
  });
  ReviewCardsCompanion.insert({
    this.id = const Value.absent(),
    required String conceptId,
    this.easeFactor = const Value.absent(),
    this.interval = const Value.absent(),
    required DateTime nextReviewDate,
    this.repetitions = const Value.absent(),
    this.lastQuality = const Value.absent(),
  }) : conceptId = Value(conceptId),
       nextReviewDate = Value(nextReviewDate);
  static Insertable<ReviewCard> custom({
    Expression<int>? id,
    Expression<String>? conceptId,
    Expression<double>? easeFactor,
    Expression<int>? interval,
    Expression<DateTime>? nextReviewDate,
    Expression<int>? repetitions,
    Expression<int>? lastQuality,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conceptId != null) 'concept_id': conceptId,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (interval != null) 'interval': interval,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (repetitions != null) 'repetitions': repetitions,
      if (lastQuality != null) 'last_quality': lastQuality,
    });
  }

  ReviewCardsCompanion copyWith({
    Value<int>? id,
    Value<String>? conceptId,
    Value<double>? easeFactor,
    Value<int>? interval,
    Value<DateTime>? nextReviewDate,
    Value<int>? repetitions,
    Value<int>? lastQuality,
  }) {
    return ReviewCardsCompanion(
      id: id ?? this.id,
      conceptId: conceptId ?? this.conceptId,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      repetitions: repetitions ?? this.repetitions,
      lastQuality: lastQuality ?? this.lastQuality,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conceptId.present) {
      map['concept_id'] = Variable<String>(conceptId.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (lastQuality.present) {
      map['last_quality'] = Variable<int>(lastQuality.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewCardsCompanion(')
          ..write('id: $id, ')
          ..write('conceptId: $conceptId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('interval: $interval, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('repetitions: $repetitions, ')
          ..write('lastQuality: $lastQuality')
          ..write(')'))
        .toString();
  }
}

class $ConfidenceLogsTable extends ConfidenceLogs
    with TableInfo<$ConfidenceLogsTable, ConfidenceLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfidenceLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _conceptIdMeta = const VerificationMeta(
    'conceptId',
  );
  @override
  late final GeneratedColumn<String> conceptId = GeneratedColumn<String>(
    'concept_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<int> confidence = GeneratedColumn<int>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conceptId,
    confidence,
    quality,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'confidence_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfidenceLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concept_id')) {
      context.handle(
        _conceptIdMeta,
        conceptId.isAcceptableOrUnknown(data['concept_id']!, _conceptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptIdMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    } else if (isInserting) {
      context.missing(_qualityMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfidenceLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfidenceLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      conceptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept_id'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confidence'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ConfidenceLogsTable createAlias(String alias) {
    return $ConfidenceLogsTable(attachedDatabase, alias);
  }
}

class ConfidenceLog extends DataClass implements Insertable<ConfidenceLog> {
  final int id;
  final String conceptId;
  final int confidence;
  final int quality;
  final DateTime timestamp;
  const ConfidenceLog({
    required this.id,
    required this.conceptId,
    required this.confidence,
    required this.quality,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['concept_id'] = Variable<String>(conceptId);
    map['confidence'] = Variable<int>(confidence);
    map['quality'] = Variable<int>(quality);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ConfidenceLogsCompanion toCompanion(bool nullToAbsent) {
    return ConfidenceLogsCompanion(
      id: Value(id),
      conceptId: Value(conceptId),
      confidence: Value(confidence),
      quality: Value(quality),
      timestamp: Value(timestamp),
    );
  }

  factory ConfidenceLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfidenceLog(
      id: serializer.fromJson<int>(json['id']),
      conceptId: serializer.fromJson<String>(json['conceptId']),
      confidence: serializer.fromJson<int>(json['confidence']),
      quality: serializer.fromJson<int>(json['quality']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conceptId': serializer.toJson<String>(conceptId),
      'confidence': serializer.toJson<int>(confidence),
      'quality': serializer.toJson<int>(quality),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ConfidenceLog copyWith({
    int? id,
    String? conceptId,
    int? confidence,
    int? quality,
    DateTime? timestamp,
  }) => ConfidenceLog(
    id: id ?? this.id,
    conceptId: conceptId ?? this.conceptId,
    confidence: confidence ?? this.confidence,
    quality: quality ?? this.quality,
    timestamp: timestamp ?? this.timestamp,
  );
  ConfidenceLog copyWithCompanion(ConfidenceLogsCompanion data) {
    return ConfidenceLog(
      id: data.id.present ? data.id.value : this.id,
      conceptId: data.conceptId.present ? data.conceptId.value : this.conceptId,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      quality: data.quality.present ? data.quality.value : this.quality,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfidenceLog(')
          ..write('id: $id, ')
          ..write('conceptId: $conceptId, ')
          ..write('confidence: $confidence, ')
          ..write('quality: $quality, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, conceptId, confidence, quality, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfidenceLog &&
          other.id == this.id &&
          other.conceptId == this.conceptId &&
          other.confidence == this.confidence &&
          other.quality == this.quality &&
          other.timestamp == this.timestamp);
}

class ConfidenceLogsCompanion extends UpdateCompanion<ConfidenceLog> {
  final Value<int> id;
  final Value<String> conceptId;
  final Value<int> confidence;
  final Value<int> quality;
  final Value<DateTime> timestamp;
  const ConfidenceLogsCompanion({
    this.id = const Value.absent(),
    this.conceptId = const Value.absent(),
    this.confidence = const Value.absent(),
    this.quality = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ConfidenceLogsCompanion.insert({
    this.id = const Value.absent(),
    required String conceptId,
    required int confidence,
    required int quality,
    required DateTime timestamp,
  }) : conceptId = Value(conceptId),
       confidence = Value(confidence),
       quality = Value(quality),
       timestamp = Value(timestamp);
  static Insertable<ConfidenceLog> custom({
    Expression<int>? id,
    Expression<String>? conceptId,
    Expression<int>? confidence,
    Expression<int>? quality,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conceptId != null) 'concept_id': conceptId,
      if (confidence != null) 'confidence': confidence,
      if (quality != null) 'quality': quality,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ConfidenceLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? conceptId,
    Value<int>? confidence,
    Value<int>? quality,
    Value<DateTime>? timestamp,
  }) {
    return ConfidenceLogsCompanion(
      id: id ?? this.id,
      conceptId: conceptId ?? this.conceptId,
      confidence: confidence ?? this.confidence,
      quality: quality ?? this.quality,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conceptId.present) {
      map['concept_id'] = Variable<String>(conceptId.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<int>(confidence.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfidenceLogsCompanion(')
          ..write('id: $id, ')
          ..write('conceptId: $conceptId, ')
          ..write('confidence: $confidence, ')
          ..write('quality: $quality, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $QuizQuestionsTable extends QuizQuestions
    with TableInfo<$QuizQuestionsTable, QuizQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsMeta = const VerificationMeta(
    'options',
  );
  @override
  late final GeneratedColumn<String> options = GeneratedColumn<String>(
    'options',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswerMeta = const VerificationMeta(
    'correctAnswer',
  );
  @override
  late final GeneratedColumn<int> correctAnswer = GeneratedColumn<int>(
    'correct_answer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conceptIdsMeta = const VerificationMeta(
    'conceptIds',
  );
  @override
  late final GeneratedColumn<String> conceptIds = GeneratedColumn<String>(
    'concept_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    question,
    options,
    correctAnswer,
    explanation,
    conceptIds,
    difficulty,
    tags,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('options')) {
      context.handle(
        _optionsMeta,
        options.isAcceptableOrUnknown(data['options']!, _optionsMeta),
      );
    } else if (isInserting) {
      context.missing(_optionsMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
        _correctAnswerMeta,
        correctAnswer.isAcceptableOrUnknown(
          data['correct_answer']!,
          _correctAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('concept_ids')) {
      context.handle(
        _conceptIdsMeta,
        conceptIds.isAcceptableOrUnknown(data['concept_ids']!, _conceptIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptIdsMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizQuestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      options: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options'],
      )!,
      correctAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answer'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
      conceptIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept_ids'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
    );
  }

  @override
  $QuizQuestionsTable createAlias(String alias) {
    return $QuizQuestionsTable(attachedDatabase, alias);
  }
}

class QuizQuestion extends DataClass implements Insertable<QuizQuestion> {
  final String id;
  final String question;
  final String options;
  final int correctAnswer;
  final String explanation;
  final String conceptIds;
  final int difficulty;
  final String tags;
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.conceptIds,
    required this.difficulty,
    required this.tags,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['question'] = Variable<String>(question);
    map['options'] = Variable<String>(options);
    map['correct_answer'] = Variable<int>(correctAnswer);
    map['explanation'] = Variable<String>(explanation);
    map['concept_ids'] = Variable<String>(conceptIds);
    map['difficulty'] = Variable<int>(difficulty);
    map['tags'] = Variable<String>(tags);
    return map;
  }

  QuizQuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuizQuestionsCompanion(
      id: Value(id),
      question: Value(question),
      options: Value(options),
      correctAnswer: Value(correctAnswer),
      explanation: Value(explanation),
      conceptIds: Value(conceptIds),
      difficulty: Value(difficulty),
      tags: Value(tags),
    );
  }

  factory QuizQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizQuestion(
      id: serializer.fromJson<String>(json['id']),
      question: serializer.fromJson<String>(json['question']),
      options: serializer.fromJson<String>(json['options']),
      correctAnswer: serializer.fromJson<int>(json['correctAnswer']),
      explanation: serializer.fromJson<String>(json['explanation']),
      conceptIds: serializer.fromJson<String>(json['conceptIds']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      tags: serializer.fromJson<String>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'question': serializer.toJson<String>(question),
      'options': serializer.toJson<String>(options),
      'correctAnswer': serializer.toJson<int>(correctAnswer),
      'explanation': serializer.toJson<String>(explanation),
      'conceptIds': serializer.toJson<String>(conceptIds),
      'difficulty': serializer.toJson<int>(difficulty),
      'tags': serializer.toJson<String>(tags),
    };
  }

  QuizQuestion copyWith({
    String? id,
    String? question,
    String? options,
    int? correctAnswer,
    String? explanation,
    String? conceptIds,
    int? difficulty,
    String? tags,
  }) => QuizQuestion(
    id: id ?? this.id,
    question: question ?? this.question,
    options: options ?? this.options,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    explanation: explanation ?? this.explanation,
    conceptIds: conceptIds ?? this.conceptIds,
    difficulty: difficulty ?? this.difficulty,
    tags: tags ?? this.tags,
  );
  QuizQuestion copyWithCompanion(QuizQuestionsCompanion data) {
    return QuizQuestion(
      id: data.id.present ? data.id.value : this.id,
      question: data.question.present ? data.question.value : this.question,
      options: data.options.present ? data.options.value : this.options,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      conceptIds: data.conceptIds.present
          ? data.conceptIds.value
          : this.conceptIds,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestion(')
          ..write('id: $id, ')
          ..write('question: $question, ')
          ..write('options: $options, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('explanation: $explanation, ')
          ..write('conceptIds: $conceptIds, ')
          ..write('difficulty: $difficulty, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    question,
    options,
    correctAnswer,
    explanation,
    conceptIds,
    difficulty,
    tags,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizQuestion &&
          other.id == this.id &&
          other.question == this.question &&
          other.options == this.options &&
          other.correctAnswer == this.correctAnswer &&
          other.explanation == this.explanation &&
          other.conceptIds == this.conceptIds &&
          other.difficulty == this.difficulty &&
          other.tags == this.tags);
}

class QuizQuestionsCompanion extends UpdateCompanion<QuizQuestion> {
  final Value<String> id;
  final Value<String> question;
  final Value<String> options;
  final Value<int> correctAnswer;
  final Value<String> explanation;
  final Value<String> conceptIds;
  final Value<int> difficulty;
  final Value<String> tags;
  final Value<int> rowid;
  const QuizQuestionsCompanion({
    this.id = const Value.absent(),
    this.question = const Value.absent(),
    this.options = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.explanation = const Value.absent(),
    this.conceptIds = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizQuestionsCompanion.insert({
    required String id,
    required String question,
    required String options,
    required int correctAnswer,
    required String explanation,
    required String conceptIds,
    required int difficulty,
    required String tags,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       question = Value(question),
       options = Value(options),
       correctAnswer = Value(correctAnswer),
       explanation = Value(explanation),
       conceptIds = Value(conceptIds),
       difficulty = Value(difficulty),
       tags = Value(tags);
  static Insertable<QuizQuestion> custom({
    Expression<String>? id,
    Expression<String>? question,
    Expression<String>? options,
    Expression<int>? correctAnswer,
    Expression<String>? explanation,
    Expression<String>? conceptIds,
    Expression<int>? difficulty,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (question != null) 'question': question,
      if (options != null) 'options': options,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (explanation != null) 'explanation': explanation,
      if (conceptIds != null) 'concept_ids': conceptIds,
      if (difficulty != null) 'difficulty': difficulty,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizQuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? question,
    Value<String>? options,
    Value<int>? correctAnswer,
    Value<String>? explanation,
    Value<String>? conceptIds,
    Value<int>? difficulty,
    Value<String>? tags,
    Value<int>? rowid,
  }) {
    return QuizQuestionsCompanion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      conceptIds: conceptIds ?? this.conceptIds,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(options.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<int>(correctAnswer.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (conceptIds.present) {
      map['concept_ids'] = Variable<String>(conceptIds.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('question: $question, ')
          ..write('options: $options, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('explanation: $explanation, ')
          ..write('conceptIds: $conceptIds, ')
          ..write('difficulty: $difficulty, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptsTable extends QuizAttempts
    with TableInfo<$QuizAttemptsTable, QuizAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedAnswerMeta = const VerificationMeta(
    'selectedAnswer',
  );
  @override
  late final GeneratedColumn<int> selectedAnswer = GeneratedColumn<int>(
    'selected_answer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questionId,
    selectedAnswer,
    correct,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('selected_answer')) {
      context.handle(
        _selectedAnswerMeta,
        selectedAnswer.isAcceptableOrUnknown(
          data['selected_answer']!,
          _selectedAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedAnswerMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      selectedAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_answer'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $QuizAttemptsTable createAlias(String alias) {
    return $QuizAttemptsTable(attachedDatabase, alias);
  }
}

class QuizAttempt extends DataClass implements Insertable<QuizAttempt> {
  final int id;
  final String questionId;
  final int selectedAnswer;
  final bool correct;
  final DateTime timestamp;
  const QuizAttempt({
    required this.id,
    required this.questionId,
    required this.selectedAnswer,
    required this.correct,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['question_id'] = Variable<String>(questionId);
    map['selected_answer'] = Variable<int>(selectedAnswer);
    map['correct'] = Variable<bool>(correct);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  QuizAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptsCompanion(
      id: Value(id),
      questionId: Value(questionId),
      selectedAnswer: Value(selectedAnswer),
      correct: Value(correct),
      timestamp: Value(timestamp),
    );
  }

  factory QuizAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttempt(
      id: serializer.fromJson<int>(json['id']),
      questionId: serializer.fromJson<String>(json['questionId']),
      selectedAnswer: serializer.fromJson<int>(json['selectedAnswer']),
      correct: serializer.fromJson<bool>(json['correct']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questionId': serializer.toJson<String>(questionId),
      'selectedAnswer': serializer.toJson<int>(selectedAnswer),
      'correct': serializer.toJson<bool>(correct),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  QuizAttempt copyWith({
    int? id,
    String? questionId,
    int? selectedAnswer,
    bool? correct,
    DateTime? timestamp,
  }) => QuizAttempt(
    id: id ?? this.id,
    questionId: questionId ?? this.questionId,
    selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    correct: correct ?? this.correct,
    timestamp: timestamp ?? this.timestamp,
  );
  QuizAttempt copyWithCompanion(QuizAttemptsCompanion data) {
    return QuizAttempt(
      id: data.id.present ? data.id.value : this.id,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      selectedAnswer: data.selectedAnswer.present
          ? data.selectedAnswer.value
          : this.selectedAnswer,
      correct: data.correct.present ? data.correct.value : this.correct,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttempt(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('correct: $correct, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, questionId, selectedAnswer, correct, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttempt &&
          other.id == this.id &&
          other.questionId == this.questionId &&
          other.selectedAnswer == this.selectedAnswer &&
          other.correct == this.correct &&
          other.timestamp == this.timestamp);
}

class QuizAttemptsCompanion extends UpdateCompanion<QuizAttempt> {
  final Value<int> id;
  final Value<String> questionId;
  final Value<int> selectedAnswer;
  final Value<bool> correct;
  final Value<DateTime> timestamp;
  const QuizAttemptsCompanion({
    this.id = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedAnswer = const Value.absent(),
    this.correct = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  QuizAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String questionId,
    required int selectedAnswer,
    required bool correct,
    required DateTime timestamp,
  }) : questionId = Value(questionId),
       selectedAnswer = Value(selectedAnswer),
       correct = Value(correct),
       timestamp = Value(timestamp);
  static Insertable<QuizAttempt> custom({
    Expression<int>? id,
    Expression<String>? questionId,
    Expression<int>? selectedAnswer,
    Expression<bool>? correct,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      if (selectedAnswer != null) 'selected_answer': selectedAnswer,
      if (correct != null) 'correct': correct,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  QuizAttemptsCompanion copyWith({
    Value<int>? id,
    Value<String>? questionId,
    Value<int>? selectedAnswer,
    Value<bool>? correct,
    Value<DateTime>? timestamp,
  }) {
    return QuizAttemptsCompanion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correct: correct ?? this.correct,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (selectedAnswer.present) {
      map['selected_answer'] = Variable<int>(selectedAnswer.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('correct: $correct, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $DomainProgressTableTable extends DomainProgressTable
    with TableInfo<$DomainProgressTableTable, DomainProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DomainProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _domainMeta = const VerificationMeta('domain');
  @override
  late final GeneratedColumn<String> domain = GeneratedColumn<String>(
    'domain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteryScoreMeta = const VerificationMeta(
    'masteryScore',
  );
  @override
  late final GeneratedColumn<double> masteryScore = GeneratedColumn<double>(
    'mastery_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalReviewsMeta = const VerificationMeta(
    'totalReviews',
  );
  @override
  late final GeneratedColumn<int> totalReviews = GeneratedColumn<int>(
    'total_reviews',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctQuizAnswersMeta =
      const VerificationMeta('correctQuizAnswers');
  @override
  late final GeneratedColumn<int> correctQuizAnswers = GeneratedColumn<int>(
    'correct_quiz_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalQuizAnswersMeta = const VerificationMeta(
    'totalQuizAnswers',
  );
  @override
  late final GeneratedColumn<int> totalQuizAnswers = GeneratedColumn<int>(
    'total_quiz_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    domain,
    masteryScore,
    totalReviews,
    correctQuizAnswers,
    totalQuizAnswers,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'domain_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<DomainProgressTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('domain')) {
      context.handle(
        _domainMeta,
        domain.isAcceptableOrUnknown(data['domain']!, _domainMeta),
      );
    } else if (isInserting) {
      context.missing(_domainMeta);
    }
    if (data.containsKey('mastery_score')) {
      context.handle(
        _masteryScoreMeta,
        masteryScore.isAcceptableOrUnknown(
          data['mastery_score']!,
          _masteryScoreMeta,
        ),
      );
    }
    if (data.containsKey('total_reviews')) {
      context.handle(
        _totalReviewsMeta,
        totalReviews.isAcceptableOrUnknown(
          data['total_reviews']!,
          _totalReviewsMeta,
        ),
      );
    }
    if (data.containsKey('correct_quiz_answers')) {
      context.handle(
        _correctQuizAnswersMeta,
        correctQuizAnswers.isAcceptableOrUnknown(
          data['correct_quiz_answers']!,
          _correctQuizAnswersMeta,
        ),
      );
    }
    if (data.containsKey('total_quiz_answers')) {
      context.handle(
        _totalQuizAnswersMeta,
        totalQuizAnswers.isAcceptableOrUnknown(
          data['total_quiz_answers']!,
          _totalQuizAnswersMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {domain};
  @override
  DomainProgressTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DomainProgressTableData(
      domain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}domain'],
      )!,
      masteryScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mastery_score'],
      )!,
      totalReviews: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_reviews'],
      )!,
      correctQuizAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_quiz_answers'],
      )!,
      totalQuizAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_quiz_answers'],
      )!,
    );
  }

  @override
  $DomainProgressTableTable createAlias(String alias) {
    return $DomainProgressTableTable(attachedDatabase, alias);
  }
}

class DomainProgressTableData extends DataClass
    implements Insertable<DomainProgressTableData> {
  final String domain;
  final double masteryScore;
  final int totalReviews;
  final int correctQuizAnswers;
  final int totalQuizAnswers;
  const DomainProgressTableData({
    required this.domain,
    required this.masteryScore,
    required this.totalReviews,
    required this.correctQuizAnswers,
    required this.totalQuizAnswers,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['domain'] = Variable<String>(domain);
    map['mastery_score'] = Variable<double>(masteryScore);
    map['total_reviews'] = Variable<int>(totalReviews);
    map['correct_quiz_answers'] = Variable<int>(correctQuizAnswers);
    map['total_quiz_answers'] = Variable<int>(totalQuizAnswers);
    return map;
  }

  DomainProgressTableCompanion toCompanion(bool nullToAbsent) {
    return DomainProgressTableCompanion(
      domain: Value(domain),
      masteryScore: Value(masteryScore),
      totalReviews: Value(totalReviews),
      correctQuizAnswers: Value(correctQuizAnswers),
      totalQuizAnswers: Value(totalQuizAnswers),
    );
  }

  factory DomainProgressTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DomainProgressTableData(
      domain: serializer.fromJson<String>(json['domain']),
      masteryScore: serializer.fromJson<double>(json['masteryScore']),
      totalReviews: serializer.fromJson<int>(json['totalReviews']),
      correctQuizAnswers: serializer.fromJson<int>(json['correctQuizAnswers']),
      totalQuizAnswers: serializer.fromJson<int>(json['totalQuizAnswers']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'domain': serializer.toJson<String>(domain),
      'masteryScore': serializer.toJson<double>(masteryScore),
      'totalReviews': serializer.toJson<int>(totalReviews),
      'correctQuizAnswers': serializer.toJson<int>(correctQuizAnswers),
      'totalQuizAnswers': serializer.toJson<int>(totalQuizAnswers),
    };
  }

  DomainProgressTableData copyWith({
    String? domain,
    double? masteryScore,
    int? totalReviews,
    int? correctQuizAnswers,
    int? totalQuizAnswers,
  }) => DomainProgressTableData(
    domain: domain ?? this.domain,
    masteryScore: masteryScore ?? this.masteryScore,
    totalReviews: totalReviews ?? this.totalReviews,
    correctQuizAnswers: correctQuizAnswers ?? this.correctQuizAnswers,
    totalQuizAnswers: totalQuizAnswers ?? this.totalQuizAnswers,
  );
  DomainProgressTableData copyWithCompanion(DomainProgressTableCompanion data) {
    return DomainProgressTableData(
      domain: data.domain.present ? data.domain.value : this.domain,
      masteryScore: data.masteryScore.present
          ? data.masteryScore.value
          : this.masteryScore,
      totalReviews: data.totalReviews.present
          ? data.totalReviews.value
          : this.totalReviews,
      correctQuizAnswers: data.correctQuizAnswers.present
          ? data.correctQuizAnswers.value
          : this.correctQuizAnswers,
      totalQuizAnswers: data.totalQuizAnswers.present
          ? data.totalQuizAnswers.value
          : this.totalQuizAnswers,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DomainProgressTableData(')
          ..write('domain: $domain, ')
          ..write('masteryScore: $masteryScore, ')
          ..write('totalReviews: $totalReviews, ')
          ..write('correctQuizAnswers: $correctQuizAnswers, ')
          ..write('totalQuizAnswers: $totalQuizAnswers')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    domain,
    masteryScore,
    totalReviews,
    correctQuizAnswers,
    totalQuizAnswers,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DomainProgressTableData &&
          other.domain == this.domain &&
          other.masteryScore == this.masteryScore &&
          other.totalReviews == this.totalReviews &&
          other.correctQuizAnswers == this.correctQuizAnswers &&
          other.totalQuizAnswers == this.totalQuizAnswers);
}

class DomainProgressTableCompanion
    extends UpdateCompanion<DomainProgressTableData> {
  final Value<String> domain;
  final Value<double> masteryScore;
  final Value<int> totalReviews;
  final Value<int> correctQuizAnswers;
  final Value<int> totalQuizAnswers;
  final Value<int> rowid;
  const DomainProgressTableCompanion({
    this.domain = const Value.absent(),
    this.masteryScore = const Value.absent(),
    this.totalReviews = const Value.absent(),
    this.correctQuizAnswers = const Value.absent(),
    this.totalQuizAnswers = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DomainProgressTableCompanion.insert({
    required String domain,
    this.masteryScore = const Value.absent(),
    this.totalReviews = const Value.absent(),
    this.correctQuizAnswers = const Value.absent(),
    this.totalQuizAnswers = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : domain = Value(domain);
  static Insertable<DomainProgressTableData> custom({
    Expression<String>? domain,
    Expression<double>? masteryScore,
    Expression<int>? totalReviews,
    Expression<int>? correctQuizAnswers,
    Expression<int>? totalQuizAnswers,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (domain != null) 'domain': domain,
      if (masteryScore != null) 'mastery_score': masteryScore,
      if (totalReviews != null) 'total_reviews': totalReviews,
      if (correctQuizAnswers != null)
        'correct_quiz_answers': correctQuizAnswers,
      if (totalQuizAnswers != null) 'total_quiz_answers': totalQuizAnswers,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DomainProgressTableCompanion copyWith({
    Value<String>? domain,
    Value<double>? masteryScore,
    Value<int>? totalReviews,
    Value<int>? correctQuizAnswers,
    Value<int>? totalQuizAnswers,
    Value<int>? rowid,
  }) {
    return DomainProgressTableCompanion(
      domain: domain ?? this.domain,
      masteryScore: masteryScore ?? this.masteryScore,
      totalReviews: totalReviews ?? this.totalReviews,
      correctQuizAnswers: correctQuizAnswers ?? this.correctQuizAnswers,
      totalQuizAnswers: totalQuizAnswers ?? this.totalQuizAnswers,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (domain.present) {
      map['domain'] = Variable<String>(domain.value);
    }
    if (masteryScore.present) {
      map['mastery_score'] = Variable<double>(masteryScore.value);
    }
    if (totalReviews.present) {
      map['total_reviews'] = Variable<int>(totalReviews.value);
    }
    if (correctQuizAnswers.present) {
      map['correct_quiz_answers'] = Variable<int>(correctQuizAnswers.value);
    }
    if (totalQuizAnswers.present) {
      map['total_quiz_answers'] = Variable<int>(totalQuizAnswers.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DomainProgressTableCompanion(')
          ..write('domain: $domain, ')
          ..write('masteryScore: $masteryScore, ')
          ..write('totalReviews: $totalReviews, ')
          ..write('correctQuizAnswers: $correctQuizAnswers, ')
          ..write('totalQuizAnswers: $totalQuizAnswers, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionLogsTable extends SessionLogs
    with TableInfo<$SessionLogsTable, SessionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardsReviewedMeta = const VerificationMeta(
    'cardsReviewed',
  );
  @override
  late final GeneratedColumn<int> cardsReviewed = GeneratedColumn<int>(
    'cards_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizCorrectMeta = const VerificationMeta(
    'quizCorrect',
  );
  @override
  late final GeneratedColumn<int> quizCorrect = GeneratedColumn<int>(
    'quiz_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizTotalMeta = const VerificationMeta(
    'quizTotal',
  );
  @override
  late final GeneratedColumn<int> quizTotal = GeneratedColumn<int>(
    'quiz_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _averageQualityMeta = const VerificationMeta(
    'averageQuality',
  );
  @override
  late final GeneratedColumn<double> averageQuality = GeneratedColumn<double>(
    'average_quality',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    cardsReviewed,
    quizCorrect,
    quizTotal,
    durationMinutes,
    averageQuality,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('cards_reviewed')) {
      context.handle(
        _cardsReviewedMeta,
        cardsReviewed.isAcceptableOrUnknown(
          data['cards_reviewed']!,
          _cardsReviewedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cardsReviewedMeta);
    }
    if (data.containsKey('quiz_correct')) {
      context.handle(
        _quizCorrectMeta,
        quizCorrect.isAcceptableOrUnknown(
          data['quiz_correct']!,
          _quizCorrectMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quizCorrectMeta);
    }
    if (data.containsKey('quiz_total')) {
      context.handle(
        _quizTotalMeta,
        quizTotal.isAcceptableOrUnknown(data['quiz_total']!, _quizTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_quizTotalMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('average_quality')) {
      context.handle(
        _averageQualityMeta,
        averageQuality.isAcceptableOrUnknown(
          data['average_quality']!,
          _averageQualityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_averageQualityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      cardsReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cards_reviewed'],
      )!,
      quizCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiz_correct'],
      )!,
      quizTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiz_total'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      averageQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_quality'],
      )!,
    );
  }

  @override
  $SessionLogsTable createAlias(String alias) {
    return $SessionLogsTable(attachedDatabase, alias);
  }
}

class SessionLog extends DataClass implements Insertable<SessionLog> {
  final int id;
  final DateTime date;
  final int cardsReviewed;
  final int quizCorrect;
  final int quizTotal;
  final int durationMinutes;
  final double averageQuality;
  const SessionLog({
    required this.id,
    required this.date,
    required this.cardsReviewed,
    required this.quizCorrect,
    required this.quizTotal,
    required this.durationMinutes,
    required this.averageQuality,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['cards_reviewed'] = Variable<int>(cardsReviewed);
    map['quiz_correct'] = Variable<int>(quizCorrect);
    map['quiz_total'] = Variable<int>(quizTotal);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['average_quality'] = Variable<double>(averageQuality);
    return map;
  }

  SessionLogsCompanion toCompanion(bool nullToAbsent) {
    return SessionLogsCompanion(
      id: Value(id),
      date: Value(date),
      cardsReviewed: Value(cardsReviewed),
      quizCorrect: Value(quizCorrect),
      quizTotal: Value(quizTotal),
      durationMinutes: Value(durationMinutes),
      averageQuality: Value(averageQuality),
    );
  }

  factory SessionLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      cardsReviewed: serializer.fromJson<int>(json['cardsReviewed']),
      quizCorrect: serializer.fromJson<int>(json['quizCorrect']),
      quizTotal: serializer.fromJson<int>(json['quizTotal']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      averageQuality: serializer.fromJson<double>(json['averageQuality']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'cardsReviewed': serializer.toJson<int>(cardsReviewed),
      'quizCorrect': serializer.toJson<int>(quizCorrect),
      'quizTotal': serializer.toJson<int>(quizTotal),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'averageQuality': serializer.toJson<double>(averageQuality),
    };
  }

  SessionLog copyWith({
    int? id,
    DateTime? date,
    int? cardsReviewed,
    int? quizCorrect,
    int? quizTotal,
    int? durationMinutes,
    double? averageQuality,
  }) => SessionLog(
    id: id ?? this.id,
    date: date ?? this.date,
    cardsReviewed: cardsReviewed ?? this.cardsReviewed,
    quizCorrect: quizCorrect ?? this.quizCorrect,
    quizTotal: quizTotal ?? this.quizTotal,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    averageQuality: averageQuality ?? this.averageQuality,
  );
  SessionLog copyWithCompanion(SessionLogsCompanion data) {
    return SessionLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      cardsReviewed: data.cardsReviewed.present
          ? data.cardsReviewed.value
          : this.cardsReviewed,
      quizCorrect: data.quizCorrect.present
          ? data.quizCorrect.value
          : this.quizCorrect,
      quizTotal: data.quizTotal.present ? data.quizTotal.value : this.quizTotal,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      averageQuality: data.averageQuality.present
          ? data.averageQuality.value
          : this.averageQuality,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('cardsReviewed: $cardsReviewed, ')
          ..write('quizCorrect: $quizCorrect, ')
          ..write('quizTotal: $quizTotal, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('averageQuality: $averageQuality')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    cardsReviewed,
    quizCorrect,
    quizTotal,
    durationMinutes,
    averageQuality,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.cardsReviewed == this.cardsReviewed &&
          other.quizCorrect == this.quizCorrect &&
          other.quizTotal == this.quizTotal &&
          other.durationMinutes == this.durationMinutes &&
          other.averageQuality == this.averageQuality);
}

class SessionLogsCompanion extends UpdateCompanion<SessionLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> cardsReviewed;
  final Value<int> quizCorrect;
  final Value<int> quizTotal;
  final Value<int> durationMinutes;
  final Value<double> averageQuality;
  const SessionLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.cardsReviewed = const Value.absent(),
    this.quizCorrect = const Value.absent(),
    this.quizTotal = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.averageQuality = const Value.absent(),
  });
  SessionLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int cardsReviewed,
    required int quizCorrect,
    required int quizTotal,
    required int durationMinutes,
    required double averageQuality,
  }) : date = Value(date),
       cardsReviewed = Value(cardsReviewed),
       quizCorrect = Value(quizCorrect),
       quizTotal = Value(quizTotal),
       durationMinutes = Value(durationMinutes),
       averageQuality = Value(averageQuality);
  static Insertable<SessionLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? cardsReviewed,
    Expression<int>? quizCorrect,
    Expression<int>? quizTotal,
    Expression<int>? durationMinutes,
    Expression<double>? averageQuality,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (cardsReviewed != null) 'cards_reviewed': cardsReviewed,
      if (quizCorrect != null) 'quiz_correct': quizCorrect,
      if (quizTotal != null) 'quiz_total': quizTotal,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (averageQuality != null) 'average_quality': averageQuality,
    });
  }

  SessionLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? cardsReviewed,
    Value<int>? quizCorrect,
    Value<int>? quizTotal,
    Value<int>? durationMinutes,
    Value<double>? averageQuality,
  }) {
    return SessionLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      cardsReviewed: cardsReviewed ?? this.cardsReviewed,
      quizCorrect: quizCorrect ?? this.quizCorrect,
      quizTotal: quizTotal ?? this.quizTotal,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      averageQuality: averageQuality ?? this.averageQuality,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (cardsReviewed.present) {
      map['cards_reviewed'] = Variable<int>(cardsReviewed.value);
    }
    if (quizCorrect.present) {
      map['quiz_correct'] = Variable<int>(quizCorrect.value);
    }
    if (quizTotal.present) {
      map['quiz_total'] = Variable<int>(quizTotal.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (averageQuality.present) {
      map['average_quality'] = Variable<double>(averageQuality.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('cardsReviewed: $cardsReviewed, ')
          ..write('quizCorrect: $quizCorrect, ')
          ..write('quizTotal: $quizTotal, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('averageQuality: $averageQuality')
          ..write(')'))
        .toString();
  }
}

class $UserStatsTableTable extends UserStatsTable
    with TableInfo<$UserStatsTableTable, UserStatsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStatsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSessionDateMeta = const VerificationMeta(
    'lastSessionDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastSessionDate =
      GeneratedColumn<DateTime>(
        'last_session_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _totalSessionsMeta = const VerificationMeta(
    'totalSessions',
  );
  @override
  late final GeneratedColumn<int> totalSessions = GeneratedColumn<int>(
    'total_sessions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalReviewsMeta = const VerificationMeta(
    'totalReviews',
  );
  @override
  late final GeneratedColumn<int> totalReviews = GeneratedColumn<int>(
    'total_reviews',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currentStreak,
    longestStreak,
    lastSessionDate,
    totalSessions,
    totalReviews,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserStatsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('last_session_date')) {
      context.handle(
        _lastSessionDateMeta,
        lastSessionDate.isAcceptableOrUnknown(
          data['last_session_date']!,
          _lastSessionDateMeta,
        ),
      );
    }
    if (data.containsKey('total_sessions')) {
      context.handle(
        _totalSessionsMeta,
        totalSessions.isAcceptableOrUnknown(
          data['total_sessions']!,
          _totalSessionsMeta,
        ),
      );
    }
    if (data.containsKey('total_reviews')) {
      context.handle(
        _totalReviewsMeta,
        totalReviews.isAcceptableOrUnknown(
          data['total_reviews']!,
          _totalReviewsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStatsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStatsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      lastSessionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_session_date'],
      ),
      totalSessions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_sessions'],
      )!,
      totalReviews: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_reviews'],
      )!,
    );
  }

  @override
  $UserStatsTableTable createAlias(String alias) {
    return $UserStatsTableTable(attachedDatabase, alias);
  }
}

class UserStatsTableData extends DataClass
    implements Insertable<UserStatsTableData> {
  final int id;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastSessionDate;
  final int totalSessions;
  final int totalReviews;
  const UserStatsTableData({
    required this.id,
    required this.currentStreak,
    required this.longestStreak,
    this.lastSessionDate,
    required this.totalSessions,
    required this.totalReviews,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    if (!nullToAbsent || lastSessionDate != null) {
      map['last_session_date'] = Variable<DateTime>(lastSessionDate);
    }
    map['total_sessions'] = Variable<int>(totalSessions);
    map['total_reviews'] = Variable<int>(totalReviews);
    return map;
  }

  UserStatsTableCompanion toCompanion(bool nullToAbsent) {
    return UserStatsTableCompanion(
      id: Value(id),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastSessionDate: lastSessionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSessionDate),
      totalSessions: Value(totalSessions),
      totalReviews: Value(totalReviews),
    );
  }

  factory UserStatsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStatsTableData(
      id: serializer.fromJson<int>(json['id']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastSessionDate: serializer.fromJson<DateTime?>(json['lastSessionDate']),
      totalSessions: serializer.fromJson<int>(json['totalSessions']),
      totalReviews: serializer.fromJson<int>(json['totalReviews']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastSessionDate': serializer.toJson<DateTime?>(lastSessionDate),
      'totalSessions': serializer.toJson<int>(totalSessions),
      'totalReviews': serializer.toJson<int>(totalReviews),
    };
  }

  UserStatsTableData copyWith({
    int? id,
    int? currentStreak,
    int? longestStreak,
    Value<DateTime?> lastSessionDate = const Value.absent(),
    int? totalSessions,
    int? totalReviews,
  }) => UserStatsTableData(
    id: id ?? this.id,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    lastSessionDate: lastSessionDate.present
        ? lastSessionDate.value
        : this.lastSessionDate,
    totalSessions: totalSessions ?? this.totalSessions,
    totalReviews: totalReviews ?? this.totalReviews,
  );
  UserStatsTableData copyWithCompanion(UserStatsTableCompanion data) {
    return UserStatsTableData(
      id: data.id.present ? data.id.value : this.id,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      lastSessionDate: data.lastSessionDate.present
          ? data.lastSessionDate.value
          : this.lastSessionDate,
      totalSessions: data.totalSessions.present
          ? data.totalSessions.value
          : this.totalSessions,
      totalReviews: data.totalReviews.present
          ? data.totalReviews.value
          : this.totalReviews,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsTableData(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastSessionDate: $lastSessionDate, ')
          ..write('totalSessions: $totalSessions, ')
          ..write('totalReviews: $totalReviews')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    currentStreak,
    longestStreak,
    lastSessionDate,
    totalSessions,
    totalReviews,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStatsTableData &&
          other.id == this.id &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastSessionDate == this.lastSessionDate &&
          other.totalSessions == this.totalSessions &&
          other.totalReviews == this.totalReviews);
}

class UserStatsTableCompanion extends UpdateCompanion<UserStatsTableData> {
  final Value<int> id;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<DateTime?> lastSessionDate;
  final Value<int> totalSessions;
  final Value<int> totalReviews;
  const UserStatsTableCompanion({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastSessionDate = const Value.absent(),
    this.totalSessions = const Value.absent(),
    this.totalReviews = const Value.absent(),
  });
  UserStatsTableCompanion.insert({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastSessionDate = const Value.absent(),
    this.totalSessions = const Value.absent(),
    this.totalReviews = const Value.absent(),
  });
  static Insertable<UserStatsTableData> custom({
    Expression<int>? id,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<DateTime>? lastSessionDate,
    Expression<int>? totalSessions,
    Expression<int>? totalReviews,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastSessionDate != null) 'last_session_date': lastSessionDate,
      if (totalSessions != null) 'total_sessions': totalSessions,
      if (totalReviews != null) 'total_reviews': totalReviews,
    });
  }

  UserStatsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? currentStreak,
    Value<int>? longestStreak,
    Value<DateTime?>? lastSessionDate,
    Value<int>? totalSessions,
    Value<int>? totalReviews,
  }) {
    return UserStatsTableCompanion(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      totalSessions: totalSessions ?? this.totalSessions,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastSessionDate.present) {
      map['last_session_date'] = Variable<DateTime>(lastSessionDate.value);
    }
    if (totalSessions.present) {
      map['total_sessions'] = Variable<int>(totalSessions.value);
    }
    if (totalReviews.present) {
      map['total_reviews'] = Variable<int>(totalReviews.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsTableCompanion(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastSessionDate: $lastSessionDate, ')
          ..write('totalSessions: $totalSessions, ')
          ..write('totalReviews: $totalReviews')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConceptsTable concepts = $ConceptsTable(this);
  late final $ReviewCardsTable reviewCards = $ReviewCardsTable(this);
  late final $ConfidenceLogsTable confidenceLogs = $ConfidenceLogsTable(this);
  late final $QuizQuestionsTable quizQuestions = $QuizQuestionsTable(this);
  late final $QuizAttemptsTable quizAttempts = $QuizAttemptsTable(this);
  late final $DomainProgressTableTable domainProgressTable =
      $DomainProgressTableTable(this);
  late final $SessionLogsTable sessionLogs = $SessionLogsTable(this);
  late final $UserStatsTableTable userStatsTable = $UserStatsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    concepts,
    reviewCards,
    confidenceLogs,
    quizQuestions,
    quizAttempts,
    domainProgressTable,
    sessionLogs,
    userStatsTable,
  ];
}

typedef $$ConceptsTableCreateCompanionBuilder =
    ConceptsCompanion Function({
      required String id,
      required String title,
      required String definition,
      required String intuition,
      required String practicalExample,
      required String failureMode,
      required String interviewAnswer,
      required String tags,
      required int difficulty,
      required int importance,
      required String relatedConceptIds,
      Value<int> rowid,
    });
typedef $$ConceptsTableUpdateCompanionBuilder =
    ConceptsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> definition,
      Value<String> intuition,
      Value<String> practicalExample,
      Value<String> failureMode,
      Value<String> interviewAnswer,
      Value<String> tags,
      Value<int> difficulty,
      Value<int> importance,
      Value<String> relatedConceptIds,
      Value<int> rowid,
    });

class $$ConceptsTableFilterComposer
    extends Composer<_$AppDatabase, $ConceptsTable> {
  $$ConceptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intuition => $composableBuilder(
    column: $table.intuition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get practicalExample => $composableBuilder(
    column: $table.practicalExample,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failureMode => $composableBuilder(
    column: $table.failureMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interviewAnswer => $composableBuilder(
    column: $table.interviewAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedConceptIds => $composableBuilder(
    column: $table.relatedConceptIds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConceptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConceptsTable> {
  $$ConceptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intuition => $composableBuilder(
    column: $table.intuition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get practicalExample => $composableBuilder(
    column: $table.practicalExample,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failureMode => $composableBuilder(
    column: $table.failureMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interviewAnswer => $composableBuilder(
    column: $table.interviewAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedConceptIds => $composableBuilder(
    column: $table.relatedConceptIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConceptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConceptsTable> {
  $$ConceptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get intuition =>
      $composableBuilder(column: $table.intuition, builder: (column) => column);

  GeneratedColumn<String> get practicalExample => $composableBuilder(
    column: $table.practicalExample,
    builder: (column) => column,
  );

  GeneratedColumn<String> get failureMode => $composableBuilder(
    column: $table.failureMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get interviewAnswer => $composableBuilder(
    column: $table.interviewAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relatedConceptIds => $composableBuilder(
    column: $table.relatedConceptIds,
    builder: (column) => column,
  );
}

class $$ConceptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConceptsTable,
          Concept,
          $$ConceptsTableFilterComposer,
          $$ConceptsTableOrderingComposer,
          $$ConceptsTableAnnotationComposer,
          $$ConceptsTableCreateCompanionBuilder,
          $$ConceptsTableUpdateCompanionBuilder,
          (Concept, BaseReferences<_$AppDatabase, $ConceptsTable, Concept>),
          Concept,
          PrefetchHooks Function()
        > {
  $$ConceptsTableTableManager(_$AppDatabase db, $ConceptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConceptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConceptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConceptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> definition = const Value.absent(),
                Value<String> intuition = const Value.absent(),
                Value<String> practicalExample = const Value.absent(),
                Value<String> failureMode = const Value.absent(),
                Value<String> interviewAnswer = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<int> importance = const Value.absent(),
                Value<String> relatedConceptIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConceptsCompanion(
                id: id,
                title: title,
                definition: definition,
                intuition: intuition,
                practicalExample: practicalExample,
                failureMode: failureMode,
                interviewAnswer: interviewAnswer,
                tags: tags,
                difficulty: difficulty,
                importance: importance,
                relatedConceptIds: relatedConceptIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String definition,
                required String intuition,
                required String practicalExample,
                required String failureMode,
                required String interviewAnswer,
                required String tags,
                required int difficulty,
                required int importance,
                required String relatedConceptIds,
                Value<int> rowid = const Value.absent(),
              }) => ConceptsCompanion.insert(
                id: id,
                title: title,
                definition: definition,
                intuition: intuition,
                practicalExample: practicalExample,
                failureMode: failureMode,
                interviewAnswer: interviewAnswer,
                tags: tags,
                difficulty: difficulty,
                importance: importance,
                relatedConceptIds: relatedConceptIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConceptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConceptsTable,
      Concept,
      $$ConceptsTableFilterComposer,
      $$ConceptsTableOrderingComposer,
      $$ConceptsTableAnnotationComposer,
      $$ConceptsTableCreateCompanionBuilder,
      $$ConceptsTableUpdateCompanionBuilder,
      (Concept, BaseReferences<_$AppDatabase, $ConceptsTable, Concept>),
      Concept,
      PrefetchHooks Function()
    >;
typedef $$ReviewCardsTableCreateCompanionBuilder =
    ReviewCardsCompanion Function({
      Value<int> id,
      required String conceptId,
      Value<double> easeFactor,
      Value<int> interval,
      required DateTime nextReviewDate,
      Value<int> repetitions,
      Value<int> lastQuality,
    });
typedef $$ReviewCardsTableUpdateCompanionBuilder =
    ReviewCardsCompanion Function({
      Value<int> id,
      Value<String> conceptId,
      Value<double> easeFactor,
      Value<int> interval,
      Value<DateTime> nextReviewDate,
      Value<int> repetitions,
      Value<int> lastQuality,
    });

class $$ReviewCardsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewCardsTable> {
  $$ReviewCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conceptId => $composableBuilder(
    column: $table.conceptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastQuality => $composableBuilder(
    column: $table.lastQuality,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewCardsTable> {
  $$ReviewCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conceptId => $composableBuilder(
    column: $table.conceptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastQuality => $composableBuilder(
    column: $table.lastQuality,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewCardsTable> {
  $$ReviewCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conceptId =>
      $composableBuilder(column: $table.conceptId, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastQuality => $composableBuilder(
    column: $table.lastQuality,
    builder: (column) => column,
  );
}

class $$ReviewCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewCardsTable,
          ReviewCard,
          $$ReviewCardsTableFilterComposer,
          $$ReviewCardsTableOrderingComposer,
          $$ReviewCardsTableAnnotationComposer,
          $$ReviewCardsTableCreateCompanionBuilder,
          $$ReviewCardsTableUpdateCompanionBuilder,
          (
            ReviewCard,
            BaseReferences<_$AppDatabase, $ReviewCardsTable, ReviewCard>,
          ),
          ReviewCard,
          PrefetchHooks Function()
        > {
  $$ReviewCardsTableTableManager(_$AppDatabase db, $ReviewCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> conceptId = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<DateTime> nextReviewDate = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lastQuality = const Value.absent(),
              }) => ReviewCardsCompanion(
                id: id,
                conceptId: conceptId,
                easeFactor: easeFactor,
                interval: interval,
                nextReviewDate: nextReviewDate,
                repetitions: repetitions,
                lastQuality: lastQuality,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String conceptId,
                Value<double> easeFactor = const Value.absent(),
                Value<int> interval = const Value.absent(),
                required DateTime nextReviewDate,
                Value<int> repetitions = const Value.absent(),
                Value<int> lastQuality = const Value.absent(),
              }) => ReviewCardsCompanion.insert(
                id: id,
                conceptId: conceptId,
                easeFactor: easeFactor,
                interval: interval,
                nextReviewDate: nextReviewDate,
                repetitions: repetitions,
                lastQuality: lastQuality,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewCardsTable,
      ReviewCard,
      $$ReviewCardsTableFilterComposer,
      $$ReviewCardsTableOrderingComposer,
      $$ReviewCardsTableAnnotationComposer,
      $$ReviewCardsTableCreateCompanionBuilder,
      $$ReviewCardsTableUpdateCompanionBuilder,
      (
        ReviewCard,
        BaseReferences<_$AppDatabase, $ReviewCardsTable, ReviewCard>,
      ),
      ReviewCard,
      PrefetchHooks Function()
    >;
typedef $$ConfidenceLogsTableCreateCompanionBuilder =
    ConfidenceLogsCompanion Function({
      Value<int> id,
      required String conceptId,
      required int confidence,
      required int quality,
      required DateTime timestamp,
    });
typedef $$ConfidenceLogsTableUpdateCompanionBuilder =
    ConfidenceLogsCompanion Function({
      Value<int> id,
      Value<String> conceptId,
      Value<int> confidence,
      Value<int> quality,
      Value<DateTime> timestamp,
    });

class $$ConfidenceLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ConfidenceLogsTable> {
  $$ConfidenceLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conceptId => $composableBuilder(
    column: $table.conceptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfidenceLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfidenceLogsTable> {
  $$ConfidenceLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conceptId => $composableBuilder(
    column: $table.conceptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfidenceLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfidenceLogsTable> {
  $$ConfidenceLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conceptId =>
      $composableBuilder(column: $table.conceptId, builder: (column) => column);

  GeneratedColumn<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ConfidenceLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfidenceLogsTable,
          ConfidenceLog,
          $$ConfidenceLogsTableFilterComposer,
          $$ConfidenceLogsTableOrderingComposer,
          $$ConfidenceLogsTableAnnotationComposer,
          $$ConfidenceLogsTableCreateCompanionBuilder,
          $$ConfidenceLogsTableUpdateCompanionBuilder,
          (
            ConfidenceLog,
            BaseReferences<_$AppDatabase, $ConfidenceLogsTable, ConfidenceLog>,
          ),
          ConfidenceLog,
          PrefetchHooks Function()
        > {
  $$ConfidenceLogsTableTableManager(
    _$AppDatabase db,
    $ConfidenceLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfidenceLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfidenceLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfidenceLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> conceptId = const Value.absent(),
                Value<int> confidence = const Value.absent(),
                Value<int> quality = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ConfidenceLogsCompanion(
                id: id,
                conceptId: conceptId,
                confidence: confidence,
                quality: quality,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String conceptId,
                required int confidence,
                required int quality,
                required DateTime timestamp,
              }) => ConfidenceLogsCompanion.insert(
                id: id,
                conceptId: conceptId,
                confidence: confidence,
                quality: quality,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfidenceLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfidenceLogsTable,
      ConfidenceLog,
      $$ConfidenceLogsTableFilterComposer,
      $$ConfidenceLogsTableOrderingComposer,
      $$ConfidenceLogsTableAnnotationComposer,
      $$ConfidenceLogsTableCreateCompanionBuilder,
      $$ConfidenceLogsTableUpdateCompanionBuilder,
      (
        ConfidenceLog,
        BaseReferences<_$AppDatabase, $ConfidenceLogsTable, ConfidenceLog>,
      ),
      ConfidenceLog,
      PrefetchHooks Function()
    >;
typedef $$QuizQuestionsTableCreateCompanionBuilder =
    QuizQuestionsCompanion Function({
      required String id,
      required String question,
      required String options,
      required int correctAnswer,
      required String explanation,
      required String conceptIds,
      required int difficulty,
      required String tags,
      Value<int> rowid,
    });
typedef $$QuizQuestionsTableUpdateCompanionBuilder =
    QuizQuestionsCompanion Function({
      Value<String> id,
      Value<String> question,
      Value<String> options,
      Value<int> correctAnswer,
      Value<String> explanation,
      Value<String> conceptIds,
      Value<int> difficulty,
      Value<String> tags,
      Value<int> rowid,
    });

class $$QuizQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conceptIds => $composableBuilder(
    column: $table.conceptIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conceptIds => $composableBuilder(
    column: $table.conceptIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<int> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conceptIds => $composableBuilder(
    column: $table.conceptIds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);
}

class $$QuizQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizQuestionsTable,
          QuizQuestion,
          $$QuizQuestionsTableFilterComposer,
          $$QuizQuestionsTableOrderingComposer,
          $$QuizQuestionsTableAnnotationComposer,
          $$QuizQuestionsTableCreateCompanionBuilder,
          $$QuizQuestionsTableUpdateCompanionBuilder,
          (
            QuizQuestion,
            BaseReferences<_$AppDatabase, $QuizQuestionsTable, QuizQuestion>,
          ),
          QuizQuestion,
          PrefetchHooks Function()
        > {
  $$QuizQuestionsTableTableManager(_$AppDatabase db, $QuizQuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<String> options = const Value.absent(),
                Value<int> correctAnswer = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<String> conceptIds = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsCompanion(
                id: id,
                question: question,
                options: options,
                correctAnswer: correctAnswer,
                explanation: explanation,
                conceptIds: conceptIds,
                difficulty: difficulty,
                tags: tags,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String question,
                required String options,
                required int correctAnswer,
                required String explanation,
                required String conceptIds,
                required int difficulty,
                required String tags,
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsCompanion.insert(
                id: id,
                question: question,
                options: options,
                correctAnswer: correctAnswer,
                explanation: explanation,
                conceptIds: conceptIds,
                difficulty: difficulty,
                tags: tags,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizQuestionsTable,
      QuizQuestion,
      $$QuizQuestionsTableFilterComposer,
      $$QuizQuestionsTableOrderingComposer,
      $$QuizQuestionsTableAnnotationComposer,
      $$QuizQuestionsTableCreateCompanionBuilder,
      $$QuizQuestionsTableUpdateCompanionBuilder,
      (
        QuizQuestion,
        BaseReferences<_$AppDatabase, $QuizQuestionsTable, QuizQuestion>,
      ),
      QuizQuestion,
      PrefetchHooks Function()
    >;
typedef $$QuizAttemptsTableCreateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<int> id,
      required String questionId,
      required int selectedAnswer,
      required bool correct,
      required DateTime timestamp,
    });
typedef $$QuizAttemptsTableUpdateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<int> id,
      Value<String> questionId,
      Value<int> selectedAnswer,
      Value<bool> correct,
      Value<DateTime> timestamp,
    });

class $$QuizAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$QuizAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAttemptsTable,
          QuizAttempt,
          $$QuizAttemptsTableFilterComposer,
          $$QuizAttemptsTableOrderingComposer,
          $$QuizAttemptsTableAnnotationComposer,
          $$QuizAttemptsTableCreateCompanionBuilder,
          $$QuizAttemptsTableUpdateCompanionBuilder,
          (
            QuizAttempt,
            BaseReferences<_$AppDatabase, $QuizAttemptsTable, QuizAttempt>,
          ),
          QuizAttempt,
          PrefetchHooks Function()
        > {
  $$QuizAttemptsTableTableManager(_$AppDatabase db, $QuizAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<int> selectedAnswer = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => QuizAttemptsCompanion(
                id: id,
                questionId: questionId,
                selectedAnswer: selectedAnswer,
                correct: correct,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String questionId,
                required int selectedAnswer,
                required bool correct,
                required DateTime timestamp,
              }) => QuizAttemptsCompanion.insert(
                id: id,
                questionId: questionId,
                selectedAnswer: selectedAnswer,
                correct: correct,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAttemptsTable,
      QuizAttempt,
      $$QuizAttemptsTableFilterComposer,
      $$QuizAttemptsTableOrderingComposer,
      $$QuizAttemptsTableAnnotationComposer,
      $$QuizAttemptsTableCreateCompanionBuilder,
      $$QuizAttemptsTableUpdateCompanionBuilder,
      (
        QuizAttempt,
        BaseReferences<_$AppDatabase, $QuizAttemptsTable, QuizAttempt>,
      ),
      QuizAttempt,
      PrefetchHooks Function()
    >;
typedef $$DomainProgressTableTableCreateCompanionBuilder =
    DomainProgressTableCompanion Function({
      required String domain,
      Value<double> masteryScore,
      Value<int> totalReviews,
      Value<int> correctQuizAnswers,
      Value<int> totalQuizAnswers,
      Value<int> rowid,
    });
typedef $$DomainProgressTableTableUpdateCompanionBuilder =
    DomainProgressTableCompanion Function({
      Value<String> domain,
      Value<double> masteryScore,
      Value<int> totalReviews,
      Value<int> correctQuizAnswers,
      Value<int> totalQuizAnswers,
      Value<int> rowid,
    });

class $$DomainProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $DomainProgressTableTable> {
  $$DomainProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get masteryScore => $composableBuilder(
    column: $table.masteryScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctQuizAnswers => $composableBuilder(
    column: $table.correctQuizAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuizAnswers => $composableBuilder(
    column: $table.totalQuizAnswers,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DomainProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DomainProgressTableTable> {
  $$DomainProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get masteryScore => $composableBuilder(
    column: $table.masteryScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctQuizAnswers => $composableBuilder(
    column: $table.correctQuizAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuizAnswers => $composableBuilder(
    column: $table.totalQuizAnswers,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DomainProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DomainProgressTableTable> {
  $$DomainProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get domain =>
      $composableBuilder(column: $table.domain, builder: (column) => column);

  GeneratedColumn<double> get masteryScore => $composableBuilder(
    column: $table.masteryScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctQuizAnswers => $composableBuilder(
    column: $table.correctQuizAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuizAnswers => $composableBuilder(
    column: $table.totalQuizAnswers,
    builder: (column) => column,
  );
}

class $$DomainProgressTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DomainProgressTableTable,
          DomainProgressTableData,
          $$DomainProgressTableTableFilterComposer,
          $$DomainProgressTableTableOrderingComposer,
          $$DomainProgressTableTableAnnotationComposer,
          $$DomainProgressTableTableCreateCompanionBuilder,
          $$DomainProgressTableTableUpdateCompanionBuilder,
          (
            DomainProgressTableData,
            BaseReferences<
              _$AppDatabase,
              $DomainProgressTableTable,
              DomainProgressTableData
            >,
          ),
          DomainProgressTableData,
          PrefetchHooks Function()
        > {
  $$DomainProgressTableTableTableManager(
    _$AppDatabase db,
    $DomainProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DomainProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DomainProgressTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DomainProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> domain = const Value.absent(),
                Value<double> masteryScore = const Value.absent(),
                Value<int> totalReviews = const Value.absent(),
                Value<int> correctQuizAnswers = const Value.absent(),
                Value<int> totalQuizAnswers = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DomainProgressTableCompanion(
                domain: domain,
                masteryScore: masteryScore,
                totalReviews: totalReviews,
                correctQuizAnswers: correctQuizAnswers,
                totalQuizAnswers: totalQuizAnswers,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String domain,
                Value<double> masteryScore = const Value.absent(),
                Value<int> totalReviews = const Value.absent(),
                Value<int> correctQuizAnswers = const Value.absent(),
                Value<int> totalQuizAnswers = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DomainProgressTableCompanion.insert(
                domain: domain,
                masteryScore: masteryScore,
                totalReviews: totalReviews,
                correctQuizAnswers: correctQuizAnswers,
                totalQuizAnswers: totalQuizAnswers,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DomainProgressTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DomainProgressTableTable,
      DomainProgressTableData,
      $$DomainProgressTableTableFilterComposer,
      $$DomainProgressTableTableOrderingComposer,
      $$DomainProgressTableTableAnnotationComposer,
      $$DomainProgressTableTableCreateCompanionBuilder,
      $$DomainProgressTableTableUpdateCompanionBuilder,
      (
        DomainProgressTableData,
        BaseReferences<
          _$AppDatabase,
          $DomainProgressTableTable,
          DomainProgressTableData
        >,
      ),
      DomainProgressTableData,
      PrefetchHooks Function()
    >;
typedef $$SessionLogsTableCreateCompanionBuilder =
    SessionLogsCompanion Function({
      Value<int> id,
      required DateTime date,
      required int cardsReviewed,
      required int quizCorrect,
      required int quizTotal,
      required int durationMinutes,
      required double averageQuality,
    });
typedef $$SessionLogsTableUpdateCompanionBuilder =
    SessionLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> cardsReviewed,
      Value<int> quizCorrect,
      Value<int> quizTotal,
      Value<int> durationMinutes,
      Value<double> averageQuality,
    });

class $$SessionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionLogsTable> {
  $$SessionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardsReviewed => $composableBuilder(
    column: $table.cardsReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quizCorrect => $composableBuilder(
    column: $table.quizCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quizTotal => $composableBuilder(
    column: $table.quizTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageQuality => $composableBuilder(
    column: $table.averageQuality,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionLogsTable> {
  $$SessionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardsReviewed => $composableBuilder(
    column: $table.cardsReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quizCorrect => $composableBuilder(
    column: $table.quizCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quizTotal => $composableBuilder(
    column: $table.quizTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageQuality => $composableBuilder(
    column: $table.averageQuality,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionLogsTable> {
  $$SessionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get cardsReviewed => $composableBuilder(
    column: $table.cardsReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quizCorrect => $composableBuilder(
    column: $table.quizCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quizTotal =>
      $composableBuilder(column: $table.quizTotal, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averageQuality => $composableBuilder(
    column: $table.averageQuality,
    builder: (column) => column,
  );
}

class $$SessionLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionLogsTable,
          SessionLog,
          $$SessionLogsTableFilterComposer,
          $$SessionLogsTableOrderingComposer,
          $$SessionLogsTableAnnotationComposer,
          $$SessionLogsTableCreateCompanionBuilder,
          $$SessionLogsTableUpdateCompanionBuilder,
          (
            SessionLog,
            BaseReferences<_$AppDatabase, $SessionLogsTable, SessionLog>,
          ),
          SessionLog,
          PrefetchHooks Function()
        > {
  $$SessionLogsTableTableManager(_$AppDatabase db, $SessionLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> cardsReviewed = const Value.absent(),
                Value<int> quizCorrect = const Value.absent(),
                Value<int> quizTotal = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<double> averageQuality = const Value.absent(),
              }) => SessionLogsCompanion(
                id: id,
                date: date,
                cardsReviewed: cardsReviewed,
                quizCorrect: quizCorrect,
                quizTotal: quizTotal,
                durationMinutes: durationMinutes,
                averageQuality: averageQuality,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required int cardsReviewed,
                required int quizCorrect,
                required int quizTotal,
                required int durationMinutes,
                required double averageQuality,
              }) => SessionLogsCompanion.insert(
                id: id,
                date: date,
                cardsReviewed: cardsReviewed,
                quizCorrect: quizCorrect,
                quizTotal: quizTotal,
                durationMinutes: durationMinutes,
                averageQuality: averageQuality,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionLogsTable,
      SessionLog,
      $$SessionLogsTableFilterComposer,
      $$SessionLogsTableOrderingComposer,
      $$SessionLogsTableAnnotationComposer,
      $$SessionLogsTableCreateCompanionBuilder,
      $$SessionLogsTableUpdateCompanionBuilder,
      (
        SessionLog,
        BaseReferences<_$AppDatabase, $SessionLogsTable, SessionLog>,
      ),
      SessionLog,
      PrefetchHooks Function()
    >;
typedef $$UserStatsTableTableCreateCompanionBuilder =
    UserStatsTableCompanion Function({
      Value<int> id,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<DateTime?> lastSessionDate,
      Value<int> totalSessions,
      Value<int> totalReviews,
    });
typedef $$UserStatsTableTableUpdateCompanionBuilder =
    UserStatsTableCompanion Function({
      Value<int> id,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<DateTime?> lastSessionDate,
      Value<int> totalSessions,
      Value<int> totalReviews,
    });

class $$UserStatsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSessionDate => $composableBuilder(
    column: $table.lastSessionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSessions => $composableBuilder(
    column: $table.totalSessions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserStatsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSessionDate => $composableBuilder(
    column: $table.lastSessionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSessions => $composableBuilder(
    column: $table.totalSessions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserStatsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSessionDate => $composableBuilder(
    column: $table.lastSessionDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSessions => $composableBuilder(
    column: $table.totalSessions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalReviews => $composableBuilder(
    column: $table.totalReviews,
    builder: (column) => column,
  );
}

class $$UserStatsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserStatsTableTable,
          UserStatsTableData,
          $$UserStatsTableTableFilterComposer,
          $$UserStatsTableTableOrderingComposer,
          $$UserStatsTableTableAnnotationComposer,
          $$UserStatsTableTableCreateCompanionBuilder,
          $$UserStatsTableTableUpdateCompanionBuilder,
          (
            UserStatsTableData,
            BaseReferences<
              _$AppDatabase,
              $UserStatsTableTable,
              UserStatsTableData
            >,
          ),
          UserStatsTableData,
          PrefetchHooks Function()
        > {
  $$UserStatsTableTableTableManager(
    _$AppDatabase db,
    $UserStatsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStatsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStatsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStatsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<DateTime?> lastSessionDate = const Value.absent(),
                Value<int> totalSessions = const Value.absent(),
                Value<int> totalReviews = const Value.absent(),
              }) => UserStatsTableCompanion(
                id: id,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastSessionDate: lastSessionDate,
                totalSessions: totalSessions,
                totalReviews: totalReviews,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<DateTime?> lastSessionDate = const Value.absent(),
                Value<int> totalSessions = const Value.absent(),
                Value<int> totalReviews = const Value.absent(),
              }) => UserStatsTableCompanion.insert(
                id: id,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastSessionDate: lastSessionDate,
                totalSessions: totalSessions,
                totalReviews: totalReviews,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserStatsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserStatsTableTable,
      UserStatsTableData,
      $$UserStatsTableTableFilterComposer,
      $$UserStatsTableTableOrderingComposer,
      $$UserStatsTableTableAnnotationComposer,
      $$UserStatsTableTableCreateCompanionBuilder,
      $$UserStatsTableTableUpdateCompanionBuilder,
      (
        UserStatsTableData,
        BaseReferences<_$AppDatabase, $UserStatsTableTable, UserStatsTableData>,
      ),
      UserStatsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConceptsTableTableManager get concepts =>
      $$ConceptsTableTableManager(_db, _db.concepts);
  $$ReviewCardsTableTableManager get reviewCards =>
      $$ReviewCardsTableTableManager(_db, _db.reviewCards);
  $$ConfidenceLogsTableTableManager get confidenceLogs =>
      $$ConfidenceLogsTableTableManager(_db, _db.confidenceLogs);
  $$QuizQuestionsTableTableManager get quizQuestions =>
      $$QuizQuestionsTableTableManager(_db, _db.quizQuestions);
  $$QuizAttemptsTableTableManager get quizAttempts =>
      $$QuizAttemptsTableTableManager(_db, _db.quizAttempts);
  $$DomainProgressTableTableTableManager get domainProgressTable =>
      $$DomainProgressTableTableTableManager(_db, _db.domainProgressTable);
  $$SessionLogsTableTableManager get sessionLogs =>
      $$SessionLogsTableTableManager(_db, _db.sessionLogs);
  $$UserStatsTableTableTableManager get userStatsTable =>
      $$UserStatsTableTableTableManager(_db, _db.userStatsTable);
}
