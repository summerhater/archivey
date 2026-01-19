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

  CategoryModel copyWith({
    String? uid,
    String? categoryId,
    String? categoryName,
    int? order,
    String? parentId,
  }) {
    return CategoryModel(
      uid: uid ?? this.uid,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      order: order ?? this.order,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'parentId' : parentId,
      'order': order,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      uid: map['uid'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      order: (map['order'] as num?)?.toInt(),
      parentId: map['parentId'] as String?,
    );
  }
}
