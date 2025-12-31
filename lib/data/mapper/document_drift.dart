import 'package:archivey/data/drift/app_database.dart';
import 'package:archivey/domain/model/document.dart';
import 'package:drift/drift.dart';

extension DocumentDomainToEntity on Document {
  /// Domain Model -> Entity Model
  DocumentEntity toEntity() {
    return DocumentEntity(
      id: driftId!,
      createAt: createAt,
      title: title,
      linkUrl: linkUrl,
      imgUrl: imgUrl,
      category: category,
      platform: platform,
    );
  }
}

extension DocumentEntityToDomain on DocumentEntity {
  /// Entity Model -> Domain Model
  Document toDomain() {
    return Document(
      driftId: id,
      createAt: createAt,
      title: title,
      linkUrl: linkUrl,
      imgUrl: imgUrl,
      category: category,
      platform: platform,
      memo: memo,
      summary: summary,
    );
  }
}

extension DocumentDomainToCompanion on Document {
  /// Domain Model -> Companion, DB에 저장하기 위한 타입, 타입 안정성을 위해 변환해서 저장
  DocumentsCompanion toDocumentCompanion() {
    return DocumentsCompanion(
      title: Value(title),
      linkUrl: Value(linkUrl),
      imgUrl: Value(imgUrl),
      category: Value(category),
      platform: Value(platform),
      memo: Value(memo),
      summary: Value(summary),
    );
  }
}