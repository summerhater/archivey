import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/data/service/firebase_category_service.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoryViewModel extends ChangeNotifier {
  final FirebaseCategoryService _categoryService;
  final FirebaseAuthService _authService;
  CategoryViewModel(this._categoryService, this._authService);
  List<CategoryModel> _categories = [];

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
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = _categories.removeAt(oldIndex);
    _categories.insert(newIndex, item);

    notifyListeners();
    await _categoryService.updateCategoryOrders(_categories);
  }
}