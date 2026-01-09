class CategoryModel {
  final String uid;
  final String categoryId;
  final String categoryName;
  final int order;

  CategoryModel({
    required this.uid,
    required this.categoryId,
    required this.categoryName,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'order': order,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      uid: map['uid'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      order: map['order'],
    );
  }
}
