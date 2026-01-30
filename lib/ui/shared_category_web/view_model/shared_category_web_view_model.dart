import 'package:archivey/data/service/firebase_category_service.dart';
import 'package:archivey/data/service/firebase_document_service.dart';
import 'package:archivey/data/service/firebase_shared_category_link_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/domain/model/shared_category_link_model.dart';
import 'package:archivey/domain/state/shared_web_state.dart';
import 'package:flutter/material.dart';

class SharedCategoryWebViewModel extends ChangeNotifier {
  final FirebaseDocumentService _firebaseDocumentService;
  final FirebaseCategoryService _firebaseCategoryService;
  final FirebaseSharedCategoryWebService _firebaseSharedCategoryWebService;
  final SharedWebState _sharedWebState;

  SharedCategoryWebViewModel(
    this._firebaseDocumentService,
    this._firebaseCategoryService,
    this._firebaseSharedCategoryWebService,
    this._sharedWebState,
  );

  List<DocumentModel> get documents => _sharedWebState.documents;
  String get categoryId => _sharedWebState.categoryId;
  CategoryModel? _category;
  CategoryModel? get category => _category;
  List<CategoryModel> _subCategories = [];
  List<CategoryModel> get subCategories => _subCategories;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  List<DocumentModel> filteredDisplayDocuments=[];
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<DocumentModel> get displayDocuments => filteredDisplayDocuments;
  String _searchKeyword = '';
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> initSharedWebState(String shareId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('shareId : $shareId');
      final SharedCategoryLinkModel? sharedCategoryLink =
      await _firebaseSharedCategoryWebService.readSharedCategoryLink(shareId);

      if (sharedCategoryLink == null) {
        print('공유 링크가 유효하지 않습니다.');
        throw Exception('공유 링크가 유효하지 않거나 만료되었습니다.');
      }

      _sharedWebState.shareId = shareId;
      _sharedWebState.categoryId = sharedCategoryLink.categoryId;
      _sharedWebState.ownerUid = sharedCategoryLink.ownerUid;

      final List<DocumentModel> docs = await getDocumentsByCategoryId(
        _sharedWebState.categoryId,
        _sharedWebState.ownerUid,
      );

      _sharedWebState.documents = docs;
      filteredDisplayDocuments = List.from(docs);
      _errorMessage = null;
      notifyListeners();
    } catch (e, stacktrace) {
      print('Error initializing shared web state: $e');
      print('Stacktrace: $stacktrace');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _sharedWebState.documents = [];
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CategoryModel?> getCategoryByCategoryId(String categoryId) async {
    try{
      return await _firebaseCategoryService.getCategoryByCategoryId(categoryId);
    }catch(e){
      print('getCategoryByCategoryId error : $e');
    }
    return null;
  }

  Future<List<String>> _getFamilyCategoryIds(String rootId, String ownerId) async {
    try {
      final List<CategoryModel> ownerAllCategories = await _firebaseCategoryService.readCategoryByUid(_sharedWebState.ownerUid);

      /// 대분류 카테고리 Id 추출
      final rootIds = ownerAllCategories
          .where((c) => c.categoryId == rootId)
          .map((c) => c.categoryId);

      /// 소분류 카테고리 Id 추출
      final childrenModels = ownerAllCategories
          .where((c) => c.parentId == rootId)
          .toList();

      _subCategories = childrenModels;
      return [...rootIds, ...childrenModels.map((c) => c.categoryId)];

    } catch (e) {
      print("Error in _getFamilyCategoryIds: $e");
      return [rootId];
    }
  }

  Future<List<DocumentModel>> getDocumentsByCategoryId(String categoryId, String ownerId) async {
    try {

      /// ownerId의 모든 문서 읽기
      final ownerAllDocs = await _firebaseDocumentService.readDocumentsByUid(ownerId);

      /// 카테고리 정보 조회
      final category = await getCategoryByCategoryId(categoryId);
      if (category == null) {
        throw Exception('해당 카테고리 데이터를 찾을 수 없습니다.');
      }
      _category = category;
      final bool isRoot = _category?.parentId == null;

      if (isRoot) {
        /// 대분류일 경우: 자신을 포함한 하위 카테고리 ID들로 순회하며 수집물 탐색
        final List<String> familyCategoryIds = await _getFamilyCategoryIds(categoryId, ownerId);

        return ownerAllDocs.where((doc) {
          return familyCategoryIds.contains(doc.category.categoryId);
        }).toList();
      } else {
        /// 소분류일 경우: 해당 카테고리 ID랑 일치하는 문서만 필터링
        return ownerAllDocs.where((doc) {
          return doc.category.categoryId == categoryId;
        }).toList();
      }
    } catch (e, stackTrace) {
      print('Error in getDocumentsByCategory: $e');
      print('StackTrace: $stackTrace');

      throw Exception('문서를 불러오는 중 문제가 발생했습니다.');
    }
  }

  List<DocumentModel> getDocumentsBySubCategoryId(String subId){
    return _sharedWebState.documents
        .where((doc) => doc.category.categoryId == subId)
        .toList();
  }

  void getDisplayDocuments({
    String? categoryId,
    required bool isLatest,
    required bool isBookmarkMode,
  }) {
    List<DocumentModel> docs;

    /// 전체 선택 시 또는 루트 ID일 때 처리
    if (categoryId == null || categoryId == this.categoryId) {
      docs = List.from(documents);
    } else {
      docs = getDocumentsBySubCategoryId(categoryId);
    }

    /// 검색어가 남아있을때 검색어 필터 중첩 적용
    if (_searchKeyword.isNotEmpty) {
      final keyword = _searchKeyword.trim().toLowerCase(); // 전처리

      docs = docs.where((doc) {
        return doc.title.toLowerCase().contains(keyword) ||
            doc.aiSummary.toLowerCase().contains(keyword) ||
            doc.tags.any((tag) => tag.toLowerCase().contains(keyword));
      }).toList();
    }

    if (isBookmarkMode) {
      filteredDisplayDocuments= docs.where((doc) => doc.isBookmark == true).toList();
      notifyListeners();
      return;
    } else {
      docs.sort((a, b) => isLatest
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt));
      filteredDisplayDocuments = docs;
    }
    notifyListeners();
  }


  void search(String keyword) {
    _searchKeyword = keyword;
    _isSearching = keyword.isNotEmpty;
    // _searchFilters(); /// 검색어랑 카테고리 필터 동시사용

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFilters();
    });
  }

  void _searchFilters() {
    List<DocumentModel> docs = List.from(_sharedWebState.documents);

    if (_searchKeyword.isNotEmpty) {
      final keyword = _searchKeyword.trim().toLowerCase();

      docs = docs.where((doc) {
        return doc.title.toLowerCase().contains(keyword) ||
            doc.aiSummary.toLowerCase().contains(keyword) ||
            doc.tags.any((tag) => tag.toLowerCase().contains(keyword));
      }).toList();
    }

    filteredDisplayDocuments = docs;
    notifyListeners();
  }
}
