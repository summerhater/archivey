
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService() : _auth = FirebaseAuth.instance {
    _auth.setLanguageCode('kr');
  }

  User? get user => _auth.currentUser;

  /// 에러 메시지 매핑 함수
  String _mapAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return '이메일과 비밀번호를 확인해 주십시오.';
      case 'user-disabled':
        return '비활성화된 계정입니다. 관리자에게 문의하십시오.';
      case 'too-many-requests':
        return '로그인 시도 횟수를 초과했습니다. 잠시 후 다시 시도하십시오.';
      case 'network-request-failed':
        return '네트워크가 불안정합니다.';
      case 'internal-error':
        return 'SDK 문제입니다. 관리자에게 문의하십시오.';
      case 'email-not-verified':
        return '이메일 인증 후 로그인해주세요.';
      case 'email-already-in-use':
        return '이미 사용중인 이메일 입니다.';
      case 'user-not-found':
        return '회원을 찾을 수 없습니다.';
      default:
        return e.message ?? '알 수 없는 오류입니다.';
    }
  }

  /// Firebase Auth Exception throw 하는 함수, 모든 함수마다 들어가길래 리팩토링
  void _rethrowFirebaseAuthException(FirebaseAuthException e) {
    final message = _mapAuthErrorMessage(e);

    throw FirebaseAuthException(
      code: e.code,
      message: message,
    );
  }

  /// 유저 정보 구독, 유저 정보가 업데이트 될 때마다 갱신됨
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges().map((User? user) {
      if(user != null && user.emailVerified) {
        print('########### auth service 에서 uid: ${user.uid} #############');
        return user;
      } else {
        return null;
      }
    });
  }

  /// 이메일 패스워드 받아서 가입
  Future<String?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if(user != null) {
        await user.sendEmailVerification();

        return credential.user?.uid;
      }
    } on FirebaseAuthException catch (e) {
      _rethrowFirebaseAuthException(e);
    } catch (e) {
      throw Exception('알 수 없는 에러, $e');
    }
    return null;
  }

  /// 이메일 인증 여부
  Future<bool> isVerifyEmail() async {
    try{
      await user?.reload();

      final refreshedUser = _auth.currentUser;

      return refreshedUser!.emailVerified;
    } on FirebaseAuthException catch (e) {
      _rethrowFirebaseAuthException(e);
      return false;
    } catch (e) {
      throw Exception('알 수 없는 에러, $e');
    }
  }

  /// 비밀번호 받아서 업데이트
  // Future<void> signUpWithPassword({
  //   required String password,
  // }) async {
  //   String? errorMsg;
  //
  //   try {
  //     AuthCredential credential = EmailAuthProvider.credential(
  //       email: _auth.currentUser!.email!,
  //       password: tmpPw,
  //     );
  //     await _auth.currentUser?.reauthenticateWithCredential(credential);
  //     await _auth.currentUser?.updatePassword(password);
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case 'weak-password':
  //         errorMsg = '비밀번호는 6자리 이상이어야 합니다. ${e.message}';
  //         break;
  //       case 'user-not-found':
  //         errorMsg = '회원가입을 다시 진행하십시오. ${e.message}';
  //         break;
  //       case 'network-request-failed':
  //         errorMsg = '네트워크가 불안정합니다. ${e.message}';
  //         break;
  //       case 'internal-error':
  //         errorMsg = 'SDK문제, 관리자에게 문의하십시오. ${e.message}';
  //         break;
  //       default:
  //         errorMsg = '알 수 없는 에러입니다. ${e.message}';
  //     }
  //     throw Exception(errorMsg);
  //   } catch (e) {
  //     throw Exception('알 수 없는 에러, $e');
  //   }
  // }

  /// 이메일, 패스워드로 로그인
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String pw,
  }) async {
    try {
      if(user != null) logOut();

      await _auth.signInWithEmailAndPassword(email: email, password: pw);

      await user!.reload();

      if (!user!.emailVerified) {
        await reSendVerificationEmail();
        throw FirebaseAuthException(
          code: 'email-not-verified',
        );
      }
    } on FirebaseAuthException catch (e) {
      _rethrowFirebaseAuthException(e);
    } catch (e) {
      throw Exception('알 수 없는 에러, $e');
    }
  }

  /// 로그아웃
  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      final message = _mapAuthErrorMessage(e);

      throw FirebaseAuthException(
        code: e.code,
        message: message,
      );
    } catch (e) {
      throw Exception('알 수 없는 에러 $e');
    }
  }

  /// 이메일 재인증
  Future<void> reSendVerificationEmail() async {
    try {
      if (!await isVerifyEmail()) {
        await _auth.currentUser?.sendEmailVerification();
      } else {
        throw Exception('이메일 인증을 이미 완료했습니다.');
      }
    } on FirebaseAuthException catch (e) {
      final message = _mapAuthErrorMessage(e);

      throw FirebaseAuthException(
        code: e.code,
        message: message,
      );
    } catch (e) {
      throw Exception('알 수 없는 에러 $e');
    }
  }

  /// 사용자 재인증 -> 비밀번호 변경, 계정 삭제에 필요함
  ///
  /// 비밀번호 이메일로 재설정 시 필요 없음
  Future<void> reAuthentication(String password) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );

      await user?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final message = _mapAuthErrorMessage(e);

      throw FirebaseAuthException(code: e.code, message: message);
    } catch (e) {
      throw Exception('알 수 없는 에러, $e');
    }
  }

  /// 비밀번호 이메일 재설정
  Future<void> resetPasswordWithEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // errorMsg = '가입되지 않은 이메일 입니다. ${e.message}';
        // 계정 존재 여부 보안상, 성공 UX를 보냄
        print(e.message); // 로깅하는거 넣으면 대체. 일단은 print로
        throw FirebaseAuthException(
          code: e.code,
          message: '$email로 비밀번호 재설정 메일을 보냈습니다.',
        );
      }

      final message = _mapAuthErrorMessage(e);

      throw FirebaseAuthException(
        code: e.code,
        message: message,
      );
    } catch (e) {
      throw Exception('알 수 없는 에러, $e');
    }
  }

  /// 비밀번호 받아서 재설정, reAuthentication 필요
  Future<void> updatePassword(String newPassword) async {
    try {
      await user?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      _rethrowFirebaseAuthException(e);
    }
  }

  /// 계정 삭제, reAuthentication 필요
  Future<void> deleteAccount() async {
    try{
      await user?.delete();
    } on FirebaseAuthException catch (e) {
      _rethrowFirebaseAuthException(e);
    } catch (e) {
      throw Exception('알 수 없는 에러, $e');
    }
  }
}
