import 'dart:io';

import 'package:archivey/data/dto/document_with_tags.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(
  include: {'table/tables.drift'},
) // TODO 트러블슈팅 include는 drift 파일 경로까지 적어줘야 한다
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /**
   * Create
   */

  /// Insert Document, UUID로 pk인 document id를 지정해줄 것이기 때문에, return은 필요 없음
  Future<void> insertDocument(DocumentsCompanion companion) async {
    await into(documents).insert(companion);
  }

  /// Insert Or Update Tag -> 따로 Update 만들 필요 없음
  /// tags는 List형태라 Service layer에서 for in으로 반복 작업 해줘야 함
  Future<int> insertOnConflictUpdateTag(TagsCompanion companion) async {
    return await into(tags).insertOnConflictUpdate(companion);
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
      LEFT JOIN document_tags dt ON dt.document_id = d.id
      LEFT JOIN tags t ON t.id = dt.tag_id
      GROUP BY d.id
      ORDER BY d.create_at DESC
      ''',
      readsFrom: {documents, documentTags, tags},
    );

    return query.watch().map((rows) {
      return rows.map((row) {
        return DocumentWithTags(
          documentEntity: documents.map(row.data),
          tags: (row.read<String>('tags')).split(',').where((e) => e.isNotEmpty).toList(),
        );
      }).toList();
    });
  }

  /// tag names 받아서 전부 조회 후 반환
  Future<List<TagEntity>> getTagsByNames(List<String> names) async {
    return await (select(tags)..where((tbl) => tbl.name.isIn(names))).get();
  }

  /// Document Id 사용해서 Tag 조회
  Future<List<TagEntity>> getTagsByDocumentId(String id) async {
    final query = customSelect(
      '''
      SELECT GROUP_CONCAT(t.name) AS tags
      FROM documents d
      LEFT JOIN document_tags dt ON dt.document_id = d.id
      LEFT JOIN tags t ON t.id = dt.tag_id
      GROUP BY d.id
      ''',
      readsFrom: {documents, documentTags, tags},
    );

    final rows = await query.get();

    final result = rows.map((e) {
      return TagEntity.fromJson(e.data);
    }).toList();

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
      JOIN documents_fts fts ON fts.rowid = d.id
      LEFT JOIN document_tags dt ON dt.document_id = d.id
      LEFT JOIN tags t ON t.id = dt.tag_id
      WHERE fts MATCH ? OR t.name LIKE ?
      GROUP BY d.id
      ORDER BY d.create_at DESC
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
          tags: (row.read<String>('tags')).split(',').where((e) => e.isNotEmpty).toList(),
        );
      }).toList();
    });
  }

  /**
   * Update
   */

  /// Document Entity 업데이트
  Future<bool> updateDocument({
    required DocumentsCompanion companion,
    required String id,
  }) async {
    return await (update(documents)..where(
          (tbl) => tbl.id.equals(id),
        ))
        .replace(companion);
  }

  /**
   * Delete
   */

  /// Document 삭제, cascade로 연결해둔 DocumentTags는 자동으로 삭제됨, Tag는 그대로 둠
  Future<void> deleteDocument(String id) async {
    await (delete(documents)..where(
      (tbl) => tbl.id.equals(id),
    ));
  }

  /// documentTags에 있는 tag 삭제
  Future<void> deleteTagsInDocumentTags(
    String docId,
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
      [docId, ...tagNames],
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

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
