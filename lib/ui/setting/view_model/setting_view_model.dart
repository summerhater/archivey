import 'package:archivey/data/service/firebase_app_user_service.dart';
import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/domain/state/app_state.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier{

  final FirebaseAuthService _authService;
  final FirebaseAppUserService _userService;
  AppState _appState;

  SettingViewModel(this._authService, this._userService, this._appState,);

  String get email => _appState.email;

  void updateState(AppState newState) {
    _appState = newState;
  }

  Future<void> logout() async{
    await _authService.logOut();
    notifyListeners();
  }

  Future<bool> reAuthentication(String password) async{
    bool isReAuthentication = false;
    await _authService.reAuthentication(password).then(
      (value) {
        isReAuthentication = true;
      },
    ).onError((error, stackTrace) {
      print('re authentication error: $error');
      print(stackTrace);
      isReAuthentication = false;
    });

    return isReAuthentication;
  }

  Future<void> deleteAccount() async{
    await _userService.deleteAccount(_appState.uid).then((_) async => await _authService.deleteAccount());
  }

}