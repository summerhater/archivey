import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier{
  String _uid = '';
  String _email = '';
  List<CategoryModel> _categories = [];
  List<DocumentModel> _documents = [];


  String get uid {
    print('############# get uid $_uid ################');
    return _uid;
  }

  String get email => _email;
  List<CategoryModel> get categories => _categories;
  List<DocumentModel> get documents => _documents;

  void setUid(String? newUid) {
    _uid = newUid ?? '';
    print('############ set uid $newUid, 저장한 후 $_uid ################');
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