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

  Future<List<CategoryModel>> readCategory() async{
    final tmp = await _db.collection(_collectionPath)
        .where('uid', isEqualTo: _currentUid).get();

    return tmp.docs.map((e) => CategoryModel.fromMap(e.data()),).toList();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _db.collection(_collectionPath).doc(category.categoryId).update(category.toMap());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _db.collection(_collectionPath).doc(categoryId).delete();
  }
}