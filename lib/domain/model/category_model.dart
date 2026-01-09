class CategoryModel {
  final String uid;
  final String categoryId;
  final String categoryName;
  final int? order;
  final String? parentId;

  CategoryModel({
    required this.uid,
    required this.categoryId,
    required this.categoryName,
    this.order,
    this.parentId,
  });

  ///parentId가 null이면 루트 카테고리, != null이면 서브 카테고리
  bool get isRootCategory => parentId == null;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'order' : order,
      'parentId' : parentId,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      uid: map['uid'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      order: map['order'] as int?,
      parentId: map['parentId'] as String?,
    );
  }
}
