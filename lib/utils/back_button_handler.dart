import 'package:archivey/utils/app_snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackButtonHandler extends StatefulWidget {
  final Widget child;

  const BackButtonHandler({super.key, required this.child});

  @override
  State<BackButtonHandler> createState() => _BackButtonHandlerState();
}

class _BackButtonHandlerState extends State<BackButtonHandler> {

  DateTime? currentBackPressTime;

  bool get _onPressed {
    DateTime now = DateTime.now();

    if(currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      // Future.delayed(const Duration(seconds: 2), () {
      //   if(mounted) {
      //     setState(() {
      //       currentBackPressTime = null;
      //     });
      //   }
      // },);

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if(didPop) {
          return;
        }

        if(_onPressed) {
          SystemNavigator.pop();
        } else {
          context.showAppMessageSnackBar('"뒤로" 버튼을 한 번 더 누르면 종료됩니다.');
        };
      },
      child: widget.child,
    );
  }
}
