import 'dart:async';

import 'package:archivey/config/share_category_link_config.dart';
import 'package:archivey/data/mapper/document_mapper.dart';
import 'package:archivey/data/service/drift_document_service.dart';
import 'package:archivey/data/service/firebase_document_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/domain/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DocViewModel extends ChangeNotifier {
  final FirebaseDocumentService _firebaseDocumentService;
  final DriftDocumentService _driftDocumentService;
  AppState _appState;

  DocViewModel(
    this._firebaseDocumentService,
    this._driftDocumentService,
    this._appState,
  ) {
    pullAndPush();
    // _appState.addListener(_onStateChanged);
    // readDocuments(_appState.categories);
  }

  StreamSubscription<List<DocumentModel>>? _subscription;

  // List<DocumentModel> _documents = [];
  List<DocumentModel> get documents => _appState.documents;

  final _searchQueryController = BehaviorSubject<String>.seeded('');
  List<DocumentModel> filteredDisplayDocuments=[];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isRetrying = false;
  bool isBookMark = false;
  bool isLatest = true;
  String? _currentCategoryId; /// 현재 화면에서 선택된 카테고리/서브카테고리 ID (null이면 전체)
  bool _hasInitDocs = false; // 1/22 란 추가 :카테고리 1개 있고 도큐먼트는 아예 없는 경우에 notifyListener()로 생기는 readDocuments() 무한루프 해결
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  void updateState(AppState newState) {
    print('############# docVM의 State가 새로운 것으로 교체 됨 ############');
    _appState = newState;
    /// 기존에 선택되어 있던 카테고리/정렬/북마크 필터 상태를 저장해서 싱크 돌때마다 재계산
    getDisplayDocuments(
      categoryId: _currentCategoryId,
      isLatestMode: isLatest,
      isBookmarkMode: isBookMark,
    );

    // if(_appState.categories.isNotEmpty && _appState.documents.isEmpty) {
    //   readDocuments(_appState.categories);
    // }

    if(_appState.categories.isNotEmpty && !_hasInitDocs) {
      _hasInitDocs = true;
      readDocuments();
    }
  }

  /// 초기 데이터 로드
  ///
  /// Stream으로 데이터를 받아옴
  void readDocuments() {
    print('################## 데이터들 불러오기!!!!');
    _subscription?.cancel();

    _subscription = _searchQueryController.stream
        .switchMap((keyword) {
      if (_isSearching != keyword.isNotEmpty) {
        _isSearching = keyword.isNotEmpty;
        notifyListeners();
      }
      print('_isSearching : $_isSearching');
          if (keyword.isEmpty) {
            // 검색 키워드가 없을 땐, 전체 가져오기
            return _driftDocumentService.watchAllDocuments(_appState.categories);
          } else {
            // 검색한 값만 가져오기
            return _driftDocumentService.searchDocuments(keyword, _appState.categories);
          }
        })
        .listen(
          (data) {
            // 여기서 List에 받아온 값들 저장함
            _appState.setDocuments(data);
            notifyListeners();
            print(
              '################## 저장된 문서는 ${_appState.documents.length}개###########',
            );
          },
          onError: (e, stackTrace) {
            print('############ stream error 발생: $e #############');
            print('############ 스택 트레이스: $stackTrace ###############');
          },
        );
  }

  List<DocumentModel> getDocumentsByCategoryId(String categoryId) {
    return _appState.documents.where((doc) => doc.category.categoryId == categoryId).toList();
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

    final trimmedMemo = memo != null && memo.trim().isEmpty ? null : memo?.trim();

    /// 스크래핑
    final (newDoc, contentText) = await _firebaseDocumentService
        .scrapeUrlAndPrepare(sharedURL.trim(), sharedURLCaptionText, category, trimmedMemo);

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
      await _firebaseDocumentService.createDocument(updateDoc).then(
        (_) async {
          /// local의 SyncStatus 갱신
          print('########## 서버 업로드 성공 ##############');
          await _driftDocumentService.remoteUploadDone(updateDoc);
        },
      );
      //appstate update
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
  void search({required String keyword}) {
    _searchQueryController.add(
      keyword,
    );
  }

  @override
  void dispose() {
    // _appState.removeListener(_onStateChanged);
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> pullAndPush() async{
    await pullSync();
    await pushSync();
  }

  /// remote의 데이터를 가져와 sync 맞추기
  Future<void> pullSync() async {
    print('############# pull Sync 시작 #################');

    // local sync
    final localSyncTime = await _driftDocumentService.getSyncTime();
    print('################## local 시간: $localSyncTime ##############');

    // local sync보다 오래된 data들을 가져옴
    final List<DocumentModel> documents = await _firebaseDocumentService
        .getDocumentsByUpdatedAt(localSyncTime, _appState.uid);
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
  Future<void> pushSync() async {
    print('############# push Sync 시작 #################');

    // pending인 값 가져오기
    final pendingDocuments = await _driftDocumentService.getPendingDocuments();

    if (pendingDocuments.isEmpty) {
      print('############### pending data 없어서 push 종료함 ##################');
      return;
    }

    final documents = pendingDocuments.map((doc) {
      return doc
          .toDomain(categories: _appState.categories)
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

    _driftDocumentService.setSyncTime();
  }

  /// 리스너
  void _onStateChanged() {
    if(_appState.categories.isNotEmpty && !_hasInitDocs) {
      _hasInitDocs = true;
      readDocuments();
    }
  }

  /// 북마크 함수
  Future<void> changeBookmark(DocumentModel doc) async{
    await _driftDocumentService.updateDocument(doc.copyWith(isBookmark: !doc.isBookmark));
    // notifyListeners();
  }

// 란 추가 ------------------------------------------------------------------------------
  ///DocumentCategoryListPage, AllTotalPage에서 카테고리마다 보여줄 documents를 구하기 위한 메소드
  CategoryModel getCategory(String categoryId) {
    return _appState.categories.where((c) => c.categoryId == categoryId).first;
  }

  List<CategoryModel> get rootCategories {
    final rootList = _appState.categories.where((c) => c.isRootCategory).toList();
    rootList.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    return rootList;
  }

  List<String> _getFamilyCategoryIds(String rootId) {
    final categories = _appState.categories;
    final rootIds = categories.where((c) => c.categoryId == rootId).map((c) => c.categoryId);
    final childrenIds = categories.where((c) => c.parentId == rootId).map((c) => c.categoryId);

    return [...rootIds, ...childrenIds];
  }

  List<DocumentModel> getDocumentsByCategory(String categoryId) {

    final category = getCategory(categoryId);
    final bool isRoot = category.parentId == null;

    if (isRoot) {
      final familyCategoryIds = _getFamilyCategoryIds(categoryId);
      return _appState.documents.where((doc) => familyCategoryIds.contains(doc.category.categoryId),
      ).toList();
    }
    return _appState.documents.where((c) => c.category.categoryId == categoryId).toList();
  }

  void getDisplayDocuments({
    String? categoryId,
    required bool isLatestMode,
    required bool isBookmarkMode,
  }) {
    // 삭제된 카테고리를 참조하지 않도록 방어 로직 추가
    if (categoryId != null &&
        !_appState.categories.any((c) => c.categoryId == categoryId)) {
      // 해당 ID의 카테고리가 더 이상 없으면 '전체'로 간주
      categoryId = null;
    }

    // 현재 선택된 카테고리 상태를 기억해 둔다. (null이면 '전체')
    _currentCategoryId = categoryId;
    isBookMark = isBookmarkMode;
    isLatest = isLatestMode;
    print('categoryId in getDisplayDocuments : $categoryId');
    ///문서 추출
    List<DocumentModel> docs = categoryId == null
        ? List.from(documents)
        : List.from(getDocumentsByCategory(categoryId));
    print('doc count in getDisplayDocuments: ${docs.length}');

    if (isBookMark) {
      filteredDisplayDocuments= docs.where((doc) => doc.isBookmark == true).toList();
      notifyListeners();
      return;
    }else{//isLatest
      ///문서 정렬
      docs.sort(
            (a, b) => isLatest
            ? b.createdAt.compareTo(a.createdAt)
            : a.createdAt.compareTo(b.createdAt),
      );
      filteredDisplayDocuments=docs;
      notifyListeners();
    }
  }

  ///DocumentDetailPage에서 보여줄 document를 documentId로 찾아서 반환
  DocumentModel getDocumentById(String id, {DocumentModel? fallback}) {
    return documents.firstWhere(
          (doc) => doc.id == id,
      orElse: () => fallback ?? documents.first,
    );
  }

  Future<void> updateDocument(DocumentModel docToUpdate) async {
    try {
      await _driftDocumentService.updateDocument(docToUpdate);

      await _firebaseDocumentService.createDocument(docToUpdate).then(
            (_) async {
          /// local의 SyncStatus 갱신
          await _driftDocumentService.remoteUploadDone(docToUpdate);
        },
      );
    } catch (e) {
      debugPrint('AI 분석 업데이트 실패: $e');
    }
  }

  String getRootCategoryNameByDocument(DocumentModel doc) {
    if (doc.category.parentId == null) {
      return doc.category.categoryName;
    }

    final rootCategory = _appState.categories
        .cast<CategoryModel?>()
        .firstWhere(
          (c) => c?.categoryId == doc.category.parentId,
      orElse: () => null,
    );

    return rootCategory?.categoryName ?? '알수없는 대분류 카테고리';
  }

  ///수집물 카카오톡 공유하기 구현을 위한 메소드 추가
  Future<String?> createSharedCategoryLink(String originalURL) async {
    try {
      return "${ShareCategoryLinkConfig.baseUrl}/share/document/go?target=$originalURL";
    } catch (e) {
      print('error in createSharedCategoryLink: $e');
      return null;
    }
  }
}

