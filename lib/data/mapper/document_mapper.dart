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
  CategoryModel _getCategory(List<CategoryModel> categories) {
    print('############### 현재 카테고리는 ${categories.length}개 ###################');
    return categories.firstWhere(
      (category) => category.categoryId == documentEntity.category,
      orElse: () {
        if(categories.isNotEmpty) {
          categories.first;
        }

        return CategoryModel(uid: documentEntity.uid, categoryId: '0000', categoryName: '미분류');
      }
    );
  }

  /// DTO Model을 Domain Model로 변환해 VM에 전달해주기 위함
  DocumentModel toDomain({required List<CategoryModel> categories}) {
    return DocumentModel(
      uid: documentEntity.uid,
      id: documentEntity.id,
      createdAt: documentEntity.createdAt,
      updatedAt: documentEntity.updatedAt,
      title: documentEntity.title,
      url: documentEntity.url,
      imageUrl: documentEntity.imageUrl,
      tags: tags,
      category: _getCategory(categories),
      platform: documentEntity.platform,
      userMemo: documentEntity.userMemo,
      aiSummary: documentEntity.aiSummary,
      aiStatus: _getAiTaskStatus(),
    );
  }

  DocumentsCompanion toDocumentCompanion(String syncStatus) {
    return DocumentsCompanion(
      uid: Value(documentEntity.uid),
      id: Value(documentEntity.id),
      createdAt: Value(documentEntity.createdAt),
      updatedAt: Value(DateTime.now()),
      syncStatus: Value(syncStatus),
      title: Value(documentEntity.title),
      url: Value(documentEntity.url),
      imageUrl: Value(documentEntity.imageUrl),
      category: Value(documentEntity.category),
      platform: Value(documentEntity.platform),
      userMemo: Value(documentEntity.userMemo),
      aiSummary: Value(documentEntity.aiSummary),
      aiStatus: Value(documentEntity.aiStatus),
    );
  }
}