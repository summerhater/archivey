// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class Documents extends Table with TableInfo<Documents, DocumentEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Documents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _createAtMeta = const VerificationMeta(
    'createAt',
  );
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
    'create_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT CURRENT_TIMESTAMP',
    defaultValue: const CustomExpression('CURRENT_TIMESTAMP'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _linkUrlMeta = const VerificationMeta(
    'linkUrl',
  );
  late final GeneratedColumn<String> linkUrl = GeneratedColumn<String>(
    'link_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _imgUrlMeta = const VerificationMeta('imgUrl');
  late final GeneratedColumn<String> imgUrl = GeneratedColumn<String>(
    'img_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createAt,
    title,
    linkUrl,
    imgUrl,
    category,
    platform,
    memo,
    summary,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('create_at')) {
      context.handle(
        _createAtMeta,
        createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('link_url')) {
      context.handle(
        _linkUrlMeta,
        linkUrl.isAcceptableOrUnknown(data['link_url']!, _linkUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_linkUrlMeta);
    }
    if (data.containsKey('img_url')) {
      context.handle(
        _imgUrlMeta,
        imgUrl.isAcceptableOrUnknown(data['img_url']!, _imgUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imgUrlMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}create_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      linkUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_url'],
      )!,
      imgUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}img_url'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
    );
  }

  @override
  Documents createAlias(String alias) {
    return Documents(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DocumentEntity extends DataClass implements Insertable<DocumentEntity> {
  final int id;
  final DateTime createAt;
  final String title;
  final String linkUrl;
  final String imgUrl;
  final String category;
  final String platform;
  final String? memo;
  final String? summary;
  const DocumentEntity({
    required this.id,
    required this.createAt,
    required this.title,
    required this.linkUrl,
    required this.imgUrl,
    required this.category,
    required this.platform,
    this.memo,
    this.summary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['create_at'] = Variable<DateTime>(createAt);
    map['title'] = Variable<String>(title);
    map['link_url'] = Variable<String>(linkUrl);
    map['img_url'] = Variable<String>(imgUrl);
    map['category'] = Variable<String>(category);
    map['platform'] = Variable<String>(platform);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      createAt: Value(createAt),
      title: Value(title),
      linkUrl: Value(linkUrl),
      imgUrl: Value(imgUrl),
      category: Value(category),
      platform: Value(platform),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
    );
  }

  factory DocumentEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentEntity(
      id: serializer.fromJson<int>(json['id']),
      createAt: serializer.fromJson<DateTime>(json['create_at']),
      title: serializer.fromJson<String>(json['title']),
      linkUrl: serializer.fromJson<String>(json['link_url']),
      imgUrl: serializer.fromJson<String>(json['img_url']),
      category: serializer.fromJson<String>(json['category']),
      platform: serializer.fromJson<String>(json['platform']),
      memo: serializer.fromJson<String?>(json['memo']),
      summary: serializer.fromJson<String?>(json['summary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'create_at': serializer.toJson<DateTime>(createAt),
      'title': serializer.toJson<String>(title),
      'link_url': serializer.toJson<String>(linkUrl),
      'img_url': serializer.toJson<String>(imgUrl),
      'category': serializer.toJson<String>(category),
      'platform': serializer.toJson<String>(platform),
      'memo': serializer.toJson<String?>(memo),
      'summary': serializer.toJson<String?>(summary),
    };
  }

  DocumentEntity copyWith({
    int? id,
    DateTime? createAt,
    String? title,
    String? linkUrl,
    String? imgUrl,
    String? category,
    String? platform,
    Value<String?> memo = const Value.absent(),
    Value<String?> summary = const Value.absent(),
  }) => DocumentEntity(
    id: id ?? this.id,
    createAt: createAt ?? this.createAt,
    title: title ?? this.title,
    linkUrl: linkUrl ?? this.linkUrl,
    imgUrl: imgUrl ?? this.imgUrl,
    category: category ?? this.category,
    platform: platform ?? this.platform,
    memo: memo.present ? memo.value : this.memo,
    summary: summary.present ? summary.value : this.summary,
  );
  DocumentEntity copyWithCompanion(DocumentsCompanion data) {
    return DocumentEntity(
      id: data.id.present ? data.id.value : this.id,
      createAt: data.createAt.present ? data.createAt.value : this.createAt,
      title: data.title.present ? data.title.value : this.title,
      linkUrl: data.linkUrl.present ? data.linkUrl.value : this.linkUrl,
      imgUrl: data.imgUrl.present ? data.imgUrl.value : this.imgUrl,
      category: data.category.present ? data.category.value : this.category,
      platform: data.platform.present ? data.platform.value : this.platform,
      memo: data.memo.present ? data.memo.value : this.memo,
      summary: data.summary.present ? data.summary.value : this.summary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentEntity(')
          ..write('id: $id, ')
          ..write('createAt: $createAt, ')
          ..write('title: $title, ')
          ..write('linkUrl: $linkUrl, ')
          ..write('imgUrl: $imgUrl, ')
          ..write('category: $category, ')
          ..write('platform: $platform, ')
          ..write('memo: $memo, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createAt,
    title,
    linkUrl,
    imgUrl,
    category,
    platform,
    memo,
    summary,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentEntity &&
          other.id == this.id &&
          other.createAt == this.createAt &&
          other.title == this.title &&
          other.linkUrl == this.linkUrl &&
          other.imgUrl == this.imgUrl &&
          other.category == this.category &&
          other.platform == this.platform &&
          other.memo == this.memo &&
          other.summary == this.summary);
}

class DocumentsCompanion extends UpdateCompanion<DocumentEntity> {
  final Value<int> id;
  final Value<DateTime> createAt;
  final Value<String> title;
  final Value<String> linkUrl;
  final Value<String> imgUrl;
  final Value<String> category;
  final Value<String> platform;
  final Value<String?> memo;
  final Value<String?> summary;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.createAt = const Value.absent(),
    this.title = const Value.absent(),
    this.linkUrl = const Value.absent(),
    this.imgUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.platform = const Value.absent(),
    this.memo = const Value.absent(),
    this.summary = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    this.createAt = const Value.absent(),
    required String title,
    required String linkUrl,
    required String imgUrl,
    required String category,
    required String platform,
    this.memo = const Value.absent(),
    this.summary = const Value.absent(),
  }) : title = Value(title),
       linkUrl = Value(linkUrl),
       imgUrl = Value(imgUrl),
       category = Value(category),
       platform = Value(platform);
  static Insertable<DocumentEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createAt,
    Expression<String>? title,
    Expression<String>? linkUrl,
    Expression<String>? imgUrl,
    Expression<String>? category,
    Expression<String>? platform,
    Expression<String>? memo,
    Expression<String>? summary,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createAt != null) 'create_at': createAt,
      if (title != null) 'title': title,
      if (linkUrl != null) 'link_url': linkUrl,
      if (imgUrl != null) 'img_url': imgUrl,
      if (category != null) 'category': category,
      if (platform != null) 'platform': platform,
      if (memo != null) 'memo': memo,
      if (summary != null) 'summary': summary,
    });
  }

  DocumentsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createAt,
    Value<String>? title,
    Value<String>? linkUrl,
    Value<String>? imgUrl,
    Value<String>? category,
    Value<String>? platform,
    Value<String?>? memo,
    Value<String?>? summary,
  }) {
    return DocumentsCompanion(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      title: title ?? this.title,
      linkUrl: linkUrl ?? this.linkUrl,
      imgUrl: imgUrl ?? this.imgUrl,
      category: category ?? this.category,
      platform: platform ?? this.platform,
      memo: memo ?? this.memo,
      summary: summary ?? this.summary,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (linkUrl.present) {
      map['link_url'] = Variable<String>(linkUrl.value);
    }
    if (imgUrl.present) {
      map['img_url'] = Variable<String>(imgUrl.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('createAt: $createAt, ')
          ..write('title: $title, ')
          ..write('linkUrl: $linkUrl, ')
          ..write('imgUrl: $imgUrl, ')
          ..write('category: $category, ')
          ..write('platform: $platform, ')
          ..write('memo: $memo, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }
}

class Tags extends Table with TableInfo<Tags, TagEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Tags(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  Tags createAlias(String alias) {
    return Tags(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TagEntity extends DataClass implements Insertable<TagEntity> {
  final int id;
  final String name;
  const TagEntity({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory TagEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  TagEntity copyWith({int? id, String? name}) =>
      TagEntity(id: id ?? this.id, name: name ?? this.name);
  TagEntity copyWithCompanion(TagsCompanion data) {
    return TagEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagEntity(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagEntity && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<TagEntity> {
  final Value<int> id;
  final Value<String> name;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagsCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<TagEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TagsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class DocumentTags extends Table with TableInfo<DocumentTags, DocumentTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentTags(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  late final GeneratedColumn<int> documentId = GeneratedColumn<int>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES documents(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES tags(id)ON DELETE CASCADE',
  );
  @override
  List<GeneratedColumn> get $columns => [documentId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {documentId, tagId};
  @override
  DocumentTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentTag(
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}document_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  DocumentTags createAlias(String alias) {
    return DocumentTags(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(document_id, tag_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class DocumentTag extends DataClass implements Insertable<DocumentTag> {
  final int documentId;
  final int tagId;
  const DocumentTag({required this.documentId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['document_id'] = Variable<int>(documentId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  DocumentTagsCompanion toCompanion(bool nullToAbsent) {
    return DocumentTagsCompanion(
      documentId: Value(documentId),
      tagId: Value(tagId),
    );
  }

  factory DocumentTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentTag(
      documentId: serializer.fromJson<int>(json['document_id']),
      tagId: serializer.fromJson<int>(json['tag_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'document_id': serializer.toJson<int>(documentId),
      'tag_id': serializer.toJson<int>(tagId),
    };
  }

  DocumentTag copyWith({int? documentId, int? tagId}) => DocumentTag(
    documentId: documentId ?? this.documentId,
    tagId: tagId ?? this.tagId,
  );
  DocumentTag copyWithCompanion(DocumentTagsCompanion data) {
    return DocumentTag(
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTag(')
          ..write('documentId: $documentId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(documentId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentTag &&
          other.documentId == this.documentId &&
          other.tagId == this.tagId);
}

class DocumentTagsCompanion extends UpdateCompanion<DocumentTag> {
  final Value<int> documentId;
  final Value<int> tagId;
  final Value<int> rowid;
  const DocumentTagsCompanion({
    this.documentId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentTagsCompanion.insert({
    required int documentId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : documentId = Value(documentId),
       tagId = Value(tagId);
  static Insertable<DocumentTag> custom({
    Expression<int>? documentId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (documentId != null) 'document_id': documentId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentTagsCompanion copyWith({
    Value<int>? documentId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return DocumentTagsCompanion(
      documentId: documentId ?? this.documentId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (documentId.present) {
      map['document_id'] = Variable<int>(documentId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTagsCompanion(')
          ..write('documentId: $documentId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DocumentsFts extends Table
    with
        TableInfo<DocumentsFts, DocumentsFt>,
        VirtualTableInfo<DocumentsFts, DocumentsFt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentsFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [title, category, memo, summary];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentsFt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    } else if (isInserting) {
      context.missing(_memoMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DocumentsFt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentsFt(
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
    );
  }

  @override
  DocumentsFts createAlias(String alias) {
    return DocumentsFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(title, category, memo, summary, content=\'documents\', content_rowid=\'id\')';
}

class DocumentsFt extends DataClass implements Insertable<DocumentsFt> {
  final String title;
  final String category;
  final String memo;
  final String summary;
  const DocumentsFt({
    required this.title,
    required this.category,
    required this.memo,
    required this.summary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['memo'] = Variable<String>(memo);
    map['summary'] = Variable<String>(summary);
    return map;
  }

  DocumentsFtsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsFtsCompanion(
      title: Value(title),
      category: Value(category),
      memo: Value(memo),
      summary: Value(summary),
    );
  }

  factory DocumentsFt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentsFt(
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      memo: serializer.fromJson<String>(json['memo']),
      summary: serializer.fromJson<String>(json['summary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'memo': serializer.toJson<String>(memo),
      'summary': serializer.toJson<String>(summary),
    };
  }

  DocumentsFt copyWith({
    String? title,
    String? category,
    String? memo,
    String? summary,
  }) => DocumentsFt(
    title: title ?? this.title,
    category: category ?? this.category,
    memo: memo ?? this.memo,
    summary: summary ?? this.summary,
  );
  DocumentsFt copyWithCompanion(DocumentsFtsCompanion data) {
    return DocumentsFt(
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      memo: data.memo.present ? data.memo.value : this.memo,
      summary: data.summary.present ? data.summary.value : this.summary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsFt(')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('memo: $memo, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(title, category, memo, summary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentsFt &&
          other.title == this.title &&
          other.category == this.category &&
          other.memo == this.memo &&
          other.summary == this.summary);
}

class DocumentsFtsCompanion extends UpdateCompanion<DocumentsFt> {
  final Value<String> title;
  final Value<String> category;
  final Value<String> memo;
  final Value<String> summary;
  final Value<int> rowid;
  const DocumentsFtsCompanion({
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.memo = const Value.absent(),
    this.summary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsFtsCompanion.insert({
    required String title,
    required String category,
    required String memo,
    required String summary,
    this.rowid = const Value.absent(),
  }) : title = Value(title),
       category = Value(category),
       memo = Value(memo),
       summary = Value(summary);
  static Insertable<DocumentsFt> custom({
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? memo,
    Expression<String>? summary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (memo != null) 'memo': memo,
      if (summary != null) 'summary': summary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsFtsCompanion copyWith({
    Value<String>? title,
    Value<String>? category,
    Value<String>? memo,
    Value<String>? summary,
    Value<int>? rowid,
  }) {
    return DocumentsFtsCompanion(
      title: title ?? this.title,
      category: category ?? this.category,
      memo: memo ?? this.memo,
      summary: summary ?? this.summary,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsFtsCompanion(')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('memo: $memo, ')
          ..write('summary: $summary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Documents documents = Documents(this);
  late final Tags tags = Tags(this);
  late final DocumentTags documentTags = DocumentTags(this);
  late final DocumentsFts documentsFts = DocumentsFts(this);
  late final Trigger documentsInsert = Trigger(
    'CREATE TRIGGER documents_insert AFTER INSERT ON documents BEGIN INSERT INTO documents_fts ("rowid", title, category, memo, summary) VALUES (new.id, new.title, new.category, new.memo, new.summary);END',
    'documents_insert',
  );
  late final Trigger documentsDelete = Trigger(
    'CREATE TRIGGER documents_delete AFTER DELETE ON documents BEGIN INSERT INTO documents_fts (documents_fts, "rowid", title, category, memo, summary) VALUES (\'delete\', old.id, old.title, old.category, old.memo, old.summary);END',
    'documents_delete',
  );
  late final Trigger documentsUpdate = Trigger(
    'CREATE TRIGGER documents_update AFTER UPDATE ON documents BEGIN INSERT INTO documents_fts (documents_fts, "rowid", title, category, memo, summary) VALUES (\'delete\', old.id, old.title, old.category, old.memo, old.summary);INSERT INTO documents_fts ("rowid", title, category, memo, summary) VALUES (new.id, new.title, new.category, new.memo, new.summary);END',
    'documents_update',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    documents,
    tags,
    documentTags,
    documentsFts,
    documentsInsert,
    documentsDelete,
    documentsUpdate,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'documents',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('document_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('document_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'documents',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('documents_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'documents',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('documents_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'documents',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('documents_fts', kind: UpdateKind.insert)],
    ),
  ]);
}

typedef $DocumentsCreateCompanionBuilder =
    DocumentsCompanion Function({
      Value<int> id,
      Value<DateTime> createAt,
      required String title,
      required String linkUrl,
      required String imgUrl,
      required String category,
      required String platform,
      Value<String?> memo,
      Value<String?> summary,
    });
typedef $DocumentsUpdateCompanionBuilder =
    DocumentsCompanion Function({
      Value<int> id,
      Value<DateTime> createAt,
      Value<String> title,
      Value<String> linkUrl,
      Value<String> imgUrl,
      Value<String> category,
      Value<String> platform,
      Value<String?> memo,
      Value<String?> summary,
    });

final class $DocumentsReferences
    extends BaseReferences<_$AppDatabase, Documents, DocumentEntity> {
  $DocumentsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<DocumentTags, List<DocumentTag>>
  _documentTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documentTags,
    aliasName: $_aliasNameGenerator(
      db.documents.id,
      db.documentTags.documentId,
    ),
  );

  $DocumentTagsProcessedTableManager get documentTagsRefs {
    final manager = $DocumentTagsTableManager(
      $_db,
      $_db.documentTags,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $DocumentsFilterComposer extends Composer<_$AppDatabase, Documents> {
  $DocumentsFilterComposer({
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

  ColumnFilters<DateTime> get createAt => $composableBuilder(
    column: $table.createAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkUrl => $composableBuilder(
    column: $table.linkUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imgUrl => $composableBuilder(
    column: $table.imgUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> documentTagsRefs(
    Expression<bool> Function($DocumentTagsFilterComposer f) f,
  ) {
    final $DocumentTagsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentTags,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTagsFilterComposer(
            $db: $db,
            $table: $db.documentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $DocumentsOrderingComposer extends Composer<_$AppDatabase, Documents> {
  $DocumentsOrderingComposer({
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

  ColumnOrderings<DateTime> get createAt => $composableBuilder(
    column: $table.createAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkUrl => $composableBuilder(
    column: $table.linkUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imgUrl => $composableBuilder(
    column: $table.imgUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );
}

class $DocumentsAnnotationComposer extends Composer<_$AppDatabase, Documents> {
  $DocumentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createAt =>
      $composableBuilder(column: $table.createAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get linkUrl =>
      $composableBuilder(column: $table.linkUrl, builder: (column) => column);

  GeneratedColumn<String> get imgUrl =>
      $composableBuilder(column: $table.imgUrl, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  Expression<T> documentTagsRefs<T extends Object>(
    Expression<T> Function($DocumentTagsAnnotationComposer a) f,
  ) {
    final $DocumentTagsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentTags,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTagsAnnotationComposer(
            $db: $db,
            $table: $db.documentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $DocumentsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Documents,
          DocumentEntity,
          $DocumentsFilterComposer,
          $DocumentsOrderingComposer,
          $DocumentsAnnotationComposer,
          $DocumentsCreateCompanionBuilder,
          $DocumentsUpdateCompanionBuilder,
          (DocumentEntity, $DocumentsReferences),
          DocumentEntity,
          PrefetchHooks Function({bool documentTagsRefs})
        > {
  $DocumentsTableManager(_$AppDatabase db, Documents table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DocumentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DocumentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DocumentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> linkUrl = const Value.absent(),
                Value<String> imgUrl = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> summary = const Value.absent(),
              }) => DocumentsCompanion(
                id: id,
                createAt: createAt,
                title: title,
                linkUrl: linkUrl,
                imgUrl: imgUrl,
                category: category,
                platform: platform,
                memo: memo,
                summary: summary,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createAt = const Value.absent(),
                required String title,
                required String linkUrl,
                required String imgUrl,
                required String category,
                required String platform,
                Value<String?> memo = const Value.absent(),
                Value<String?> summary = const Value.absent(),
              }) => DocumentsCompanion.insert(
                id: id,
                createAt: createAt,
                title: title,
                linkUrl: linkUrl,
                imgUrl: imgUrl,
                category: category,
                platform: platform,
                memo: memo,
                summary: summary,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), $DocumentsReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({documentTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (documentTagsRefs) db.documentTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (documentTagsRefs)
                    await $_getPrefetchedData<
                      DocumentEntity,
                      Documents,
                      DocumentTag
                    >(
                      currentTable: table,
                      referencedTable: $DocumentsReferences
                          ._documentTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $DocumentsReferences(db, table, p0).documentTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.documentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $DocumentsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Documents,
      DocumentEntity,
      $DocumentsFilterComposer,
      $DocumentsOrderingComposer,
      $DocumentsAnnotationComposer,
      $DocumentsCreateCompanionBuilder,
      $DocumentsUpdateCompanionBuilder,
      (DocumentEntity, $DocumentsReferences),
      DocumentEntity,
      PrefetchHooks Function({bool documentTagsRefs})
    >;
typedef $TagsCreateCompanionBuilder =
    TagsCompanion Function({Value<int> id, required String name});
typedef $TagsUpdateCompanionBuilder =
    TagsCompanion Function({Value<int> id, Value<String> name});

final class $TagsReferences
    extends BaseReferences<_$AppDatabase, Tags, TagEntity> {
  $TagsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<DocumentTags, List<DocumentTag>>
  _documentTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documentTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.documentTags.tagId),
  );

  $DocumentTagsProcessedTableManager get documentTagsRefs {
    final manager = $DocumentTagsTableManager(
      $_db,
      $_db.documentTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $TagsFilterComposer extends Composer<_$AppDatabase, Tags> {
  $TagsFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> documentTagsRefs(
    Expression<bool> Function($DocumentTagsFilterComposer f) f,
  ) {
    final $DocumentTagsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTagsFilterComposer(
            $db: $db,
            $table: $db.documentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TagsOrderingComposer extends Composer<_$AppDatabase, Tags> {
  $TagsOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TagsAnnotationComposer extends Composer<_$AppDatabase, Tags> {
  $TagsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> documentTagsRefs<T extends Object>(
    Expression<T> Function($DocumentTagsAnnotationComposer a) f,
  ) {
    final $DocumentTagsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTagsAnnotationComposer(
            $db: $db,
            $table: $db.documentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TagsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Tags,
          TagEntity,
          $TagsFilterComposer,
          $TagsOrderingComposer,
          $TagsAnnotationComposer,
          $TagsCreateCompanionBuilder,
          $TagsUpdateCompanionBuilder,
          (TagEntity, $TagsReferences),
          TagEntity,
          PrefetchHooks Function({bool documentTagsRefs})
        > {
  $TagsTableManager(_$AppDatabase db, Tags table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TagsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TagsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TagsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => TagsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  TagsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $TagsReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({documentTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (documentTagsRefs) db.documentTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (documentTagsRefs)
                    await $_getPrefetchedData<TagEntity, Tags, DocumentTag>(
                      currentTable: table,
                      referencedTable: $TagsReferences._documentTagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $TagsReferences(db, table, p0).documentTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $TagsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Tags,
      TagEntity,
      $TagsFilterComposer,
      $TagsOrderingComposer,
      $TagsAnnotationComposer,
      $TagsCreateCompanionBuilder,
      $TagsUpdateCompanionBuilder,
      (TagEntity, $TagsReferences),
      TagEntity,
      PrefetchHooks Function({bool documentTagsRefs})
    >;
typedef $DocumentTagsCreateCompanionBuilder =
    DocumentTagsCompanion Function({
      required int documentId,
      required int tagId,
      Value<int> rowid,
    });
typedef $DocumentTagsUpdateCompanionBuilder =
    DocumentTagsCompanion Function({
      Value<int> documentId,
      Value<int> tagId,
      Value<int> rowid,
    });

final class $DocumentTagsReferences
    extends BaseReferences<_$AppDatabase, DocumentTags, DocumentTag> {
  $DocumentTagsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Documents _documentIdTable(_$AppDatabase db) =>
      db.documents.createAlias(
        $_aliasNameGenerator(db.documentTags.documentId, db.documents.id),
      );

  $DocumentsProcessedTableManager get documentId {
    final $_column = $_itemColumn<int>('document_id')!;

    final manager = $DocumentsTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Tags _tagIdTable(_$AppDatabase db) => db.tags.createAlias(
    $_aliasNameGenerator(db.documentTags.tagId, db.tags.id),
  );

  $TagsProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $TagsTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $DocumentTagsFilterComposer
    extends Composer<_$AppDatabase, DocumentTags> {
  $DocumentTagsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $DocumentsFilterComposer get documentId {
    final $DocumentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TagsFilterComposer get tagId {
    final $TagsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TagsFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DocumentTagsOrderingComposer
    extends Composer<_$AppDatabase, DocumentTags> {
  $DocumentTagsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $DocumentsOrderingComposer get documentId {
    final $DocumentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TagsOrderingComposer get tagId {
    final $TagsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TagsOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DocumentTagsAnnotationComposer
    extends Composer<_$AppDatabase, DocumentTags> {
  $DocumentTagsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $DocumentsAnnotationComposer get documentId {
    final $DocumentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TagsAnnotationComposer get tagId {
    final $TagsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TagsAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DocumentTagsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          DocumentTags,
          DocumentTag,
          $DocumentTagsFilterComposer,
          $DocumentTagsOrderingComposer,
          $DocumentTagsAnnotationComposer,
          $DocumentTagsCreateCompanionBuilder,
          $DocumentTagsUpdateCompanionBuilder,
          (DocumentTag, $DocumentTagsReferences),
          DocumentTag,
          PrefetchHooks Function({bool documentId, bool tagId})
        > {
  $DocumentTagsTableManager(_$AppDatabase db, DocumentTags table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DocumentTagsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DocumentTagsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DocumentTagsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> documentId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentTagsCompanion(
                documentId: documentId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int documentId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => DocumentTagsCompanion.insert(
                documentId: documentId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $DocumentTagsReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({documentId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (documentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.documentId,
                                referencedTable: $DocumentTagsReferences
                                    ._documentIdTable(db),
                                referencedColumn: $DocumentTagsReferences
                                    ._documentIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $DocumentTagsReferences
                                    ._tagIdTable(db),
                                referencedColumn: $DocumentTagsReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $DocumentTagsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      DocumentTags,
      DocumentTag,
      $DocumentTagsFilterComposer,
      $DocumentTagsOrderingComposer,
      $DocumentTagsAnnotationComposer,
      $DocumentTagsCreateCompanionBuilder,
      $DocumentTagsUpdateCompanionBuilder,
      (DocumentTag, $DocumentTagsReferences),
      DocumentTag,
      PrefetchHooks Function({bool documentId, bool tagId})
    >;
typedef $DocumentsFtsCreateCompanionBuilder =
    DocumentsFtsCompanion Function({
      required String title,
      required String category,
      required String memo,
      required String summary,
      Value<int> rowid,
    });
typedef $DocumentsFtsUpdateCompanionBuilder =
    DocumentsFtsCompanion Function({
      Value<String> title,
      Value<String> category,
      Value<String> memo,
      Value<String> summary,
      Value<int> rowid,
    });

class $DocumentsFtsFilterComposer
    extends Composer<_$AppDatabase, DocumentsFts> {
  $DocumentsFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );
}

class $DocumentsFtsOrderingComposer
    extends Composer<_$AppDatabase, DocumentsFts> {
  $DocumentsFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );
}

class $DocumentsFtsAnnotationComposer
    extends Composer<_$AppDatabase, DocumentsFts> {
  $DocumentsFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);
}

class $DocumentsFtsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          DocumentsFts,
          DocumentsFt,
          $DocumentsFtsFilterComposer,
          $DocumentsFtsOrderingComposer,
          $DocumentsFtsAnnotationComposer,
          $DocumentsFtsCreateCompanionBuilder,
          $DocumentsFtsUpdateCompanionBuilder,
          (
            DocumentsFt,
            BaseReferences<_$AppDatabase, DocumentsFts, DocumentsFt>,
          ),
          DocumentsFt,
          PrefetchHooks Function()
        > {
  $DocumentsFtsTableManager(_$AppDatabase db, DocumentsFts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DocumentsFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DocumentsFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DocumentsFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> memo = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsFtsCompanion(
                title: title,
                category: category,
                memo: memo,
                summary: summary,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String title,
                required String category,
                required String memo,
                required String summary,
                Value<int> rowid = const Value.absent(),
              }) => DocumentsFtsCompanion.insert(
                title: title,
                category: category,
                memo: memo,
                summary: summary,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $DocumentsFtsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      DocumentsFts,
      DocumentsFt,
      $DocumentsFtsFilterComposer,
      $DocumentsFtsOrderingComposer,
      $DocumentsFtsAnnotationComposer,
      $DocumentsFtsCreateCompanionBuilder,
      $DocumentsFtsUpdateCompanionBuilder,
      (DocumentsFt, BaseReferences<_$AppDatabase, DocumentsFts, DocumentsFt>),
      DocumentsFt,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $DocumentsTableManager get documents =>
      $DocumentsTableManager(_db, _db.documents);
  $TagsTableManager get tags => $TagsTableManager(_db, _db.tags);
  $DocumentTagsTableManager get documentTags =>
      $DocumentTagsTableManager(_db, _db.documentTags);
  $DocumentsFtsTableManager get documentsFts =>
      $DocumentsFtsTableManager(_db, _db.documentsFts);
}
