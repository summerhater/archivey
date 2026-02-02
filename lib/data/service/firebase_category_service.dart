import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/model/category_model.dart';

class FirebaseCategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'categories';

  Future<void> createCategory(CategoryModel category) async {
    await _db.collection(_collectionPath).doc(category.categoryId).set(category.toMap());
  }

  Future<List<CategoryModel>> readCategory(String uid) async {
    final snapshot = await _db.collection(_collectionPath)
        .where('uid', isEqualTo: uid)
        // .orderBy('order') todo: 루트카테고리만 골라서 order 순서로 sort해야함.
        .get();

    return snapshot.docs.map((doc) => CategoryModel.fromMap(doc.data())).toList();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _db.collection(_collectionPath).doc(category.categoryId).update(category.toMap());
  }

  // DELETE: 삭제
  Future<void> deleteCategory(String categoryId) async {
    final batch = _db.batch();

    /// 삭제할 카테고리 본인 삭제(1개)
    final category = _db.collection('categories').doc(categoryId);
    batch.delete(category);

    /// 삭제할 카테고리가 대분류라면, 속한 소분류 카테고리들 찾기 (parentId == categoryId)
    final subCategories = await _db
        .collection('categories')
        .where('parentId', isEqualTo: categoryId)
        .get();

    for (var doc in subCategories.docs) {
      batch.delete(doc.reference);
    }

    /// 소속된 문서들 찾기 : 이 카테고리가 직접 소유한 문서들, 소분류에 속한 문서들
    final docsToDelete = await _db
        .collection('documents')
        .where('category.categoryId', isEqualTo: categoryId)
        .get();

    for (var doc in docsToDelete.docs) {
      batch.delete(doc.reference);
    }

    /// 대분류 삭제 시 하위 소분류의 문서까지 지우기
    for (var subDocsToDelete in subCategories.docs) {
      final subDocs = await _db
          .collection('documents')
          .where('category.categoryId', isEqualTo: subDocsToDelete.id)
          .get();
      for (var d in subDocs.docs) {
        batch.delete(d.reference);
      }
    }

    // 모든 작업 한 번에 실행
    await batch.commit();
  }

  Future<void> updateReorderCategories(List<CategoryModel> categories) async {
    final batch = _db.batch();

    for (int idx = 0; idx < categories.length; idx++) {
      final category = categories[idx];
      final ref = _db.collection('categories').doc(category.categoryId);

      batch.update(ref, {'order': idx,});
    }

    await batch.commit();
  }

  Future<CategoryModel?> getCategoryByCategoryId(String categoryId) async {
    try {
      final querySnapshot = await _db
          .collection('categories')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      if (querySnapshot.docs.isEmpty) {return null;}

      final data = querySnapshot.docs.first.data();
      return CategoryModel.fromMap(data);
    } catch (e) {
      print('getCategoryByCategoryId: 카테고리 조회 중 오류 발생: $e');
      rethrow;
    }
  }

  Future<List<CategoryModel>> readCategoryByUid(String uid) async {
    try {
      final querySnapshot = await _db
          .collection('categories')
          .where('uid', isEqualTo: uid)
          .get();

      return querySnapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data());
      }).toList();

    } catch (e) {
      print("readCategoryByUid 에러 : $e");
      return [];
    }
  }
}