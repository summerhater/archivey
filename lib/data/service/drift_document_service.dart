import 'package:archivey/data/drift/app_database.dart';
import 'package:archivey/data/dto/document_with_tags.dart';
import 'package:archivey/data/mapper/document_mapper.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:drift/drift.dart';

class DriftDocumentService {
  final AppDatabase _db;

  DriftDocumentService(this._db);

  /**
   * Create
   */

  /// 사용자가 처음 로그인하면 기본값 생성, 아니면 무시
  Future<void> ensureUserSettings(String uid) async{
    await _db.ensureUserSettings(uid);
  }


  /// Local DB에 Document와 Tag 저장 후 연결, PK 필요 없음
  Future<void> createDocument(DocumentModel document) async {
    await _db.runTransaction(() async {
      // document 저장
      final documentId = await _db.insertDocument(
        document.toDocumentCompanion(sync: SyncStatus.pending),
      );

      // tag 저장
      for (int tagId in await insertOrGetTagIds(document.tags, document.uid)) {
        // 연결된 테이블에 저장
        await _db.insertDocumentTag(
          DocumentTagsCompanion(
            documentId: Value(documentId),
            tagId: Value(tagId),
          ),
        );
      }
    });
  }

  /// Insert or Update Tag -> 기본적으론 INSERT, PK 또는 UNIQUE 충돌 시 UPDATE -> N+1 때문에 안씀
  // Future<List<int>> insertOnConflictUpdateTag(List<String>? getTags) async {
  //   final List<String> tags = getTags ?? [];
  //   List<int> result = [];
  //   if (tags.isNotEmpty) {
  //     for (String tag in tags) {
  //       final TagsCompanion tagCompanion = TagsCompanion(name: Value(tag));
  //       // tag update
  //       await _db.insertOnConflictUpdateTag(tagCompanion);
  //
  //       final TagEntity entity = await isExistTag(
  //         tag,
  //       ); // Insert는 id가 반환되지만, Update는 id가 반환되지 않으므로 DB에 반영됐는지 확인
  //
  //       result.add(entity.id);
  //     }
  //   }
  //   return result;
  // }

  /// 태그 저장 후 저장한 tagId 반환, 업데이트에도 사용(중복 태그는 무시함)
  Future<List<int>> insertOrGetTagIds(List<String> tags, String uid) async {
    if (tags.isEmpty) return [];
    for (String tag in tags) {
      await _db.insertOrGetTagId(tag, uid);
    }

    final entities = await _db.getTagsByNames(tags);

    return entities.map((e) => e.id).toList();
  }

  /**
   * Read
   */

  /// local Sync Time 가져오기
  Future<DateTime> getSyncTime(String uid) async{
    return await _db.getSyncTime(uid);
  }
  
  /// local db에서 pending인 값 가져오기
  Future<List<DocumentWithTags>> getPendingDocuments(String uid) async {
    return _db.getPendingDocuments(uid);
  }

  /// 모든 Document 가져오기
  Stream<List<DocumentModel>> watchAllDocuments(
    List<CategoryModel> categories,
    String uid,
  ) {
    return _db.watchAllDocuments(uid).map((docs) {
      return docs.map((doc) => doc.toDomain(categories:categories,)).toList();
    });
  }

  /// 현재 선택된 document의 tag들을 전부 가져옴
  Future<List<String>> getTagsByDocumentId(int localId) async {
    return await _db.getTagsByDocumentId(localId);
  }

  /// 검색
  Stream<List<DocumentModel>> searchDocuments(
    String keyword,
    List<CategoryModel> categories,
    String uid,
  ) {
    return _db.searchAll(keyword, uid).map((docs) {
      return docs.map((doc) => doc.toDomain(categories: categories,)).toList();
    });
  }

  /**
   * Update
   */
  
  /// Sync Time 현재 시각으로 변경
  Future<void> setSyncTime(String uid) async{
    await _db.setSyncTime(uid);
  }

  /// Sync Update -> 없으면 create, 있으면 update
  Future<void> syncUpdate(DocumentModel document) async {
    _db.transaction(() async{

      final localId = await _db.pullSyncUpdate(
        document.toDocumentCompanion(sync: SyncStatus.synced),
      );

      await _syncTags(localId, document.tags, document.uid);
    });
  }

  /// Sync 후, pending 값을 synced로 바꾸기
  Future<void> syncStatusUpdate(DocumentWithTags dt) async {
    final localId = await _db.getLocalIdById(dt.documentEntity.id);

    await _db.updateDocument(localId: localId!, companion: dt.toDocumentCompanion(SyncStatus.synced.name));
  }

  /// Update Document
  Future<void> updateDocument(DocumentModel doc) async {
    await _db.transaction(() async {
      // documentId로 localId 조회
      final localId = await _db.getLocalIdById(doc.id);

      if (localId == null) {
        throw Exception("문서 찾을 수 없음. ID: ${doc.id}");
      }
      // document update
      await _db.updateDocument(
        companion: doc.toDocumentCompanion(sync: SyncStatus.pending),
        localId: localId,
      );

      // 기존 tag 목록 조회 후 변경
      await _syncTags(localId, doc.tags, doc.uid);
    });
  }

  /// Tag Diff, tag의 이전 상태와 현재 상태 차이 계산 후 업데이트
  Future<void> _syncTags(int localId, List<String> newTags, String uid) async {
    // 현재 저장되있는 tag들 가져오기
    final oldTags = await getTagsByDocumentId(localId);

    // 새로운 태그에서, 예전 태그들을 제거하고 남은 것들은 저장
    final toInsert = newTags.toSet().difference(oldTags.toSet());
    // 옛 태그들중, 새로운 태그에 없는 것들은 삭제
    final toDelete = oldTags.toSet().difference(newTags.toSet());

    // 추가할 태그가 있으면 실행
    if (toInsert.isNotEmpty) {
      final ids = await insertOrGetTagIds(toInsert.toList(), uid);

      for (final tagId in ids) {
        await _db.insertDocumentTag(
          DocumentTagsCompanion(
            documentId: Value(localId),
            tagId: Value(tagId),
          ),
        );
      }
    }

    // 삭제할 태그가 있으면 실행
    if (toDelete.isNotEmpty) {
      await _db.deleteTagsInDocumentTags(localId, toDelete.toList());
    }
  }

  /// remote db에 업로드 후, SyncStatus 값 변경
  Future<void> remoteUploadDone(DocumentModel doc) async{

    _db.transaction(() async{
      await _db.transaction(() async {
        // documentId로 localId 조회
        final localId = await _db.getLocalIdById(doc.id);

        if (localId == null) {
          throw Exception("문서 찾을 수 없음. ID: ${doc.id}");
        }
        // document update
        await _db.updateDocument(
          companion: doc.toDocumentCompanion(sync: SyncStatus.synced),
          localId: localId,
        );
      });
    });

  }

  /**
   *  Delete
   */

  /// Sync Delete -> 없으면 아무일도 일어나지 않음, 있으면 delete
  Future<void> syncDelete(String docId) async {
    final localId = await _db.getLocalIdById(docId);
    if (localId == null) return;
    await _db.deleteDocument(localId);
  }

  /// Document Delete
  Future<void> deleteDocument(String docId) async {
    await _db.transaction(() async {
      final localId = await _db.getLocalIdById(docId);
      print('local id: $localId');

      if (localId == null) {
        throw Exception("업데이트 문서 찾을 수 없음. ID: $docId");
      }

      await _db.deleteDocument(localId);
    });
  }
}
