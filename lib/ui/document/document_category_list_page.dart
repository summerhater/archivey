import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
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
  String? _selectedSubId; // 현재 선택된 서브 카테고리 ID 저장 변수
  bool _isLatest = true;

  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryViewModel>();
    final documentVM = context.watch<DocumentViewModel>();

    // 1. 현재 탭 이름에 해당하는 Root 카테고리 찾기
    CategoryModel? rootCategory;
    try {
      //todo: jh : category ID로 비교하는게 더 좋은 방식
      rootCategory = categoryVM.rootCategories.firstWhere(
            (c) => c.categoryId == widget.categoryId,
      );
    } catch (e) {
      print('rootCategory is null');
      rootCategory = null;
    }

    // 필터링 로직
    List<DocumentModel> displayDocuments = [];

    if (widget.categoryName == 'ALL') {
      // 'ALL' 탭일 때는 모든 도큐먼트 표시
      displayDocuments = documentVM.documents;
        print('displayDocuments in ALL: ${displayDocuments.length}');
    } else if (rootCategory != null) {
      if (_selectedSubId == null) {
        // '전체' 칩 선택 시: 현재 카테고리 ID + 하위 서브 카테고리 ID들 포함
        displayDocuments = documentVM.documents
            .where((doc) => categoryVM.getFamilyCategories(rootCategory!.categoryId).contains(doc.category.categoryId))
            .toList();
      } else {
        // 특정 서브 카테고리 칩 선택 시: 해당 ID만 필터링
        documentVM.getDocumentsByCategoryId(_selectedSubId!);
      }
    }

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
