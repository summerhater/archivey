import 'dart:async';

import 'package:archivey/data/service/drift_document_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class DriftExampleViewModel extends ChangeNotifier{
  
  final DriftDocumentService _driftDocumentService = DriftDocumentService();

  var uuid = Uuid();

  List<CategoryModel> categories = [];

  StreamSubscription <List<DocumentModel>>? _subscription;

  List<DocumentModel> documents = [];

  final _searchQueryController = BehaviorSubject<String>.seeded('');

  /**
   * Test
   */
  
  /// read document, categories 넘겨줘야 함
  /// stream으로 document를 받아오고, 그것들을 받아올 때마다 List에 추가 후 view 갱신
  /// view에서는 List를 보면 됨
  void watchDocument() {
    // return _driftDocumentService.watchAllDocuments(categories);

    _subscription?.cancel();

    _subscription = _searchQueryController.stream.switchMap((keyword) {
      if(keyword.isEmpty) {
        return _driftDocumentService.watchAllDocuments(categories);
      } else {
        return _driftDocumentService.searchDocuments(keyword, categories);
      }
    }).listen((data) {
      documents = data;
      notifyListeners();
    });
  }

  /// create document -> uid, 카테고리 필요
  Future<void> createDocument() async {
    // final doc = DocumentModel(
    //     uid: user!.uid,
    //     id: uuid.v7(), // v7? v4?
    //     createdAt: DateTime.now(),
    //     category: categories[1],
    //     url: 'url3',
    //     aiStatus: AiTaskStatus.completed,
    //     tags: ['맛집', '', 'zxcv'],
    //     platform: 'YouTube',
    //     title: 'test1',
    //     aiSummary: 'ai 요약이에요',
    //     imageUrl: 'image2',
    //     userMemo: '유저가 작성한 메모'
    // );
    //
    // await _driftDocumentService.createDocument(doc);
  }

  /// update document, uid와 카테고리 필요
  Future<void> updateDocument() async {
    // print('#########################updateDocument start');
    // final doc = DocumentModel(
    //     uid: user!.uid,
    //     id: '019b947f-a97c-704c-883d-c69dddc5594c',
    //     createdAt: DateTime.now(),
    //     category: categories[1],
    //     url: 'url2',
    //     aiStatus: AiTaskStatus.completed,
    //     tags: ['wwww', 'eeee'],
    //     platform: 'YouTube',
    //     title: 'title2',
    //     aiSummary: 'summary2',
    //     imageUrl: 'image2',
    //     userMemo: 'memo2'
    // );
    //
    // await _driftDocumentService.updateDocument(doc);

  }

  /// delete document
  Future<void> deleteDocument() async {
    final id = '019b947f-a97c-704c-883d-c69dddc5594c';
    await _driftDocumentService.deleteDocument(id);
  }

  /// search -> search button에 이 함수를 달면, 위의 read의 query문이 바뀌어서 검색이 됨
  void search({required String keyword, required String categoryId}) {
    _searchQueryController.add(keyword, );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}