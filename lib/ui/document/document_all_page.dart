import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/document_list_header_widget.dart';
import 'document_all_total_page.dart';

class DocumentAllPage extends StatefulWidget {
  final Widget contentPage;
  const DocumentAllPage({super.key, required this.contentPage});
  @override
  State<DocumentAllPage> createState() => _DocumentAllPageState();
}

class _DocumentAllPageState extends State<DocumentAllPage> {
  final List<DocumentModel> _allDocs = DocumentDummyData.getDummyDocuments();
  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final bool isAllTotalPage = currentLocation.contains('all_total');
    final bool isOnAllPage =
        currentLocation.contains('all_total') ||
        currentLocation.contains('all_index');

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DocumentListHeaderWidget(
            isOnAllPage: isOnAllPage,
          ),
          Expanded(
            child: isAllTotalPage
                ? DocumentAllTotalPage(documents: _allDocs)
                : widget.contentPage,
          ),
        ],
      ),
    );
  }
}
