import 'package:archivey/ui/document/widget/vertical_tab_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/color_scheme_extension.dart';

class DocumentShellPage extends StatefulWidget {
  final Widget contentPage;
  const DocumentShellPage({super.key, required this.contentPage});

  @override
  State<DocumentShellPage> createState() => _DocumentShellPageState();
}

class _DocumentShellPageState extends State<DocumentShellPage> {
  int selectedIndex = 0;

  void _onTapChanged (int idx) {
    setState(() {
      selectedIndex = idx;
    });

    switch (idx) {
      case 0:
        context.go('/document_all_total');
        break;

      case 1:
        context.go('/document/취업');
        break;

      case 2:
        context.go('/document/recipe');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;

    return Scaffold(
      backgroundColor: appColorScheme.primaryLight,
      body: Row(
        children: [
          Expanded(
            child: Scaffold(
              primary: true,
              backgroundColor: Colors.transparent,
              body: widget.contentPage,
            ),
          ),
          VerticalTabNavigation(
            onTapChanged: _onTapChanged,
            selectedIndex: selectedIndex,
          ),
        ],
      ),
    );
  }
}