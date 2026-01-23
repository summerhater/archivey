import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier{
// TODO VM이 이거 쓰게 만들기
  String _uid = '';
  String _email = '';
  List<CategoryModel> _categories = [];
  List<DocumentModel> _documents = [];

  String get uid => _uid;
  String get email => _email;
  List<CategoryModel> get categories => _categories;
  List<DocumentModel> get documents => _documents;
  AppState(){
    print('create app state');
  }
  void setUid(String? newUid) {
    _uid = newUid ?? '';
    notifyListeners();
  }

  void setEmail(String? newEmail) {
    _email = newEmail ?? '';
    notifyListeners();
  }

  void setCategories(List<CategoryModel> newCategories) {
    _categories = newCategories;
    notifyListeners();
  }

  void setDocuments(List<DocumentModel> newDocuments) {
    _documents = newDocuments;
    notifyListeners();
  }

}