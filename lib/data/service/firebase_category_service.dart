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

  Stream<List<CategoryModel>> readCategory() {
    return _db.collection(_collectionPath)
        .where('uid', isEqualTo: _currentUid)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CategoryModel.fromMap(doc.data()))
        .toList());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _db.collection(_collectionPath).doc(category.categoryId).update(category.toMap());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _db.collection(_collectionPath).doc(categoryId).delete();
  }

  Future<void> updateCategoryOrders(List<CategoryModel> categories) async {
    final batch = _db.batch();

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final ref = _db.collection('categories').doc(category.categoryId);

      batch.update(ref, {
        'order': i,
      });
    }

    await batch.commit();
  }
}