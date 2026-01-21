import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/domain/state/app_state.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier{

  final FirebaseAuthService _authService;
  AppState _appState;

  SettingViewModel(this._authService, this._appState);

  String get email => _appState.email;

  void updateState(AppState newState) {
    _appState = newState;
  }

  Future<void> logout() async{
    await _authService.logOut();
    notifyListeners();
  }

}