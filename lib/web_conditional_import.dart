import 'dart:async';
import 'package:web/web.dart' as web;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
class SharingIntent {
  static StreamSubscription<dynamic>? getMediaStream(Function(String sharedText)? go){

  }
  static void getInitialSharing(Function(String sharedText)? go){
  }
}

bool initPathUrlStrategyAndWebPathAccess(){
  usePathUrlStrategy();
  final String currentPath = web.window.location.pathname;

  if (!currentPath.startsWith('/share/category/')) {
    web.window.location.href = "https://www.notion.so/archivey-2e6299c18862802a91ddcc7dce6f10b0";
    return false; /// 앱 실행X (리다이렉트 발생)
  }
  return true;
}