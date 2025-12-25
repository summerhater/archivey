import 'package:archivey/data/service/firebase_app_user_service.dart';
import 'package:archivey/data/service/firebase_auth_service.dart';
import 'package:archivey/domain/model/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final FirebaseAppUserService _userService;

  String getEmail = '';

  AuthViewModel(this._authService, this._userService);

  bool isLoading = false;

  User? get user => _authService.user;

  void _setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  /// 이메일 중복 확인
  Future<void> isAlreadyExistEmail(String email) async {
    bool result = false;

    if (email.isEmpty) {
      throw Exception('이메일을 입력하세요.');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('유효한 이메일 형식이 아닙니다.');
    }

    if (isLoading) return;
    _setLoading(true);

    try {
      result = await _userService.isAlreadyExistEmail(email.trim());
      getEmail = email.trim();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }

    _setLoading(false);

    if (result) {
      getEmail = '';
      throw Exception('사용중인 이메일 입니다.');
    }
  }

  /// 패스워드 받아서 저장된 이메일과 같이 회원가입
  Future<void> signUpWithEmailAndPassword(String pw, pwVerify) async {
    if (pw.isEmpty) throw Exception('비밀번호를 입력하세요.');
    if (pw.length < 6) throw Exception('비밀번호는 6자리 이상이어야 합니다.');
    if (pw != pwVerify) throw Exception('비밀번호가 일치하지 않습니다.');

    if (isLoading) return;
    _setLoading(true);

    try {
      await _authService.signUpWithEmailAndPassword(
        email: getEmail,
        password: pw,
      );
      await _userService.userRegistration(
        uid: user?.uid,
        appUser: AppUser(email: getEmail, createAt: DateTime.now()),
      );
    } catch (e) {
      _setLoading(false);
      rethrow;
    }

    _setLoading(false);
  }

  /// 이메일 인증 확인
  Future<void> isVerifyEmail() async {
    if (isLoading) return;
    _setLoading(true);

    try {
      if (!await _authService.isVerifyEmail())
        throw Exception('이메일 인증이 완료되지 않았습니다.');
    } catch (e) {
      _setLoading(false);
      throw Exception(e);
    }

    _setLoading(false);
  }

  /// 로그인
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String pw,
  }) async {
    if (email.isEmpty) {
      throw Exception('이메일을 입력하세요.');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('유효한 이메일 형식이 아닙니다.');
    }

    if (isLoading) return;
    _setLoading(true);

    try {
      await _authService.signInWithEmailAndPassword(email: email, pw: pw);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }

    _setLoading(false);
  }

  /// 비밀번호 재설정
  Future<void> resetPasswordWithEmail(String email) async {
    if (email.isEmpty) {
      throw Exception('이메일을 입력하세요.');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('유효한 이메일 형식이 아닙니다.');
    }

    if (isLoading) return;
    _setLoading(true);

    try {
      await _authService.resetPasswordWithEmail(email.trim());
    } catch (e) {
      _setLoading(false);
      rethrow;
    }

    _setLoading(false);
  }
}
