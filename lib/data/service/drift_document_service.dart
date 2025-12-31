import 'package:archivey/data/drift/app_database.dart';
import 'package:archivey/data/mapper/document_drift.dart';
import 'package:archivey/domain/model/document.dart';
import 'package:drift/drift.dart';

class DriftDocumentService {
  final AppDatabase _db;

  DriftDocumentService(this._db);

  /**
   * Create
   */

  /// Local DB에 Document와 Tag 저장 후 연결, PK 필요 없음
  Future<void> createDocument(Document document) async {
    final DocumentsCompanion docCompanion = document.toDocumentCompanion();
    await _db.runTransaction(() async {
      // document 저장
      final newDocId = await _db.insertDocument(docCompanion);

      for(int tagId in await insertOnConflictUpdateTag(document.tags)){
        await _db.insertDocumentTag(
          DocumentTagsCompanion(
            documentId: Value(newDocId),
            tagId: Value(tagId),
          ),
        );
      }
    });
  }

  /// Insert or Update Tag -> 기본적으론 INSERT, PK 또는 UNIQUE 충돌 시 UPDATE
  Future<List<int>> insertOnConflictUpdateTag(List<String>? getTags) async{
    final List<String> tags = getTags ?? [];
    List<int> result = [];
    if(tags.isNotEmpty) {
      for(String tag in tags){
        final TagsCompanion tagCompanion = TagsCompanion(name: Value(tag));
        // tag update
        await _db.insertOnConflictUpdateTag(tagCompanion);

        final TagEntity entity = await selectOneTag(tag); // Insert는 id가 반환되지만, Update는 id가 반환되지 않으므로 DB에 반영됐는지 확인

        result.add(entity.id);
      }
    }
    return result;
  }

  /**
   * Read
   */

  /// 모든 Document 가져오기
  Future<List<DocumentEntity>> selectAllDocument() async{
    return await _db.selectAllDocument();
  }

  /// 하나의 Document 가져오기
  Future<Document> selectOneDocument(int id) async{
    final DocumentEntity documentEntity;

    documentEntity = await _db.selectOneDocument(id);

    return documentEntity.toDomain();
  }

  /// 태그 존재하는지 확인 후 존재하면 반환
  Future<TagEntity> selectOneTag(String tag) async{
    return await _db.selectOneTag(tag);
  }

  /**
   * Update
   */

  /// Document 업데이트, PK 필요함
  Future<void> updateDocument(Document document) async{
    final int pk = document.driftId ?? (throw Exception('pk lost'));

    _db.transaction(() async{
      /// Document Update
      if(await _db.updateDocument(document.toEntity()) == false) throw Exception('update 실패');

      List<TagEntity> insertOnConflictUpdateTag(document.tags);

    });

  }

  /**
   *  Delete
   */

  Future<void> deleteDocument(int Id) async{

  }

}
