// import 'dart:io';

import 'package:archivey/data/dto/document_with_tags.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
import 'package:archivey/data/drift/connection/connection.dart'
  if (dart.library.io) 'connection/native.dart'
  if (dart.library.js_interop) 'connection/web.dart';

part 'app_database.g.dart';

@DriftDatabase(
  include: {'table/tables.drift'},
) // TODO 트러블슈팅 include는 drift 파일 경로까지 적어줘야 한다
class AppDatabase extends _$AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();

  AppDatabase._internal() : super(openConnection());
  // AppDatabase._internal() : super(_openConnection());
  // AppDatabase() : super(_openConnection());

  factory AppDatabase() => instance;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migration) async{
      await migration.createAll();

      await into(appSettings).insert(
        AppSettingsCompanion.insert(
          lastSyncTime: Value(DateTime.fromMillisecondsSinceEpoch(0)),
        ),
      );
    }
  );

  /**
   * Sync
   */

  /// 마지막 Sync 실행한 시간 받아오기
  Future<DateTime> getSyncTime() async {
    final setting = await select(appSettings).getSingle();

    return setting.lastSyncTime ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Sync 실행한 시점의 시간 저장
  Future<void> setSyncTime() async {
    await (update(appSettings)).write(
      AppSettingsCompanion(lastSyncTime: Value(DateTime.now())),
    );
  }

  /// Sync Update(없으면 create, 있으면 update)
  Future<int> pullSyncUpdate(DocumentsCompanion companion) async {
    // await into(documents).insertOnConflictUpdate(companion);
    await customInsert(
      '''
      INSERT INTO documents (
        id, uid, created_at, updated_at, sync_status,
        category, user_memo, title, url, image_url,
        platform, ai_summary, ai_status
      ) VALUES (
        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
      )
      ON CONFLICT(id) DO UPDATE SET
        uid = excluded.uid,
        created_at = excluded.created_at,
        updated_at = excluded.updated_at,
        sync_status = excluded.sync_status,
        category = excluded.category,
        user_memo = excluded.user_memo,
        title = excluded.title,
        url = excluded.url,
        image_url = excluded.image_url,
        platform = excluded.platform,
        ai_summary = excluded.ai_summary,
        ai_status = excluded.ai_status
      ''',
      variables: [
        Variable<String>(companion.id.value),
        Variable<String>(companion.uid.value),
        Variable<DateTime>(companion.createdAt.value),
        Variable<DateTime>(companion.updatedAt.value),
        Variable<String>(companion.syncStatus.value),
        Variable<String>(companion.category.value),
        Variable<String>(companion.userMemo.value),
        Variable<String>(companion.title.value),
        Variable<String>(companion.url.value),
        Variable<String>(companion.imageUrl.value),
        Variable<String>(companion.platform.value),
        Variable<String>(companion.aiSummary.value),
        Variable<String>(companion.aiStatus.value),
      ],
      updates: {documents},
    );

    final row = await customSelect(
      'SELECT local_id FROM documents WHERE id = ?',
      variables: [Variable(companion.id.value)],
    ).getSingle();

    return row.read<int>('local_id');
  }

  /// Push Sync, 모종의 이유로 싱크가 되지 않은 데이터들을 remote에 업로드하기 위함
  Future<List<DocumentWithTags>> getPendingDocuments() async {
    // final documents = await (select(documents)..where((tbl) => tbl.syncStatus.equals(SyncStatus.pending.name),)).get();

    final query = customSelect(
      '''
      SELECT d.*, GROUP_CONCAT(t.name) AS tags
      FROM documents d
      LEFT JOIN document_tags dt ON dt.document_id = d.local_id
      LEFT JOIN tags t ON t.id = dt.tag_id
      WHERE d.sync_status LIKE ?
      GROUP BY d.id
      ORDER BY d.created_at DESC
      ''',
      variables: [Variable.withString(SyncStatus.pending.name)],
      readsFrom: {documents, documentTags, tags},
    );

    final rows = await query.get();

    return rows.map(
      (row) {
        return DocumentWithTags(
          documentEntity: documents.map(row.data),
          tags: (row.read<String?>('tags') ?? '')
              .split(',')
              .where((e) => e.isNotEmpty)
              .toList(),
        );
      },
    ).toList();
  }

  /**
   * Create
   */

  /// Insert Document
  Future<int> insertDocument(DocumentsCompanion companion) async {
    return await into(documents).insert(companion);
  }

  /// Insert Or Update Tag -> 따로 Update 만들 필요 없음
  /// tags는 List형태라 Service layer에서 for in으로 반복 작업 해줘야 함
  Future<int> insertOrGetTagId(String name) async {
    // return await into(tags).insertOnConflictUpdate(companion); // tag name이 unique 인데, id로 업데이트 하고 있어서 중복 값이 들어감. 그러면 중복 값이 들어가니 unique 에서 오류
    await into(tags).insert(
      TagsCompanion(name: Value(name)),
      mode: InsertMode.insertOrIgnore,
    ); // 이 코드는 insert가 안되면 항상 0을 return, 오류 발생할 수 있음

    final tag =
        await (select(tags)..where(
              (tbl) => tbl.name.equals(name),
            ))
            .getSingle();

    return tag.id;
  }

  /// 연결 테이블인 DocumentTags에 Insert
  Future<void> insertDocumentTag(DocumentTagsCompanion companion) async {
    await into(documentTags).insert(companion);
  }

  /**
   * Read
   */

  /// Document Entity와 Tag Entity가 결합한 DTO를 반환, Stream은 async 필요 없음
  Stream<List<DocumentWithTags>> watchAllDocuments() {
    final query = customSelect(
      '''
      SELECT d.*, GROUP_CONCAT(t.name) AS tags
      FROM documents d
      LEFT JOIN document_tags dt ON dt.document_id = d.local_id
      LEFT JOIN tags t ON t.id = dt.tag_id
      GROUP BY d.id
      ORDER BY d.created_at DESC
      ''',
      readsFrom: {documents, documentTags, tags},
    );

    return query.watch().map((rows) {
      return rows.map((row) {
        return DocumentWithTags(
          documentEntity: documents.map(row.data),
          tags: (row.read<String?>('tags',) ??  '')
              .split(',')
              .where((e) => e.isNotEmpty)
              .toList(),
        );
      }).toList();
    });
  }

  /// tag names 받아서 전부 조회 후 반환
  Future<List<TagEntity>> getTagsByNames(List<String> names) async {
    return await (select(tags)..where((tbl) => tbl.name.isIn(names))).get();
  }

  /// Local Id 사용해서 Tag 조회
  Future<List<String>> getTagsByDocumentId(int localId) async {
    final query = customSelect(
      '''
      SELECT GROUP_CONCAT(t.name) AS tags
      FROM documents d
      LEFT JOIN document_tags dt ON dt.document_id = d.local_id
      LEFT JOIN tags t ON t.id = dt.tag_id
      WHERE d.local_id LIKE ?
      GROUP BY d.id
      ''',
      variables: [Variable.withInt(localId)],
      readsFrom: {documents, documentTags, tags},
    );

    final rows = await query.get();

    final result = rows
        .map((e) => e.data['tags'] as String?)
        .where((e) => e != null && e.isNotEmpty)
        .expand((e) => e!.split(','))
        .toList();

    return result;
  }

  /// 검색 기능. 입력받은 String값은 fts에서 유사 검색, tag에서는 일치하는것만 return
  Stream<List<DocumentWithTags>> searchAll(String keyword) {
    if (keyword.trim().isEmpty) {
      return watchAllDocuments();
    }

    final ftsQuery = '$keyword*';
    final tagQuery = '%$keyword%';

    final query = customSelect(
      '''
      SELECT d.*, GROUP_CONCAT(t.name) AS tags
      FROM documents d
      JOIN documents_fts fts ON fts.rowid = d.local_id
      LEFT JOIN document_tags dt ON dt.document_id = d.local_id
      LEFT JOIN tags t ON t.id = dt.tag_id
      WHERE d.local_id IN (
        SELECT rowid FROM documents_fts WHERE documents_fts MATCH ?
        UNION
        SELECT dt2.document_id
        FROM document_tags dt2
        JOIN tags t2 ON t2.id = dt.tag_id
        WHERE t2.name LIKE ?
      )
      GROUP BY d.id
      ORDER BY d.created_at DESC
      ''',
      variables: [
        Variable.withString(ftsQuery),
        Variable.withString(tagQuery),
      ],
      readsFrom: {documents, documentTags, tags, documentsFts},
    );

    return query.watch().map((rows) {
      return rows.map((row) {
        return DocumentWithTags(
          documentEntity: documents.map(row.data),
          tags: (row.read<String>(
            'tags' ?? '',
          )).split(',').where((e) => e.isNotEmpty).toList(),
        );
      }).toList();
    });
  }

  /// id로 local id 받아오기
  Future<int?> getLocalIdById(String id) async {
    return await (select(documents)..where(
          (tbl) => tbl.id.equals(id),
        ))
        .map((row) => row.localId)
        .getSingleOrNull();
  }

  /**
   * Update
   */

  /// Document Entity 업데이트
  Future<int> updateDocument({
    required DocumentsCompanion companion,
    required int localId,
  }) async {
    return await (update(documents)..where(
          (tbl) => tbl.localId.equals(localId),
        ))
        .write(companion);
  }

  /**
   * Delete
   */

  /// Document 삭제, cascade로 연결해둔 DocumentTags는 자동으로 삭제됨, Tag는 그대로 둠
  Future<void> deleteDocument(int localId) async {
    await delete(documents).delete(DocumentsCompanion(localId: Value(localId)));
  }

  /// documentTags에 있는 tag 삭제
  Future<void> deleteTagsInDocumentTags(
    int localId,
    List<String> tagNames,
  ) async {
    return customStatement(
      '''
      DELETE FROM document_tags
      WHERE document_id = ?
        AND tag_id IN(
          SELECT id FROM tags WHERE name IN (${List.filled(tagNames.length, '?').join(',')})
        )
      ''',
      [localId, ...tagNames],
    );
  }

  /**
   * Transaction
   */

  /// 트랜잭션 실행기
  Future<T> runTransaction<T>(Future<T> Function() action) {
    return transaction(action);
  }
}

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'db.sqlite'));
//
//     return NativeDatabase.createInBackground(file);
//   });
// }
