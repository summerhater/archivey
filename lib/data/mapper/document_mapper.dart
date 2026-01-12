import 'package:archivey/data/drift/app_database.dart';
import 'package:archivey/data/dto/document_with_tags.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:drift/drift.dart';

extension DocumentDomainToCompanion on DocumentModel {
  /// Domain Model -> Companion, DB에 저장하기 위한 타입, 타입 안정성을 위해 변환해서 저장
  DocumentsCompanion toDocumentCompanion({required SyncStatus sync}) {
    return DocumentsCompanion(
      uid: Value(uid),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(sync.name),
      title: Value(title),
      url: Value(url),
      imageUrl: Value(imageUrl),
      category: Value(category.categoryId),
      platform: Value(platform),
      userMemo: Value(userMemo),
      aiSummary: Value(aiSummary),
      aiStatus: Value(aiStatus.name),
    );
  }
}

extension DocumentWithTagsToDomain on DocumentWithTags {
  /// enum type인 aiStatus를 반환하기 위한 formatting
  AiTaskStatus _getAiTaskStatus() {
    return AiTaskStatus.values.byName(documentEntity.aiStatus);
  }

  /// Category Id만 갖고 있는 것을 Category 객체로 변환
  CategoryModel _getCategory(List<CategoryModel> list) {
    late CategoryModel category;

    for(var i in list) {
      if(i.categoryId == documentEntity.category) category = i;
    }

    return category;
  }

  /// DTO Model을 Domain Model로 변환해 VM에 전달해주기 위함
  DocumentModel toDomain({required List<CategoryModel> list}) {
    return DocumentModel(
      uid: documentEntity.uid,
      id: documentEntity.id,
      createdAt: documentEntity.createdAt,
      updatedAt: documentEntity.updatedAt,
      title: documentEntity.title,
      url: documentEntity.url,
      imageUrl: documentEntity.imageUrl,
      tags: tags,
      category: _getCategory(list),
      platform: documentEntity.platform,
      userMemo: documentEntity.userMemo,
      aiSummary: documentEntity.aiSummary,
      aiStatus: _getAiTaskStatus(),
    );
  }
}