import 'dart:async';

import 'package:archivey/data/service/drift_document_service.dart';
import 'package:archivey/data/service/firebase_app_user_service.dart';
import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/domain/model/app_user.dart';
import 'package:archivey/domain/state/app_state.dart';
import 'package:archivey/utils/loading_widget.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final FirebaseAppUserService _userService;
  final AppState _appState;
  final DriftDocumentService _driftDocumentService;
  final LoadingProvider _loadingProvider;

  AuthViewModel(this._authService, this._userService, this._appState, this._driftDocumentService, this._loadingProvider){
    print('########################## 앱 시작해서 user 정보 받아오려고 함!!!!');
    fetchUser();
  }

  String inputEmail = '';

  bool isLoading = false;

  // void updateState(AppState newState) {
  //   _appState = newState;
  // }

  void _setLoading(bool isLoading) {
    this.isLoading = isLoading;
    if(isLoading) {
      _loadingProvider.startLoading();
    } else {
      _loadingProvider.stopLoading();
    }
  }

  /// 앱 시작 시, user 정보 불러오기
  void fetchUser() {
    _authService.authStateChanges().listen((user) async{
      if(user == null) {
        print('############### user 없음 #################');
        print('############### 새로고침됨 #################');
        print('############### 1111새로고침됨 #################');
        print('############### 2222새로고침됨 #################');
        _appState.setUid(null);
        _appState.setEmail(null);
        _appState.setCategories([]);
        _appState.setDocuments([]);

      } else {
        print('################## user 있음 ##################');
        _appState.setUid(_authService.user?.uid);
        _appState.setEmail(_authService.user?.email);
        print('############### auth view model 에서 app state의 uid: ${_appState.uid}');
        await _driftDocumentService.ensureUserSettings(_appState.uid);
      }
    });
  }

  /// 이메일 중복 확인
  Future<void> isAlreadyExistEmail(String email) async {
    if (email.isEmpty) {
      throw '이메일을 입력하세요.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw '유효한 이메일 형식이 아닙니다.';
    }

    if (isLoading) return;
    _setLoading(true);

    try {
      final result = await _userService.isAlreadyExistEmail(email.trim());

      if (result) {
        inputEmail = '';
        throw '사용중인 이메일 입니다.';
      } else {
        inputEmail = email.trim();
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 패스워드 받아서 저장된 이메일과 같이 회원가입
  Future<void> signUpWithEmailAndPassword(String pw, pwVerify) async {
    if (pw.isEmpty) throw '비밀번호를 입력하세요.';
    if (pw.length < 6) throw '비밀번호는 6자리 이상이어야 합니다.';
    if (pw != pwVerify) throw '비밀번호가 일치하지 않습니다.';

    if (isLoading) return;
    _setLoading(true);

    try {
      final uid = await _authService.signUpWithEmailAndPassword(
        email: inputEmail,
        password: pw,
      );
      if(uid == null) throw '알 수 없는 에러입니다.';
      await _userService.userRegistration(
        uid: uid,
        appUser: AppUser(email: inputEmail, createAt: DateTime.now()),
      );
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }

  }

  /// 이메일 인증 확인
  Future<void> isVerifyEmail() async {
    if (isLoading) return;
    _setLoading(true);

    try {
      if (!await _authService.isVerifyEmail()) {
        throw '이메일 인증이 완료되지 않았습니다.';
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 로그인
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String pw,
  }) async {
    if (email.isEmpty) {
      throw '이메일을 입력하세요.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw '유효한 이메일 형식이 아닙니다.';
    }

    if (isLoading) return;
    _setLoading(true);

    try {
      await _authService.signInWithEmailAndPassword(email: email, pw: pw);
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 비밀번호 재설정
  Future<void> resetPasswordWithEmail(String email) async {
    if (email.isEmpty) {
      throw '이메일을 입력하세요.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw '유효한 이메일 형식이 아닙니다.';
    }

    if (isLoading) return;
    _setLoading(true);

    try {
      await _authService.resetPasswordWithEmail(email.trim());
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
