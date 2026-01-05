import 'package:archivey/data/drift/app_database.dart';
import 'package:archivey/data/mapper/document_mapper.dart';
import 'package:archivey/data/service/firebase_category_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:drift/drift.dart';

class DriftDocumentService {
  final AppDatabase _db;
  final FirebaseCategoryService _categoryService;

  DriftDocumentService(this._db, this._categoryService);

  /**
   * Create
   */

  /// Local DB에 Document와 Tag 저장 후 연결, PK 필요 없음
  Future<void> createDocument(DocumentModel document) async {
    await _db.runTransaction(() async {
      // document 저장
      await _db.insertDocument(
        document.toDocumentCompanion(),
      );

      // tag 저장
      for (int tagId in await insertOrGetTagIds(document.tags)) {
        // 연결된 테이블에 저장
        await _db.insertDocumentTag(
          DocumentTagsCompanion(
            documentId: Value(document.id),
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
  Future<List<int>> insertOrGetTagIds(List<String> tags) async {
    if (tags.isEmpty) return [];
    for (String tag in tags) {
      await _db.insertOnConflictUpdateTag(TagsCompanion(name: Value(tag)));
    }

    final entities = await _db.getTagsByNames(tags);

    return entities.map((e) => e.id).toList();
  }

  /**
   * Read
   */

  /// 모든 Document 가져오기
  Stream<List<DocumentModel>> watchAllDocuments(List<CategoryModel> list) {
    return _db.watchAllDocuments().map((docs) {
      return docs.map((doc) => doc.toDomain(list)).toList();
    });
  }
  
  /// 현재 선택된 document의 tag들을 전부 가져옴
  Future<List<String>> getTagsByDocumentId(String id) async{
    final rows = await _db.getTagsByDocumentId(id);
    return rows.map((e) => e.name).toList();
  }

  /**
   * Update
   */

  /// Update Document
  Future<void> updateDocument(DocumentModel doc) async{
    // 1. documents table update
    await _db.updateDocument(companion: doc.toDocumentCompanion(), id: doc.id);
    // 2. 기존 tag 목록 조회
    await _syncTags(doc.id, doc.tags);

    // 3. 새 tag 목록과 diff 계산 -> diff는 오래된 것과 새로운 것을 비교해서 유지 삭제 추가 계산하는 것
    // 4. 추가될 tag -> insert
    // 5. 제거될 tag -> delete
  }

  /// Tag Diff, tag의 이전 상태와 현재 상태 차이 계산 후 업데이트
  Future<void> _syncTags(String docId, List<String> newTags) async {
    // 현재 저장되있는 tag들 가져오기
    final oldTags = await getTagsByDocumentId(docId);
    
    // 새로운 태그에서, 예전 태그들을 제거하고 남은 것들은 저장
    final toInsert = newTags.toSet().difference(oldTags.toSet());
    // 옛 태그들중, 새로운 태그에 없는 것들은 삭제
    final toDelete = oldTags.toSet().difference(newTags.toSet());

    // 추가할 태그가 있으면 실행
    if(toInsert.isNotEmpty) {
      final ids = await insertOrGetTagIds(toInsert.toList());

      for (final tagId in ids) {
        await _db.insertDocumentTag(
          DocumentTagsCompanion(
            documentId: Value(docId),
            tagId: Value(tagId),
          ),
        );
      }
    }
    
    // 삭제할 태그가 있으면 실행
    if(toDelete.isNotEmpty){
      await _db.deleteTagsInDocumentTags(docId, toDelete.toList());
    }
  }

  /**
   *  Delete
   */

  /// Document Delete
  Future<void> deleteDocument(String id) async{
    await _db.deleteDocument(id);
  }
}
