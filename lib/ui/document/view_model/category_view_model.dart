import 'package:archivey/data/service/drift_document_service.dart';
import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/data/service/firebase_category_service.dart';
import 'package:archivey/data/service/firebase_document_service.dart';
import 'package:archivey/data/service/firebase_shared_category_link_service.dart';
import 'package:archivey/data/service/kakao_sdk_share_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/domain/state/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:archivey/config/share_category_link_config.dart';

class CategoryViewModel extends ChangeNotifier {
  final FirebaseCategoryService _categoryService;
  final KakaoSdkShareService _kakaoSdkShareService;
  final AppState _appState;
  final FirebaseDocumentService _firebaseDocumentService;
  final DriftDocumentService _driftDocumentService;
  final FirebaseSharedCategoryWebService _sharedCategoryLinkService;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  CategoryViewModel(
    this._categoryService,
    this._kakaoSdkShareService,
    this._appState,
    this._firebaseDocumentService,
    this._driftDocumentService,
      this._sharedCategoryLinkService,
  );
  // List<CategoryModel> _categories = [];
  // List<CategoryModel> get categories => _categories;
  List<CategoryModel> get categories => _appState.categories;

  // User? get user => _authService.user;
  final Map<String, int> _docCountMap = {};
  Map<String, int> get docCountMap => _docCountMap;

  // void updateState(AppState newState) {
  //   _appState = newState;
  //   notifyListeners();
  // }
  //   CategoryViewModel(this._categoryService, this._authService, this._documentService){
  //     readCategory();
  //     // print('######### 카테고리 수: ${_categories.length} ###########');
  //   }
  //   List<CategoryModel> _categories = [];
  //   List<CategoryModel> get categories => _categories;

  //   User? get user => _authService.user;
  //   final Map<String, int> _docCountMap = {};
  //   Map<String, int> get docCountMap => _docCountMap;

  ///에러 메세지 문자열 비우는 util
  void clearErrorMessage() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  CategoryModel getCategory(String categoryId) {
    return _appState.categories.where((c) => c.categoryId == categoryId).first;
  }

  ///대분류 카테고리만 정렬해서 반환
  List<CategoryModel> get rootCategories {
    final rootList = categories.where((c) => c.isRootCategory).toList();
    rootList.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    return rootList;
  }

  ///특정 대분류의 소분류 카테고리들을 반환
  List<CategoryModel> getSubCategories(String? rootId) {
    if (rootId == null) return [];
    final subList = categories.where((c) => c.parentId == rootId).toList();
    subList.sort((a, b) => a.categoryName.compareTo(b.categoryName));

    return subList;
  }

  ///특정 대분류와 해당하는 소분류 카테고리의 id를 하나로 묶어서 반환
  Set<String> _getFamilyCategories(String rootId) {
    return {
      rootId,
      ...getSubCategories(rootId).map((e) => e.categoryId),
    };
  }

  /// 소분류 카테고리의 parentId를 받아 소분류가 속한 해당 대분류 카테고리를 반환
  CategoryModel? getRootCategoryByParentId(String parentId) {
    try {
      return rootCategories.firstWhere(
        (root) => root.categoryId == parentId,
      );
    } catch (_) {
      return null;
    }
  }

  ///카테고리id를 받아 해당 id에 속한 document 반환
  // Future<int> getDocumentsByCategory(String categoryId) async {
  //   try {
  //     final documents = await _documentService.getDocumentsByCategory(
  //       categoryId,
  //     );
  //     print('documents.length: ${documents.length}');
  //     return documents.length;
  //   } catch (e) {
  //     print("error in getDocumentsByCategory : $e");
  //     rethrow;
  //   }
  // }

  int getRootCategoryDocCount(String rootId) {
    final familyIds = _getFamilyCategoryIds(rootId);
    return _countDocsFromFamilyCategory(familyIds);
  }

  List<String> _getFamilyCategoryIds(String rootId) {
    final categories = _appState.categories;
    final rootIds = categories
        .where((c) => c.categoryId == rootId)
        .map((c) => c.categoryId);
    final childrenIds = categories
        .where((c) => c.parentId == rootId)
        .map((c) => c.categoryId);

    return [...rootIds, ...childrenIds];
  }

  int _countDocsFromFamilyCategory(List<String> categoryIds) {
    /// AppState의 전체 문서 중, 포함된 카테고리 ID를 가진 문서만 필터링
    return _appState.documents
        .where((doc) => categoryIds.contains(doc.category.categoryId))
        .length;
  }

  ///대분류 카테고리 자체 + 속한 소분류 카테고리에 해당하는 document 반환
  // Future<List<DocumentModel>> getDocumentsByRootCategory(String rootCategoryId) async {
  //   try {
  //     final familyIds = _getFamilyCategories(rootCategoryId);
  //
  //     final results = await Future.wait(
  //         familyIds.map((id) => _documentService.getDocumentsByCategory(id))
  //     );
  //
  //     return results.expand((docs) => docs).toList();
  //   } catch (e) {
  //     print("error in getDocumentsByRootCategory : $e");
  //     rethrow;
  //   }
  // }

  // Future<int> getDocumentCountByRootCategory(String rootCategoryId) async {
  //   final docs = await getDocumentsByRootCategory(rootCategoryId);
  //   return docs.length;
  // }

  // Future<void> initRootCategoryDocumentCount() async {
  //   _docCountMap.clear();
  //
  //   final rootList = categories.where((c) => c.isRootCategory).toList();
  //
  //   for (final category in rootList) {
  //     final count =
  //     await getDocumentCountByRootCategory(category.categoryId);
  //
  //     _docCountMap[category.categoryId] = count;
  //     print('${category.categoryName} : $count');
  //   }
  //
  //   notifyListeners();
  // }

  ///create할때 order 최대값 계산해주는 util
  int _calculateCategoryOrder() {
    int currentMax = -1;
    for (var i in categories) {
      if (i.isRootCategory) {
        int categoryOrder = i.order ?? 0;
        if (categoryOrder > currentMax) {
          currentMax = categoryOrder;
        }
      }
    }
    return currentMax;
  }

  ///create할때 document수 +1 하는 util
  void _increaseDocCount(String categoryId) {
    _docCountMap[categoryId] = (_docCountMap[categoryId] ?? 0) + 1;
    notifyListeners();
  }

  ///delete할때 document수 -1 하는 util
  void _decreaseDocCount(String categoryId) {
    final current = _docCountMap[categoryId] ?? 0;
    _docCountMap[categoryId] = current > 0 ? current - 1 : 0;
    notifyListeners();
  }

  bool isAlreadyInUseCategory(String name, String? parentId, {String? excludeId}) {
    return _appState.categories.any((category) =>
    category.parentId == parentId &&
        category.categoryName == name &&
        category.categoryId != excludeId // 현재 수정 중인 항목은 제외
    );
  }
  Future<void> createCategory(String categoryName, {String? parentId}) async {
    int? order;

    if (parentId == null) {
      ///최상위 카테고리일때만 order 계산
      int currentMax = _calculateCategoryOrder();
      order = (currentMax == -1) ? 0 : currentMax + 1;
    }

    final newCategory = CategoryModel(
      uid: _appState.uid,
      categoryId: const Uuid().v4(),
      categoryName: categoryName,
      order: order,
      parentId: parentId,
    );

    try {
      await _categoryService.createCategory(newCategory);
      _increaseDocCount(newCategory.categoryId);
      await readCategory();

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      print('error in createCategory: $e');
      _errorMessage = "카테고리 추가에 실패했습니다. 잠시 후 다시 시도해주세요.";
      notifyListeners();
    }
  }

  Future<void> readCategory() async {
    try {
      clearErrorMessage();
      // _categories = await _categoryService.readCategory();
      final _categories = await _categoryService.readCategory();
      _appState.setCategories(_categories);
      print('########### read Category 실행함!! ${_appState.categories.length} #########');

      // await initRootCategoryDocumentCount();
    } catch (e) {
      print('error in readCategory: $e');
      _errorMessage = '카테고리 데이터를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateCategory(
    CategoryModel originalCategory,
    String newName,
  ) async {
    if (originalCategory.categoryName == newName) return;

    final toUpdate = originalCategory.copyWith(categoryName: newName);

    try {
      clearErrorMessage();
      await _categoryService.updateCategory(toUpdate);
      await readCategory();
    } catch (e) {
      print('error in updateCategory: $e');
      _errorMessage = '카테고리 이름 변경에 실패했습니다. 잠시 후 다시 시도해주세요.';
      notifyListeners();
    }
  }

  Future<void> updateReorderCategories(int oldIndex, int newIndex) async {
    List<CategoryModel> toReorder = List.from(rootCategories);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = toReorder.removeAt(oldIndex);
    toReorder.insert(newIndex, item);

    for (int i = 0; i < toReorder.length; i++) {
      toReorder[i] = toReorder[i].copyWith(order: i);
    }

    try {
      clearErrorMessage();
      await _categoryService.updateReorderCategories(toReorder);
      await readCategory();
    } catch (e) {
      print('error in reorderCategories: $e');
      _errorMessage = '카테고리 순서를 변경할 수 없습니다. 잠시 후 다시 시도해주세요.';
      notifyListeners();
    }
  }

  // Future<void> deleteCategory(String categoryId) async {
  //   try {
  //     clearErrorMessage();
  //     await _categoryService.deleteCategory(categoryId);
  //     // _decreaseDocCount(categoryId);
  //     await readCategory();
  //   } catch (e) {
  //     print('error in deleteCategory: $e');
  //     _errorMessage = '카테고리 삭제에 실패했습니다. 잠시 후 다시 시도해주세요.';
  //     notifyListeners();
  //   }
  // }

  Future<void> deleteCategory(String categoryId) async {
    final category = getCategory(categoryId);
    final bool isRoot = category.parentId == null;
    final List<DocumentModel> docsToDelete;
    var familyCategoryIds = [];

    //1. 삭제 대상인 카테고리가 root인지 sub인지 판단
    //2. root일시 familyCategoryIds 구하기
    //3. 삭제.
    //3-1. root일시 삭제 규칙 : 해당 root 카테고리 + document / 하위 sub 카테고리 + 해당 document 모두 삭제,
    //3-2. 그냥 단일 카테고리일 시 : 해당 카테고리 + document 삭제
    //삭제 후 카테고리와 도큐먼트 모두 최신화 해야함.

    if (isRoot) {
      print('isRoot : $isRoot');
      familyCategoryIds = _getFamilyCategoryIds(categoryId);
      print('familyCategoryIds : $familyCategoryIds');
      docsToDelete = _appState.documents
          .where(
            (doc) => familyCategoryIds.contains(doc.category.categoryId),
          )
          .toList();
    } else {
      docsToDelete = _appState.documents
          .where((c) => c.category.categoryId == categoryId)
          .toList();
    }

    // if (docsToDelete.isEmpty) {return;}

    try {
      clearErrorMessage();
      //도큐먼트부터 삭제
      print('here1');
      for (final doc in docsToDelete) {
        await deleteDocument(doc.id);
      }

      print('here2');
      if (isRoot) {
        final subCategoryIds = familyCategoryIds
            .where((id) => id != categoryId)
            .toList();

        for (final subId in subCategoryIds) {
          await deleteCategory(subId);
        }

        // 모든 하위 삭제 후 root 삭제
        await _categoryService.deleteCategory(categoryId);
      } else {
        print('here4');
        await _categoryService.deleteCategory(categoryId);
      }
      print('here5');

      await readCategory();
    } catch (e) {
      print('error in deleteCategory: $e');
      _errorMessage = '카테고리 삭제에 실패했습니다. 잠시 후 다시 시도해주세요.';
      notifyListeners();
    }
  }

  Future<void> deleteDocument(String id) async {
    /// 서버에서 먼저 삭제 후, 성공하면 local delete TODO 삭제 매커니즘 변경해야 함
    await _firebaseDocumentService.deleteDocument(id).then(
      (_) async {
        /// local delete
        await _driftDocumentService.deleteDocument(id);
      },
    );
  }

  ///카테고리 공유하기(웹) 구현을 위한 메소드 추가
  Future<String?> createSharedCategoryLink(String categoryId) async {
    try {
      final shareId = await _sharedCategoryLinkService.createSharedCategoryLink(_appState.uid, categoryId);
      return "${ShareCategoryLinkConfig.baseUrl}/share/category/$shareId";
    } catch (e) {
      print('error in createSharedCategoryLink: $e');
      return null;
    }
  }

  Future<void> kakaoShareCategoryURL(String urlToShare, CategoryModel category) async {
    try {
      await _kakaoSdkShareService.kakaoShareCategoryURL(urlToShare, category);
    }catch(e){
      print('Error in kakaoShareDocumentURL: $e');
    }
  }
}
