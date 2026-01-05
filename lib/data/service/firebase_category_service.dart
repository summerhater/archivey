import 'package:archivey/domain/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCategoryService {

  final String _categories = 'categories';

  final _firestore = FirebaseFirestore.instance;
  late final _categoryRef = _firestore.collection(_categories);

  /// Category는 unique 하다고 했을 때, 이름으로 받아옴
  Future<CategoryModel> getCategoryWithName(String name) async{
    CategoryModel category;

    final querySnapshot = await _categoryRef.where('name', isEqualTo: name).get();

    final tmp =  querySnapshot.docs[0];

    category = CategoryModel.fromMap(tmp.data());


    return category;
  }

}