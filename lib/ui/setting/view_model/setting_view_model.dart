import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier{

  final FirebaseAuthService _authService;

  SettingViewModel(this._authService);

  String get email => _authService.user?.email ?? '';

  Future<void> logout() async{
    await _authService.logOut();
    notifyListeners();
  }

}