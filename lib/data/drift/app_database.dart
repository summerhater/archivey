import 'dart:io';

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
   * Create Data
   */

  /// Insert Document
  Future<int> insertDocument(DocumentsCompanion companion) {
    return into(documents).insert(companion);
  }

  /// Insert Or Update Tag -> 따로 Update 만들 필요 없음
  /// tags는 List형태라 Service layer에서 for in으로 반복 작업 해줘야 함
  Future<int> insertOnConflictUpdateTag(TagsCompanion companion) {
    return into(tags).insertOnConflictUpdate(companion);
  }

  /// 연결 테이블인 DocumentTag에 Insert
  Future<void> insertDocumentTag(DocumentTagsCompanion companion) {
    return into(documentTags).insert(companion);
  }

  /**
   * Read Data
   */

  /// Select All Document 전부 읽기
  Future<List<DocumentEntity>> selectAllDocument() {
    return select(documents).get();
  }

  /// Stream 형태로 Select All Document 전부 읽기

  /// Select All Tag 전부 읽기
  Future<List<TagEntity>> selectAllTag() {
    return select(tags).get();
  }

  /// Select One Document 하나 읽기, 상세보기 페이지 들어갈 때 사용
  Future<DocumentEntity> selectOneDocument(int id) {
    return (select(documents)..where(
          (tbl) => tbl.id.equals(id),
        ))
        .getSingle();
  }

  /// tag 받아서 존재 여부 확인 후 해당 태그 반환, tag update 시 사용 TODO 이름 바꿔주는게 나을까? isExistTag 같은거?
  Future<TagEntity> selectOneTag(String tag) {
    return (select(tags)..where(
          (tbl) => tbl.name.equals(tag),
        ))
        .getSingle();
  }

  /**
   * Update Data
   */

  /// Document Update
  Future<bool> updateDocument(DocumentEntity entity) {
    return update(documents).replace(entity);
  }

  /**
   * Delete Data
   */

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
