import 'package:cloud_firestore/cloud_firestore.dart';

class SharedCategoryLinkModel {
  final String shareId;
  final String ownerUid;
  final String categoryId;
  final DateTime? createdAt;

  SharedCategoryLinkModel({
    required this.shareId,
    required this.ownerUid,
    required this.categoryId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sharedId' : shareId,
      'ownerUid': ownerUid,
      'categoryId': categoryId,
      'createdAt': createdAt,
    };
  }

  factory SharedCategoryLinkModel.fromMap(String id, Map<String, dynamic> map) {
    return SharedCategoryLinkModel(
      shareId: id,
      ownerUid: map['ownerUid'] ?? '',
      categoryId: map['categoryId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}