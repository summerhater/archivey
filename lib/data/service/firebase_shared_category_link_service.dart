import 'package:archivey/domain/model/shared_category_link_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///SharedLinkService 역할
///앱 사용자: 카테고리 공유 시 shareId 생성 및 저장
///웹 방문자: shareId로 원본 정보(ownerUid, categoryId) 조회

class FirebaseSharedCategoryWebService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ///앱 사용자 - 공유 링크 생성
  Future<String> createSharedCategoryLink(String ownerUid, String categoryId) async {
    final String shareId = _db.collection('sharedCategoryLinks').doc().id;

    final newSharedCategoryLink = SharedCategoryLinkModel(
      shareId: shareId,
      ownerUid: ownerUid,
      categoryId: categoryId,
      createdAt: DateTime.now(),
    );

    await _db.collection('sharedCategoryLinks').doc(shareId).set(newSharedCategoryLink.toMap());
    return shareId;
  }

  ///웹 방문자 - shareId로 firestore 문서 가져오기
  Future<SharedCategoryLinkModel?> readSharedCategoryLink(String shareId) async {
    try {
      final doc = await _db.collection('sharedCategoryLinks').doc(shareId).get();
      if (doc.exists && doc.data() != null) {
        return SharedCategoryLinkModel.fromMap(doc.id, doc.data()!);
      } else {
        print('readSharedCategoryLink error : [shareId: $shareId]');
      }
    } catch (e) {
      print('sharedCategoryLinks 조회 에러: $e');
    }
    return null;
  }
}