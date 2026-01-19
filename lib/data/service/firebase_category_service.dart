import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/model/category_model.dart';

class FirebaseCategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'categories';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get _currentUid => _auth.currentUser?.uid ?? '';

  Future<void> createCategory(CategoryModel category) async {
    await _db.collection(_collectionPath).doc(category.categoryId).set(category.toMap());
  }

  Future<List<CategoryModel>> readCategory() async {
    final snapshot = await _db.collection(_collectionPath)
        .where('uid', isEqualTo: _currentUid)
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) => CategoryModel.fromMap(doc.data())).toList();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _db.collection(_collectionPath).doc(category.categoryId).update(category.toMap());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _db.collection(_collectionPath).doc(categoryId).delete();
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
}