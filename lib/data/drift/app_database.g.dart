// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class AppSettings extends Table with TableInfo<AppSettings, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AppSettings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _lastSyncTimeMeta = const VerificationMeta(
    'lastSyncTime',
  );
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
    'last_sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [id, lastSyncTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
        _lastSyncTimeMeta,
        lastSyncTime.isAcceptableOrUnknown(
          data['last_sync_time']!,
          _lastSyncTimeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      ),
      lastSyncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_time'],
      ),
    );
  }

  @override
  AppSettings createAlias(String alias) {
    return AppSettings(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int? id;
  final DateTime? lastSyncTime;
  const AppSetting({this.id, this.lastSyncTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int?>(json['id']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['last_sync_time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'last_sync_time': serializer.toJson<DateTime?>(lastSyncTime),
    };
  }

  AppSetting copyWith({
    Value<int?> id = const Value.absent(),
    Value<DateTime?> lastSyncTime = const Value.absent(),
  }) => AppSetting(
    id: id.present ? id.value : this.id,
    lastSyncTime: lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      lastSyncTime: data.lastSyncTime.present
          ? data.lastSyncTime.value
          : this.lastSyncTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('lastSyncTime: $lastSyncTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastSyncTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.lastSyncTime == this.lastSyncTime);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int?> id;
  final Value<DateTime?> lastSyncTime;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<DateTime>? lastSyncTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int?>? id,
    Value<DateTime?>? lastSyncTime,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('lastSyncTime: $lastSyncTime')
          ..write(')'))
        .toString();
  }
}

class Documents extends Table with TableInfo<Documents, DocumentEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Documents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
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
  static const VerificationMeta _userMemoMeta = const VerificationMeta(
    'userMemo',
  );
  late final GeneratedColumn<String> userMemo = GeneratedColumn<String>(
    'user_memo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
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
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
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
  static const VerificationMeta _aiSummaryMeta = const VerificationMeta(
    'aiSummary',
  );
  late final GeneratedColumn<String> aiSummary = GeneratedColumn<String>(
    'ai_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _aiStatusMeta = const VerificationMeta(
    'aiStatus',
  );
  late final GeneratedColumn<String> aiStatus = GeneratedColumn<String>(
    'ai_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    id,
    uid,
    createdAt,
    updatedAt,
    syncStatus,
    category,
    userMemo,
    title,
    url,
    imageUrl,
    platform,
    aiSummary,
    aiStatus,
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
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('user_memo')) {
      context.handle(
        _userMemoMeta,
        userMemo.isAcceptableOrUnknown(data['user_memo']!, _userMemoMeta),
      );
    } else if (isInserting) {
      context.missing(_userMemoMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('ai_summary')) {
      context.handle(
        _aiSummaryMeta,
        aiSummary.isAcceptableOrUnknown(data['ai_summary']!, _aiSummaryMeta),
      );
    } else if (isInserting) {
      context.missing(_aiSummaryMeta);
    }
    if (data.containsKey('ai_status')) {
      context.handle(
        _aiStatusMeta,
        aiStatus.isAcceptableOrUnknown(data['ai_status']!, _aiStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_aiStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  DocumentEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      userMemo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_memo'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      aiSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_summary'],
      )!,
      aiStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_status'],
      )!,
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
  final int localId;
  final String id;
  final String uid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final String category;
  final String userMemo;
  final String title;
  final String url;
  final String imageUrl;
  final String platform;
  final String aiSummary;
  final String aiStatus;
  const DocumentEntity({
    required this.localId,
    required this.id,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.category,
    required this.userMemo,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.platform,
    required this.aiSummary,
    required this.aiStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    map['id'] = Variable<String>(id);
    map['uid'] = Variable<String>(uid);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    map['category'] = Variable<String>(category);
    map['user_memo'] = Variable<String>(userMemo);
    map['title'] = Variable<String>(title);
    map['url'] = Variable<String>(url);
    map['image_url'] = Variable<String>(imageUrl);
    map['platform'] = Variable<String>(platform);
    map['ai_summary'] = Variable<String>(aiSummary);
    map['ai_status'] = Variable<String>(aiStatus);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      localId: Value(localId),
      id: Value(id),
      uid: Value(uid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      category: Value(category),
      userMemo: Value(userMemo),
      title: Value(title),
      url: Value(url),
      imageUrl: Value(imageUrl),
      platform: Value(platform),
      aiSummary: Value(aiSummary),
      aiStatus: Value(aiStatus),
    );
  }

  factory DocumentEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentEntity(
      localId: serializer.fromJson<int>(json['local_id']),
      id: serializer.fromJson<String>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      syncStatus: serializer.fromJson<String>(json['sync_status']),
      category: serializer.fromJson<String>(json['category']),
      userMemo: serializer.fromJson<String>(json['user_memo']),
      title: serializer.fromJson<String>(json['title']),
      url: serializer.fromJson<String>(json['url']),
      imageUrl: serializer.fromJson<String>(json['image_url']),
      platform: serializer.fromJson<String>(json['platform']),
      aiSummary: serializer.fromJson<String>(json['ai_summary']),
      aiStatus: serializer.fromJson<String>(json['ai_status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_id': serializer.toJson<int>(localId),
      'id': serializer.toJson<String>(id),
      'uid': serializer.toJson<String>(uid),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'sync_status': serializer.toJson<String>(syncStatus),
      'category': serializer.toJson<String>(category),
      'user_memo': serializer.toJson<String>(userMemo),
      'title': serializer.toJson<String>(title),
      'url': serializer.toJson<String>(url),
      'image_url': serializer.toJson<String>(imageUrl),
      'platform': serializer.toJson<String>(platform),
      'ai_summary': serializer.toJson<String>(aiSummary),
      'ai_status': serializer.toJson<String>(aiStatus),
    };
  }

  DocumentEntity copyWith({
    int? localId,
    String? id,
    String? uid,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    String? category,
    String? userMemo,
    String? title,
    String? url,
    String? imageUrl,
    String? platform,
    String? aiSummary,
    String? aiStatus,
  }) => DocumentEntity(
    localId: localId ?? this.localId,
    id: id ?? this.id,
    uid: uid ?? this.uid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    category: category ?? this.category,
    userMemo: userMemo ?? this.userMemo,
    title: title ?? this.title,
    url: url ?? this.url,
    imageUrl: imageUrl ?? this.imageUrl,
    platform: platform ?? this.platform,
    aiSummary: aiSummary ?? this.aiSummary,
    aiStatus: aiStatus ?? this.aiStatus,
  );
  DocumentEntity copyWithCompanion(DocumentsCompanion data) {
    return DocumentEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      id: data.id.present ? data.id.value : this.id,
      uid: data.uid.present ? data.uid.value : this.uid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      category: data.category.present ? data.category.value : this.category,
      userMemo: data.userMemo.present ? data.userMemo.value : this.userMemo,
      title: data.title.present ? data.title.value : this.title,
      url: data.url.present ? data.url.value : this.url,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      platform: data.platform.present ? data.platform.value : this.platform,
      aiSummary: data.aiSummary.present ? data.aiSummary.value : this.aiSummary,
      aiStatus: data.aiStatus.present ? data.aiStatus.value : this.aiStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentEntity(')
          ..write('localId: $localId, ')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('category: $category, ')
          ..write('userMemo: $userMemo, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('platform: $platform, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('aiStatus: $aiStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    id,
    uid,
    createdAt,
    updatedAt,
    syncStatus,
    category,
    userMemo,
    title,
    url,
    imageUrl,
    platform,
    aiSummary,
    aiStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentEntity &&
          other.localId == this.localId &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.category == this.category &&
          other.userMemo == this.userMemo &&
          other.title == this.title &&
          other.url == this.url &&
          other.imageUrl == this.imageUrl &&
          other.platform == this.platform &&
          other.aiSummary == this.aiSummary &&
          other.aiStatus == this.aiStatus);
}

class DocumentsCompanion extends UpdateCompanion<DocumentEntity> {
  final Value<int> localId;
  final Value<String> id;
  final Value<String> uid;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<String> category;
  final Value<String> userMemo;
  final Value<String> title;
  final Value<String> url;
  final Value<String> imageUrl;
  final Value<String> platform;
  final Value<String> aiSummary;
  final Value<String> aiStatus;
  const DocumentsCompanion({
    this.localId = const Value.absent(),
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.category = const Value.absent(),
    this.userMemo = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.platform = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.aiStatus = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.localId = const Value.absent(),
    required String id,
    required String uid,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String syncStatus,
    required String category,
    required String userMemo,
    required String title,
    required String url,
    required String imageUrl,
    required String platform,
    required String aiSummary,
    required String aiStatus,
  }) : id = Value(id),
       uid = Value(uid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       syncStatus = Value(syncStatus),
       category = Value(category),
       userMemo = Value(userMemo),
       title = Value(title),
       url = Value(url),
       imageUrl = Value(imageUrl),
       platform = Value(platform),
       aiSummary = Value(aiSummary),
       aiStatus = Value(aiStatus);
  static Insertable<DocumentEntity> custom({
    Expression<int>? localId,
    Expression<String>? id,
    Expression<String>? uid,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<String>? category,
    Expression<String>? userMemo,
    Expression<String>? title,
    Expression<String>? url,
    Expression<String>? imageUrl,
    Expression<String>? platform,
    Expression<String>? aiSummary,
    Expression<String>? aiStatus,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (category != null) 'category': category,
      if (userMemo != null) 'user_memo': userMemo,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (imageUrl != null) 'image_url': imageUrl,
      if (platform != null) 'platform': platform,
      if (aiSummary != null) 'ai_summary': aiSummary,
      if (aiStatus != null) 'ai_status': aiStatus,
    });
  }

  DocumentsCompanion copyWith({
    Value<int>? localId,
    Value<String>? id,
    Value<String>? uid,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<String>? category,
    Value<String>? userMemo,
    Value<String>? title,
    Value<String>? url,
    Value<String>? imageUrl,
    Value<String>? platform,
    Value<String>? aiSummary,
    Value<String>? aiStatus,
  }) {
    return DocumentsCompanion(
      localId: localId ?? this.localId,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      category: category ?? this.category,
      userMemo: userMemo ?? this.userMemo,
      title: title ?? this.title,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      platform: platform ?? this.platform,
      aiSummary: aiSummary ?? this.aiSummary,
      aiStatus: aiStatus ?? this.aiStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (userMemo.present) {
      map['user_memo'] = Variable<String>(userMemo.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (aiSummary.present) {
      map['ai_summary'] = Variable<String>(aiSummary.value);
    }
    if (aiStatus.present) {
      map['ai_status'] = Variable<String>(aiStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('localId: $localId, ')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('category: $category, ')
          ..write('userMemo: $userMemo, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('platform: $platform, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('aiStatus: $aiStatus')
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
    $customConstraints:
        'NOT NULL REFERENCES documents(local_id)ON DELETE CASCADE',
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
  static const VerificationMeta _userMemoMeta = const VerificationMeta(
    'userMemo',
  );
  late final GeneratedColumn<String> userMemo = GeneratedColumn<String>(
    'user_memo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _aiSummaryMeta = const VerificationMeta(
    'aiSummary',
  );
  late final GeneratedColumn<String> aiSummary = GeneratedColumn<String>(
    'ai_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [title, category, userMemo, aiSummary];
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
    if (data.containsKey('user_memo')) {
      context.handle(
        _userMemoMeta,
        userMemo.isAcceptableOrUnknown(data['user_memo']!, _userMemoMeta),
      );
    } else if (isInserting) {
      context.missing(_userMemoMeta);
    }
    if (data.containsKey('ai_summary')) {
      context.handle(
        _aiSummaryMeta,
        aiSummary.isAcceptableOrUnknown(data['ai_summary']!, _aiSummaryMeta),
      );
    } else if (isInserting) {
      context.missing(_aiSummaryMeta);
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
      userMemo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_memo'],
      )!,
      aiSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_summary'],
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
      'fts5(title, category, user_memo, ai_summary, content=\'documents\', content_rowid=\'local_id\')';
}

class DocumentsFt extends DataClass implements Insertable<DocumentsFt> {
  final String title;
  final String category;
  final String userMemo;
  final String aiSummary;
  const DocumentsFt({
    required this.title,
    required this.category,
    required this.userMemo,
    required this.aiSummary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['user_memo'] = Variable<String>(userMemo);
    map['ai_summary'] = Variable<String>(aiSummary);
    return map;
  }

  DocumentsFtsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsFtsCompanion(
      title: Value(title),
      category: Value(category),
      userMemo: Value(userMemo),
      aiSummary: Value(aiSummary),
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
      userMemo: serializer.fromJson<String>(json['user_memo']),
      aiSummary: serializer.fromJson<String>(json['ai_summary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'user_memo': serializer.toJson<String>(userMemo),
      'ai_summary': serializer.toJson<String>(aiSummary),
    };
  }

  DocumentsFt copyWith({
    String? title,
    String? category,
    String? userMemo,
    String? aiSummary,
  }) => DocumentsFt(
    title: title ?? this.title,
    category: category ?? this.category,
    userMemo: userMemo ?? this.userMemo,
    aiSummary: aiSummary ?? this.aiSummary,
  );
  DocumentsFt copyWithCompanion(DocumentsFtsCompanion data) {
    return DocumentsFt(
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      userMemo: data.userMemo.present ? data.userMemo.value : this.userMemo,
      aiSummary: data.aiSummary.present ? data.aiSummary.value : this.aiSummary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsFt(')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('userMemo: $userMemo, ')
          ..write('aiSummary: $aiSummary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(title, category, userMemo, aiSummary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentsFt &&
          other.title == this.title &&
          other.category == this.category &&
          other.userMemo == this.userMemo &&
          other.aiSummary == this.aiSummary);
}

class DocumentsFtsCompanion extends UpdateCompanion<DocumentsFt> {
  final Value<String> title;
  final Value<String> category;
  final Value<String> userMemo;
  final Value<String> aiSummary;
  final Value<int> rowid;
  const DocumentsFtsCompanion({
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.userMemo = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsFtsCompanion.insert({
    required String title,
    required String category,
    required String userMemo,
    required String aiSummary,
    this.rowid = const Value.absent(),
  }) : title = Value(title),
       category = Value(category),
       userMemo = Value(userMemo),
       aiSummary = Value(aiSummary);
  static Insertable<DocumentsFt> custom({
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? userMemo,
    Expression<String>? aiSummary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (userMemo != null) 'user_memo': userMemo,
      if (aiSummary != null) 'ai_summary': aiSummary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsFtsCompanion copyWith({
    Value<String>? title,
    Value<String>? category,
    Value<String>? userMemo,
    Value<String>? aiSummary,
    Value<int>? rowid,
  }) {
    return DocumentsFtsCompanion(
      title: title ?? this.title,
      category: category ?? this.category,
      userMemo: userMemo ?? this.userMemo,
      aiSummary: aiSummary ?? this.aiSummary,
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
    if (userMemo.present) {
      map['user_memo'] = Variable<String>(userMemo.value);
    }
    if (aiSummary.present) {
      map['ai_summary'] = Variable<String>(aiSummary.value);
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
          ..write('userMemo: $userMemo, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final AppSettings appSettings = AppSettings(this);
  late final Documents documents = Documents(this);
  late final Tags tags = Tags(this);
  late final DocumentTags documentTags = DocumentTags(this);
  late final DocumentsFts documentsFts = DocumentsFts(this);
  late final Trigger documentsInsert = Trigger(
    'CREATE TRIGGER documents_insert AFTER INSERT ON documents BEGIN INSERT INTO documents_fts ("rowid", title, category, user_memo, ai_summary) VALUES (new.local_id, new.title, new.category, new.user_memo, new.ai_summary);END',
    'documents_insert',
  );
  late final Trigger documentsDelete = Trigger(
    'CREATE TRIGGER documents_delete AFTER DELETE ON documents BEGIN INSERT INTO documents_fts (documents_fts, "rowid", title, category, user_memo, ai_summary) VALUES (\'delete\', old.local_id, old.title, old.category, old.user_memo, old.ai_summary);END',
    'documents_delete',
  );
  late final Trigger documentsUpdate = Trigger(
    'CREATE TRIGGER documents_update AFTER UPDATE ON documents BEGIN INSERT INTO documents_fts (documents_fts, "rowid", title, category, user_memo, ai_summary) VALUES (\'delete\', old.local_id, old.title, old.category, old.user_memo, old.ai_summary);INSERT INTO documents_fts ("rowid", title, category, user_memo, ai_summary) VALUES (new.local_id, new.title, new.category, new.user_memo, new.ai_summary);END',
    'documents_update',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
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

typedef $AppSettingsCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int?> id,
      Value<DateTime?> lastSyncTime,
    });
typedef $AppSettingsUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int?> id,
      Value<DateTime?> lastSyncTime,
    });

class $AppSettingsFilterComposer extends Composer<_$AppDatabase, AppSettings> {
  $AppSettingsFilterComposer({
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

  ColumnFilters<DateTime> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => ColumnFilters(column),
  );
}

class $AppSettingsOrderingComposer
    extends Composer<_$AppDatabase, AppSettings> {
  $AppSettingsOrderingComposer({
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

  ColumnOrderings<DateTime> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AppSettingsAnnotationComposer
    extends Composer<_$AppDatabase, AppSettings> {
  $AppSettingsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => column,
  );
}

class $AppSettingsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AppSettings,
          AppSetting,
          $AppSettingsFilterComposer,
          $AppSettingsOrderingComposer,
          $AppSettingsAnnotationComposer,
          $AppSettingsCreateCompanionBuilder,
          $AppSettingsUpdateCompanionBuilder,
          (AppSetting, BaseReferences<_$AppDatabase, AppSettings, AppSetting>),
          AppSetting,
          PrefetchHooks Function()
        > {
  $AppSettingsTableManager(_$AppDatabase db, AppSettings table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AppSettingsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AppSettingsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AppSettingsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int?> id = const Value.absent(),
                Value<DateTime?> lastSyncTime = const Value.absent(),
              }) => AppSettingsCompanion(id: id, lastSyncTime: lastSyncTime),
          createCompanionCallback:
              ({
                Value<int?> id = const Value.absent(),
                Value<DateTime?> lastSyncTime = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                lastSyncTime: lastSyncTime,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $AppSettingsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AppSettings,
      AppSetting,
      $AppSettingsFilterComposer,
      $AppSettingsOrderingComposer,
      $AppSettingsAnnotationComposer,
      $AppSettingsCreateCompanionBuilder,
      $AppSettingsUpdateCompanionBuilder,
      (AppSetting, BaseReferences<_$AppDatabase, AppSettings, AppSetting>),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $DocumentsCreateCompanionBuilder =
    DocumentsCompanion Function({
      Value<int> localId,
      required String id,
      required String uid,
      required DateTime createdAt,
      required DateTime updatedAt,
      required String syncStatus,
      required String category,
      required String userMemo,
      required String title,
      required String url,
      required String imageUrl,
      required String platform,
      required String aiSummary,
      required String aiStatus,
    });
typedef $DocumentsUpdateCompanionBuilder =
    DocumentsCompanion Function({
      Value<int> localId,
      Value<String> id,
      Value<String> uid,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<String> category,
      Value<String> userMemo,
      Value<String> title,
      Value<String> url,
      Value<String> imageUrl,
      Value<String> platform,
      Value<String> aiSummary,
      Value<String> aiStatus,
    });

final class $DocumentsReferences
    extends BaseReferences<_$AppDatabase, Documents, DocumentEntity> {
  $DocumentsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<DocumentTags, List<DocumentTag>>
  _documentTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documentTags,
    aliasName: $_aliasNameGenerator(
      db.documents.localId,
      db.documentTags.documentId,
    ),
  );

  $DocumentTagsProcessedTableManager get documentTagsRefs {
    final manager = $DocumentTagsTableManager($_db, $_db.documentTags).filter(
      (f) => f.documentId.localId.sqlEquals($_itemColumn<int>('local_id')!),
    );

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
  ColumnFilters<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userMemo => $composableBuilder(
    column: $table.userMemo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiStatus => $composableBuilder(
    column: $table.aiStatus,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> documentTagsRefs(
    Expression<bool> Function($DocumentTagsFilterComposer f) f,
  ) {
    final $DocumentTagsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
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
  ColumnOrderings<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userMemo => $composableBuilder(
    column: $table.userMemo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiStatus => $composableBuilder(
    column: $table.aiStatus,
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
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get userMemo =>
      $composableBuilder(column: $table.userMemo, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get aiSummary =>
      $composableBuilder(column: $table.aiSummary, builder: (column) => column);

  GeneratedColumn<String> get aiStatus =>
      $composableBuilder(column: $table.aiStatus, builder: (column) => column);

  Expression<T> documentTagsRefs<T extends Object>(
    Expression<T> Function($DocumentTagsAnnotationComposer a) f,
  ) {
    final $DocumentTagsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
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
                Value<int> localId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> userMemo = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> aiSummary = const Value.absent(),
                Value<String> aiStatus = const Value.absent(),
              }) => DocumentsCompanion(
                localId: localId,
                id: id,
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                category: category,
                userMemo: userMemo,
                title: title,
                url: url,
                imageUrl: imageUrl,
                platform: platform,
                aiSummary: aiSummary,
                aiStatus: aiStatus,
              ),
          createCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                required String id,
                required String uid,
                required DateTime createdAt,
                required DateTime updatedAt,
                required String syncStatus,
                required String category,
                required String userMemo,
                required String title,
                required String url,
                required String imageUrl,
                required String platform,
                required String aiSummary,
                required String aiStatus,
              }) => DocumentsCompanion.insert(
                localId: localId,
                id: id,
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                category: category,
                userMemo: userMemo,
                title: title,
                url: url,
                imageUrl: imageUrl,
                platform: platform,
                aiSummary: aiSummary,
                aiStatus: aiStatus,
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
                          referencedItems.where(
                            (e) => e.documentId == item.localId,
                          ),
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
        $_aliasNameGenerator(db.documentTags.documentId, db.documents.localId),
      );

  $DocumentsProcessedTableManager get documentId {
    final $_column = $_itemColumn<int>('document_id')!;

    final manager = $DocumentsTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.localId.sqlEquals($_column));
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
      getReferencedColumn: (t) => t.localId,
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
      getReferencedColumn: (t) => t.localId,
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
      getReferencedColumn: (t) => t.localId,
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
                                    .localId,
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
      required String userMemo,
      required String aiSummary,
      Value<int> rowid,
    });
typedef $DocumentsFtsUpdateCompanionBuilder =
    DocumentsFtsCompanion Function({
      Value<String> title,
      Value<String> category,
      Value<String> userMemo,
      Value<String> aiSummary,
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

  ColumnFilters<String> get userMemo => $composableBuilder(
    column: $table.userMemo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
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

  ColumnOrderings<String> get userMemo => $composableBuilder(
    column: $table.userMemo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
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

  GeneratedColumn<String> get userMemo =>
      $composableBuilder(column: $table.userMemo, builder: (column) => column);

  GeneratedColumn<String> get aiSummary =>
      $composableBuilder(column: $table.aiSummary, builder: (column) => column);
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
                Value<String> userMemo = const Value.absent(),
                Value<String> aiSummary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsFtsCompanion(
                title: title,
                category: category,
                userMemo: userMemo,
                aiSummary: aiSummary,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String title,
                required String category,
                required String userMemo,
                required String aiSummary,
                Value<int> rowid = const Value.absent(),
              }) => DocumentsFtsCompanion.insert(
                title: title,
                category: category,
                userMemo: userMemo,
                aiSummary: aiSummary,
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
  $AppSettingsTableManager get appSettings =>
      $AppSettingsTableManager(_db, _db.appSettings);
  $DocumentsTableManager get documents =>
      $DocumentsTableManager(_db, _db.documents);
  $TagsTableManager get tags => $TagsTableManager(_db, _db.tags);
  $DocumentTagsTableManager get documentTags =>
      $DocumentTagsTableManager(_db, _db.documentTags);
  $DocumentsFtsTableManager get documentsFts =>
      $DocumentsFtsTableManager(_db, _db.documentsFts);
}
