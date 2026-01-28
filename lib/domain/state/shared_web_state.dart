import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';

class SharedWebState extends ChangeNotifier {
  String _ownerUid = '';         /// 공유한 사람 uid
  String _shareId = '';          /// 공유 링크 자체 id
  String _categoryId = '';
  List<DocumentModel> _documents = [];

  String get ownerUid => _ownerUid;
  String get shareId => _shareId;
  String get categoryId => _categoryId;
  List<DocumentModel> get documents => _documents;

  SharedWebState(){
    print('create SharedWebState');
  }

  set ownerUid(String? ownerUid) {
    // throw 대신 기본값 처리 또는 null 허용
    _ownerUid = ownerUid ?? '';
  }

  set shareId(String? shareId) {
    if (shareId == null || shareId.isEmpty) {
      throw ArgumentError('shareId not be null or empty');
    }
    _shareId = shareId;
  }

  set categoryId(String? categoryId) {
    _categoryId = categoryId ?? '';
  }

  set documents(List<DocumentModel> documents) {
    if (documents.isEmpty) {
      _documents = [];
    }
    _documents = documents;
  }
}