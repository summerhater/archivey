import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:flutter/material.dart';

class SharedWebState extends ChangeNotifier {
  String? _ownerUid;         /// 공유한 사람 uid
  String? _shareId;          /// 공유 링크 자체 id
  CategoryModel? _category;
  List<DocumentModel> _documents = [];

  String? get ownerUid => _ownerUid;
  CategoryModel? get category => _category;
  List<DocumentModel> get documents => _documents;

  // 초기화 메서드 (Route 진입 시 호출)
  Future<void> initialize(String shareId) async {
    _shareId = shareId;

    // 1. shareId를 통해 ownerUid와 categoryId를 가져오는 서비스 호출
    // 예: final linkInfo = await _service.getLinkInfo(shareId);
    // _ownerUid = linkInfo.ownerUid;

    // 2. 이후 ownerUid를 기반으로 실시간 데이터 구독 시작
    // _listenToOriginalData();
  }

  void setOwnerUid(String? ownerUid) {
    _ownerUid = _ownerUid ?? '';
    notifyListeners();
  }

  void setShareId(String? shareId) {
    _shareId = _shareId ?? '';
    notifyListeners();
  }

  void setCategory(CategoryModel sharedCategory) {
    _category = sharedCategory;
    notifyListeners();
  }

  void setDocuments(List<DocumentModel> sharedDocuments) {
    _documents = sharedDocuments;
    notifyListeners();
  }
}