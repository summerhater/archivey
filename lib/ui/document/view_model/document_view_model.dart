import 'package:flutter/material.dart';
import 'package:archivey/data/service/firebase_document_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';

class DocumentViewModel extends ChangeNotifier {
  final FirebaseDocumentService _documentService;
  DocumentViewModel(this._documentService){
   readDocuments();
  }

  List<DocumentModel> _documents = [];
  List<DocumentModel> get documents => _documents;
  DocumentModel? _document;
  DocumentModel? get document => _document;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isRetrying = false;

  // 초기 데이터 로드
  Future<void> readDocuments() async {
    _isLoading = true;
    notifyListeners();

    _documents = await _documentService.readDocuments();

    _isLoading = false;
    notifyListeners();
  }

  List<DocumentModel> getDocumentsByCategoryId(String categoryId) {
    return _documents.where((doc) => doc.category.categoryId == categoryId).toList();
  }

  Future<void> updateDocument(DocumentModel docToUpdate) async {
    await _documentService.updateDocument(docToUpdate);
    final index = _documents.indexWhere((d) => d.id == docToUpdate.id);
    if (index != -1) {
      _documents[index] = docToUpdate;
    }
    notifyListeners();
  }

  /// 수집물 추가 프로세스
  Future<void> addDocumentProcess({
    required String sharedURL,
    required String sharedURLCaptionText,
    required CategoryModel category,
    String? memo,
  }) async {
    print('sharedURL: $sharedURL');
    print('sharedURLCaptionText: $sharedURLCaptionText');
    /// 1. 스크래핑 (Step 1)
    final (newDoc, contentText) = await _documentService.scrapeUrlAndPrepare(sharedURL, sharedURLCaptionText, category, memo);

    /// 2. 서비스에 1차 저장 (분석 중 상태)
    await _documentService.createDocument(newDoc);

    /// 3. UI 갱신을 위해 리스트 다시 불러오기
    await readDocuments();

    /// 4. AI 요약 실행 (Step 2 : 백그라운드에서 실행)
    _runAiAnalysis(newDoc, contentText);
  }

  
  Future<void> _runAiAnalysis(DocumentModel doc, String contentText) async {
    try {
      final updatedDoc = await _documentService.getAiSummary(
        document: doc,
        contentText: contentText,
      );

      await _documentService.updateDocument(updatedDoc);
      await readDocuments();
    } catch (e) {
      debugPrint("AI 분석 업데이트 실패: $e");
    }
  }

  Future<void> retryAiAnalysis(DocumentModel document) async {
    if (_isRetrying) return;

    _isRetrying = true;

    try {
      /// 1. 상태 변경
      await _documentService.updateDocument(
        document.copyWith(aiStatus: AiTaskStatus.analyzing),
      );
      await readDocuments();

      /// 2. 스크래핑 (contentText만 사용)
      final (_, contentText) = await _documentService.scrapeUrlAndPrepare(
        document.url,
        '',
        document.category,
        document.userMemo,
      );

      // 3. 최신 문서 기준으로 AI 실행
      // final latestDoc =
      // await _documentService.fetchDocumentById(document.id);

      final updatedDoc = await _documentService.getAiSummary(
        document: document,
        contentText: contentText,
      );

      /// 4. 결과 저장
      await _documentService.updateDocument(updatedDoc);
      await readDocuments();
    } catch (e) {
      debugPrint('AI 재시도 실패: $e');

      await _documentService.updateDocument(
        document.copyWith(aiStatus: AiTaskStatus.failed),
      );
      await readDocuments();
    } finally {
      _isRetrying = false;
    }
  }

  Future<void> deleteDocument(String id) async {
    await _documentService.deleteDocument(id);
    await readDocuments();
  }
}