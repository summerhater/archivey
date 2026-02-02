import 'package:flutter/material.dart';

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  
  const DismissKeyboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 빈 공간 터치 감지
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // focus out
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
