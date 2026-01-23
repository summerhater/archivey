import 'package:archivey/domain/model/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAppUserService {

  final String users = 'users';

  final _firestore = FirebaseFirestore.instance;
  late final _userRef = _firestore.collection(users);

  /// 회원가입 시, db에도 회원 추가
  Future<void> userRegistration({required String? uid, required AppUser appUser}) async{
    String? errorMsg;

    try {
      await _userRef.doc(uid).set(appUser.toJson());
    }on FirebaseException catch(e) {
      switch(e.code) {
        case 'resource-exhausted':
          errorMsg = '한도초과, 관리자에게 문의하십시오. ${e.message}';
          break;
        case 'unavailable':
          errorMsg = '네트워크가 불안정합니다. ${e.message}';
          break;
        default:
          errorMsg = '알 수 없는 에러입니다. ${e.message}';
          break;
      }
      throw Exception(errorMsg);
    } catch(e) {
      throw Exception('알 수 없는 에러 $e');
    }
  }

  /// 이메일 중복 체크
  Future<bool> isAlreadyExistEmail(String email) async{
    try {
      final QuerySnapshot snapshot = await _userRef.where('email', isEqualTo: email).get();
      return snapshot.docs.isNotEmpty;
    } catch(e) {
      throw Exception(e);
    }
  }
  
  /// 회원 삭제
  Future<void> deleteAccount(String uid) async{
    await _userRef.doc(uid).delete();
  }

}