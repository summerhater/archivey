import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/data/service/firebase_category_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoryViewModel extends ChangeNotifier {
  final FirebaseCategoryService _categoryService;
  final FirebaseAuthService _authService;
  CategoryViewModel(this._categoryService, this._authService){
    readCategory();
    print('######### 카테고리 수: ${_categories.length} ###########');
  }
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  User? get user => _authService.user;

  /// getter: 최상위 카테고리만 반환
  List<CategoryModel> get rootCategories {
    final rootList = _categories.where((c) => c.isRootCategory).toList();
    rootList.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    return rootList;
  }

  /// getter: 특정 부모의 서브 카테고리들을 반환
  List<CategoryModel> getSubCategories(String parentId) {
    final subList = _categories.where((c) => c.parentId == parentId).toList();
    subList.sort((a, b) => a.categoryName.compareTo(b.categoryName));

    return subList;
  }

  /// subCategory의 parentId를 받아 subCategory가 속한 해당 root category를 반환
  CategoryModel? getRootCategoryByParentId(String parentId) {
    try {
      return rootCategories.firstWhere(
            (root) => root.categoryId == parentId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> createCategory(String name, {String? parentId}) async {
    int? order;

    if (parentId == null) { ///최상위 카테고리일때만 order 계산
      int currentMax = -1;

      for (var c in _categories) {
        if (c.isRootCategory) {
          int categoryOrder = c.order ?? 0;
          if (categoryOrder > currentMax) {
            currentMax = categoryOrder;
          }
        }
      }

      /// 찾은 결과가 없으면 0, 있으면 최댓값 + 1
      order = (currentMax == -1) ? 0 : currentMax + 1;
    }

    final newCategory = CategoryModel(
      uid: user!.uid,
      categoryId: const Uuid().v4(),
      categoryName: name,
      order: order,
      parentId: parentId,
    );

    await _categoryService.createCategory(newCategory);
  }

  /// uid로 카테고리 실시간 구독
  void readCategory() {
    _categoryService.readCategory().listen((data) {
      _categories = data;
      print('############ stream으로 받아온 카테고리는 ${data.length} ###########');
      notifyListeners();
    });
  }

  Future<void> updateCategory(CategoryModel originalCategory, String newName) async {
    print('newname : $newName');
    final updated = CategoryModel(
      uid: originalCategory.uid,
      categoryId: originalCategory.categoryId,
      categoryName: newName,
      order: originalCategory.order,
      parentId: originalCategory.parentId,
    );
    await _categoryService.updateCategory(updated);
    notifyListeners();
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoryService.deleteCategory(categoryId);
  }

  Future<void> reorderCategories(int oldIndex, int newIndex) async {
    // 1. 현재 화면에 보여지고 있는 리스트(rootCategories)를 복사합니다.
    List<CategoryModel> listToMove = List.from(rootCategories);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // 2. 해당 리스트 내에서 순서를 변경합니다.
    final item = listToMove.removeAt(oldIndex);
    listToMove.insert(newIndex, item);

    // 3. 변경된 순서대로 'order' 값을 다시 할당합니다.
    // 이 때, 전체 _categories를 업데이트하는 것이 아니라
    // 영향을 받은 rootCategories들의 order만 계산하여 업데이트 리스트를 만듭니다.
    for (int i = 0; i < listToMove.length; i++) {
      listToMove[i] = listToMove[i].copyWith(order: i);
    }

    // 4. UI에 즉시 반영 (낙관적 업데이트)
    // 스트림이 다시 돌기 전에 로컬 데이터를 먼저 갱신하고 싶다면 아래 주석을 활용하세요.
    // notifyListeners();

    // 5. DB 업데이트 (Batch 작업)
    await _categoryService.updateCategoryOrders(listToMove);
  }
}