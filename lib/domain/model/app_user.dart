import 'package:archivey/domain/model/document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String email;
  final DateTime? createAt;
  final List<Document>? docList; // db에는 저장 하지 않고, sub collection을 받아와 넣어줄 것

  AppUser({
    required this.email,
    this.createAt,
    this.docList,
  });

  factory AppUser.fromJson(Map<String, dynamic> data) {

    final Timestamp createAt = data['createAt'];

    return AppUser(
      email: data['email'],
      createAt: createAt.toDate(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'createAt': createAt,
    };
  }
}
