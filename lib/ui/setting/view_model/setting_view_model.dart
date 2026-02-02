import 'package:archivey/data/service/firebase_app_user_service.dart';
import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/domain/state/app_state.dart';
import 'package:archivey/utils/loading_widget.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier{

  final FirebaseAuthService _authService;
  final FirebaseAppUserService _userService;
  final AppState _appState;
  final LoadingProvider _loadingProvider;

  SettingViewModel(this._authService, this._userService, this._appState, this._loadingProvider,);

  String get email => _appState.email;
  bool isLoading = false;

  void _setLoading(bool isLoading) {
    this.isLoading = isLoading;
    if(isLoading) {
      _loadingProvider.startLoading();
    } else {
      _loadingProvider.stopLoading();
    }
  }

  /// 로그아웃
  Future<void> logout() async{
    if(isLoading) return;
    _setLoading(true);
    
    try {
      await _authService.logOut();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 재인증
  Future<bool> reAuthentication(String password) async{
    if(isLoading) return false;
    _setLoading(true);


    try{
      bool isReAuthentication = false;
      await _authService
          .reAuthentication(password)
          .then(
            (_) {
              isReAuthentication = true;
            },
          );
      return isReAuthentication;
    } catch (e, stackTrace) {
      print(stackTrace);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 계정 삭제
  Future<void> deleteAccount() async{
    if(isLoading) return;
    _setLoading(true);

    try{
      await _userService
          .deleteAccount(_appState.uid)
          .then((_) async => await _authService.deleteAccount());
    } catch(e){
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

}