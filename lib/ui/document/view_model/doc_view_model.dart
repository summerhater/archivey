import 'dart:async';

import 'package:archivey/data/mapper/document_mapper.dart';
import 'package:archivey/data/service/drift_document_service.dart';
import 'package:archivey/data/service/firebase_document_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/ui/auth/view_model/auth_view_model.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DocViewModel extends ChangeNotifier {
  final FirebaseDocumentService _firebaseDocumentService;
  final DriftDocumentService _driftDocumentService;
  final CategoryViewModel _categoryViewModel;
  final AuthViewModel _authViewModel;

  DocViewModel(
    this._firebaseDocumentService,
    this._driftDocumentService,
    this._categoryViewModel,
    this._authViewModel,
  ) {
    _categoryViewModel.addListener(_onCategoryChanged);
    if(_categoryViewModel.categories.isNotEmpty) {
      readDocuments(_categoryViewModel.categories);
    }
  }

  StreamSubscription<List<DocumentModel>>? _subscription;

  List<DocumentModel> _documents = [];
  List<DocumentModel> get documents => _documents;

  final _searchQueryController = BehaviorSubject<String>.seeded('');

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isRetrying = false;
  bool isBookMark = false;

  /// 초기 데이터 로드
  ///
  /// Stream으로 데이터를 받아옴
  void readDocuments(List<CategoryModel> categories) {
    print('################## 데이터들 불러오기!!!!');
    _subscription?.cancel();

    _subscription = _searchQueryController.stream
        .switchMap((keyword) {
          if (keyword.isEmpty) {
            // 검색 키워드가 없을 땐, 전체 가져오기
            return _driftDocumentService.watchAllDocuments(categories);
          } else {
            // 검색한 값만 가져오기
            return _driftDocumentService.searchDocuments(keyword, categories);
          }
        })
        .listen(
          (data) {
            // 여기서 List에 받아온 값들 저장함
            _documents = data;
            notifyListeners();
            print(
              '################## 저장된 문서는 ${_documents.length}개###########',
            );
          },
          onError: (e, stackTrace) {
            print('############ stream error 발생: $e #############');
            print('############ 스택 트레이스: $stackTrace ###############');
          },
        );

    // TODO 북마크 어떻게 할건지? SQL을 다시 호출? 아니면 Client 에서 sort?
  }

  /// 수집물 추가
  Future<void> addDocumentProcess({
    required String sharedURL,
    required String sharedURLCaptionText,
    required CategoryModel category,
    String? memo,
  }) async {
    if (_isLoading) return;
    _isLoading = true;

    /// 스크래핑
    final (newDoc, contentText) = await _firebaseDocumentService
        .scrapeUrlAndPrepare(sharedURL, sharedURLCaptionText, category, memo);

    /// 1차 저장(분석중)
    await _driftDocumentService.createDocument(newDoc);

    _isLoading = false;

    /// AI 요약(백그라운드)
    _runAiAnalysis(newDoc, contentText);
  }

  /// AI 분석 후 document 업데이트
  Future<void> _runAiAnalysis(
    DocumentModel document,
    String contentText,
  ) async {
    try {
      final updateDoc = await _firebaseDocumentService.getAiSummary(
        document: document,
        contentText: contentText,
      );

      /// 업데이트, 2차 저장
      await _driftDocumentService.updateDocument(updateDoc).then(
        (_) {
          print('################## local document update ###########');
        },
      );

      /// 서버와 Sync
      await _firebaseDocumentService.saveDocument(updateDoc).then(
        (_) async {
          /// local의 SyncStatus 갱신
          print('########## 서버 업로드 성공 ##############');
          await pullSync(_authViewModel.uid);
          await _driftDocumentService.remoteUploadDone(updateDoc);
        },
      );
    } catch (e) {
      debugPrint('AI 분석 업데이트 실패: $e');
    }
  }

  /// AI 분석 재요청
  Future<void> retryAiAnalysis(DocumentModel document) async {
    if (_isRetrying) return;

    _isRetrying = true;

    try {
      /// 상태 변경
      await _driftDocumentService.updateDocument(
        document.copyWith(aiStatus: AiTaskStatus.analyzing),
      );

      /// 스크래핑(contentText 사용)
      final (_, contentText) = await _firebaseDocumentService
          .scrapeUrlAndPrepare(
            document.url,
            '',
            document.category,
            document.userMemo,
          );

      /// 최신 문서 기준으로 AI 실행
      final updateDoc = await _firebaseDocumentService.getAiSummary(
        document: document,
        contentText: contentText,
      );

      /// 저장
      await _driftDocumentService.updateDocument(updateDoc);

      /// 서버와 Sync
      await _firebaseDocumentService.updateDocument(updateDoc).then((_) async {
        /// local의 SyncStatus 갱신
        await _driftDocumentService.remoteUploadDone(updateDoc);
      });
    } catch (e) {
      debugPrint('AI 재시도 실패: $e');

      final updateDoc = document.copyWith(aiStatus: AiTaskStatus.failed);
      await _driftDocumentService.updateDocument(updateDoc);
      await _firebaseDocumentService.updateDocument(updateDoc).then((_) async {
        /// local의 SyncStatus 갱신
        await _driftDocumentService.remoteUploadDone(updateDoc);
      });
    } finally {
      _isRetrying = false;
    }
  }

  /// 삭제
  Future<void> deleteDocument(String id) async {
    /// 서버에서 먼저 삭제 후, 성공하면 local delete TODO 삭제 매커니즘 변경해야 함
    await _firebaseDocumentService.deleteDocument(id).then(
      (_) async {
        /// local delete
        await _driftDocumentService.deleteDocument(id);
      },
    );
  }

  /// 검색 함수
  void search({required String keyword, required CategoryModel category}) {
    _searchQueryController.add(
      keyword,
    );
  }

  /// 카테고리 변경 감지 리스너
  void _onCategoryChanged() async{
    print('############## doc VM에서 카테고리 수는? ${_categoryViewModel.categories.length} ################');
    if(_categoryViewModel.categories.isNotEmpty) {
      readDocuments(_categoryViewModel.categories);
      await pullSync(_authViewModel.uid);
    }
  }
  
  @override
  void dispose() {
    _categoryViewModel.removeListener(_onCategoryChanged);
    _subscription?.cancel();
    super.dispose();
  }

  /// remote의 데이터를 가져와 sync 맞추기
  Future<void> pullSync(String uid) async {
    print('############# pull Sync 시작 #################');

    // local sync
    final localSyncTime = await _driftDocumentService.getSyncTime();
    print('################## local 시간: $localSyncTime ##############');

    // local sync보다 오래된 data들을 가져옴
    final List<DocumentModel> documents = await _firebaseDocumentService
        .getDocumentsByUpdatedAt(localSyncTime);
    print(
      '################### sync data는 총 ${documents.length}개 ###################',
    );

    // sync 데이터 없으면 그대로 종료
    if (documents.isEmpty) {
      print('############# sync data 없어서 pull 종료함 #############');
      await _driftDocumentService.setSyncTime();
      return;
    }

    // 삭제 날짜가 있으면 삭제, 아니면 업데이트
    for (var doc in documents) {
      if (doc.deletedAt != null) {
        await _driftDocumentService.syncDelete(doc.id);
      } else {
        await _driftDocumentService.syncUpdate(doc);
      }
    }

    // local sync 업데이트
    await _driftDocumentService.setSyncTime();
  }

  /// Sync가 되지 않은 local의 데이터를 보내 sync 맞추기
  Future<void> pushSync(List<CategoryModel> categories, String uid) async {
    print('############# push Sync 시작 #################');

    // pull sync 하기
    await pullSync(uid);

    // pending인 값 가져오기
    final pendingDocuments = await _driftDocumentService.getPendingDocuments();

    if (pendingDocuments.isEmpty) {
      print('############### pending data 없어서 push 종료함 ##################');
      return;
    }

    final documents = pendingDocuments.map((doc) {
      return doc
          .toDomain(categories: categories)
          .copyWith(updatedAt: DateTime.now())
          .toMap();
    }).toList();

    // 일괄 쓰기
    await _firebaseDocumentService.documentBatchWrite(documents).then((
        _,
        ) async {
      for (var d in pendingDocuments) {
        await _driftDocumentService.syncStatusUpdate(d);
      }
    });
  }
}
