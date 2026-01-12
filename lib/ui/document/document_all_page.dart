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

    return Consumer<DocumentViewModel>(
      builder: (context, vm, _){
        final allDocs = vm.documents;
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DocumentListHeaderWidget(
                isOnAllPage: isOnAllPage,
                rootCategory: null,
                documentCount: allDocs.length,
              ),
              Expanded(
                child: isAllTotalPage
                    ? DocumentAllTotalPage()
                    : widget.contentPage,
              ),
            ],
          ),
        );
      }
    );
  }
}
