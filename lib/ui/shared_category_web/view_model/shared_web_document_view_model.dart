import 'package:archivey/data/service/firebase_document_service.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/domain/state/shared_web_state.dart';
import 'package:flutter/material.dart';

class SharedWebDocumentViewModel extends ChangeNotifier {
  final FirebaseDocumentService _firebaseDocumentService;
  final SharedWebState _sharedWebState;

  SharedWebDocumentViewModel(
    this._firebaseDocumentService,
    this._sharedWebState,
  );

  Future<void> readDocumentsByCategoryId(String categoryId) async {
    try {
      final List<DocumentModel> docs = await _firebaseDocumentService
          .getDocumentsByCategory(categoryId);
      _sharedWebState.setDocuments(docs);
    } catch (e) {
      print('error in readDocumentsByCategoryId: $e');
    }
  }
}
