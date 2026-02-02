import 'package:archivey/ui/auth/widget/sign_up_cancel_dialog.dart';
import 'package:flutter/material.dart';

class SignUpBackButtonHandler extends StatefulWidget {
  final Widget child;

  const SignUpBackButtonHandler({super.key, required this.child});

  @override
  State<SignUpBackButtonHandler> createState() => _SignUpBackButtonHandlerState();
}

class _SignUpBackButtonHandlerState extends State<SignUpBackButtonHandler> {
  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if(didPop) {
            return;
          }

          final isCancel = await showDialog(context: context, builder: (context) => SignUpCancelDialog(),) ?? false;

          if(isCancel && context.mounted) {
            Navigator.of(context).pop();
          }
        },
      child: widget.child
    );
  }
}
