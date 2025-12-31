import 'package:flutter/material.dart';
import '../../domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/document_card_widget.dart';
import 'package:archivey/ui/document/widget/document_list_header_widget.dart';

class DocumentCategoryPageListPage extends StatelessWidget {
  final String category;

  const DocumentCategoryPageListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    /// 전체 수집물 로드
    final allDocuments = DocumentDummyData.getDummyDocuments();

    ///카테고리 필터링 로직 - 'ALL'이면 전체 반환, 아니면 해당 카테고리와 일치하는 것만 필터링
    final List<DocumentModel> displayDocuments = category == 'ALL'
        ? allDocuments
        : allDocuments.where((doc) => doc.category == category).toList();

    return SafeArea(
      child: Column(
        children: [
          DocumentListHeaderWidget(isOnAllPage: false,),
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
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
