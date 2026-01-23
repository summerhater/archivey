import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/ui/document/document_all_index_page.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:archivey/ui/document/view_model/document_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:archivey/ui/document/widget/document_list_header_widget.dart';
import 'document_all_total_page.dart';


class DocumentAllPage extends StatefulWidget {
  final Widget contentPage;
  const DocumentAllPage({super.key, required this.contentPage});
  @override
  State<DocumentAllPage> createState() => _DocumentAllPageState();
}

class _DocumentAllPageState extends State<DocumentAllPage> {
  bool _isLatest = true;
  bool _isBookmarkMode = false;

  @override
  void initState() {
    // Provider.of<DocumentViewModel>(context, listen: false).readDocuments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final bool isAllTotalPage = currentLocation.contains('all_total');
    final bool isOnAllPage =
        currentLocation.contains('all_total') ||
            currentLocation.contains('all_index');

    return Consumer<DocViewModel>(
        builder: (context, vm, _) {
          final bool showIndexPage = vm.rootCategories.isEmpty;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DocumentListHeaderWidget(
                  isOnAllPage: isOnAllPage || showIndexPage,
                  rootCategory: null,
                  documentCount: vm.documents.length,
                  isLatest: _isLatest,
                  onDateSortPressed: () {
                    setState(() {
                      _isBookmarkMode = false;
                      _isLatest = !_isLatest;
                    });
                  },
                  isBookmarkSelected: _isBookmarkMode,
                  onBookmarkSortPressed: () {
                    setState(() {
                      _isBookmarkMode = !_isBookmarkMode;
                    });
                  },
                ),
                Expanded(
                  child: (isAllTotalPage && !showIndexPage)
                      ? DocumentAllTotalPage(isBookmarkMode: _isBookmarkMode, isLatest: _isLatest)
                      : DocumentAllIndexPage(), /// 카테고리 없으면 강제로 IndexPage 노출
                ),
              ],
            ),
          );
        }
    );
  }
}
