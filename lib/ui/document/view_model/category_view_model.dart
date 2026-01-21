import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/data/service/firebase_category_service.dart';
import 'package:archivey/data/service/firebase_document_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/domain/state/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoryViewModel extends ChangeNotifier {
  final FirebaseCategoryService _categoryService;
  // final FirebaseAuthService _authService;
  // final FirebaseDocumentService _documentService;
  AppState _appState;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  CategoryViewModel(
    this._categoryService,
    // this._authService,
    // this._documentService,
    this._appState
  );
  // List<CategoryModel> _categories = [];
  // List<CategoryModel> get categories => _categories;
  List<CategoryModel> get categories => _appState.categories;

  // User? get user => _authService.user;
  final Map<String, int> _docCountMap = {};
  Map<String, int> get docCountMap => _docCountMap;

  void updateState(AppState newState) {
    _appState = newState;
    notifyListeners();
  }
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

  CategoryModel? getCategory(String categoryId) {
    return categories.where((c) => c.categoryId == categoryId).firstOrNull;
  }

  ///대분류 카테고리만 반환
  List<CategoryModel> get rootCategories {
    final rootList = categories.where((c) => c.isRootCategory).toList();
    rootList.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    return rootList;
  }

  ///특정 대분류의 소분류 카테고리들을 반환
  List<CategoryModel> getSubCategories(String rootId) {
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
  int getDocumentsByCategory(String categoryId) {
    final documents = _appState.documents;

    if(documents.isEmpty) return 0;

    int result = 0;

    for(var d in documents) {
      if(d.category.categoryId == categoryId) result++;
    }

    return result;
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

  Future<void> createCategory(String name, {String? parentId}) async {
    int? order;

    if (parentId == null) {
      ///최상위 카테고리일때만 order 계산
      int currentMax = _calculateCategoryOrder();
      order = (currentMax == -1) ? 0 : currentMax + 1;

      /// 찾은 결과가 없으면 0, 있으면 최댓값 + 1
    }

    final newCategory = CategoryModel(
      uid: _appState.uid,
      categoryId: const Uuid().v4(),
      categoryName: name,
      order: order,
      parentId: parentId,
    );

    try {
      await _categoryService.createCategory(newCategory);
      _increaseDocCount(newCategory.categoryId);
      await readCategory();
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

  Future<void> deleteCategory(String categoryId) async {
    try {
      clearErrorMessage();
      await _categoryService.deleteCategory(categoryId);
      // _decreaseDocCount(categoryId);
      await readCategory();
    } catch (e) {
      print('error in deleteCategory: $e');
      _errorMessage = '카테고리 삭제에 실패했습니다. 잠시 후 다시 시도해주세요.';
      notifyListeners();
    }
  }
}
