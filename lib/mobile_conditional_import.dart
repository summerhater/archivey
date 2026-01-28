import 'dart:async';
import 'dart:ui';

import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

void initPathUrlStrategy(){
}

class SharingIntent {

  static StreamSubscription<dynamic> getMediaStream(Function(String sharedText)? go) {
    return FlutterSharingIntent.instance
        .getMediaStream()
        .listen(
          (List<SharedFile> value) {
        _handleSharingIntent(value,go);
        // print("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
      },
      onError: (err) {
        print("getIntentDataStream error: $err");
      },
    );
  }
  static void _handleSharingIntent(value,Function(String sharedText)? go) {
    if (value.isNotEmpty) {
      List<String> temp = [];

      for (final e in value) {
        if (e.value is String) {
          temp.add(e.value!);
        }
      }
      final sharedText = temp.join(' ');
      if(go !=null) {
        go(sharedText);
      }
    }
  }

  static void getInitialSharing(Function(String sharedText)? go) {
    FlutterSharingIntent.instance.getInitialSharing().then((
        List<SharedFile> value,) {
      print("Shared: getInitialMedia ${value.map((f) => f.value).join(",")}");
      _handleSharingIntent(value,go);
    });
  }
}