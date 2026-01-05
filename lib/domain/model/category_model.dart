class CategoryModel {
  final String uid;
  final String categoryId;
  final String categoryName;

  CategoryModel({
    required this.uid,
    required this.categoryId,
    required this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      uid: map['uid'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
    );
  }
}
