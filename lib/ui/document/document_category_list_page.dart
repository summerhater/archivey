import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:archivey/ui/document/view_model/document_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/document_card_widget.dart';
import 'package:archivey/ui/document/widget/document_list_header_widget.dart';

class DocumentCategoryListPage extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const DocumentCategoryListPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<DocumentCategoryListPage> createState() => _DocumentCategoryListPageState();
}

class _DocumentCategoryListPageState extends State<DocumentCategoryListPage> {
  String? _selectedSubId;
  bool _isLatest = true;


  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryViewModel>();
    final documentVM = context.watch<DocViewModel>();
    // final documentVM = context.watch<DocumentViewModel>();

    /// categoryId에 해당하는 Root 카테고리 찾기
    CategoryModel? rootCategory;
    try {
      rootCategory = categoryVM.getCategory(widget.categoryId);
    } catch (e) {
      print('category list page error : $e');
    }

    List<DocumentModel> displayDocuments = [];

    if (_isLatest) {
      displayDocuments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      displayDocuments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return SafeArea(
      child: Column(
        children: [
          DocumentListHeaderWidget(
            isOnAllPage: false,
            rootCategory: rootCategory!,
            documentCount: displayDocuments.length,
            selectedSubCategory: (String? subId) {
              setState(() {
                _selectedSubId = subId;
              });
            },
            isLatest: _isLatest,
            onDateSortPressed: () {
              setState(() {
                _isLatest = !_isLatest;
              });
            },
          ),
          if (displayDocuments.isEmpty)
            const Expanded(child: Center(child: Text('해당 카테고리에 글이 없습니다.')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: displayDocuments.length,
                itemBuilder: (context, index) {
                  return DocumentCard(
                    document: displayDocuments[index],
                    isFirstItem: index == 0,
                    isDetailPage: false,
                    isOnAllPage: false,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
