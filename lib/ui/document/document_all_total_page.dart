import 'package:flutter/material.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/document_card_widget.dart';

class DocumentAllTotalPage extends StatelessWidget {
  final List<DocumentModel> documents;

  /// 기본값 강제로 빈 리스트 반환해서 GoRouter 에러 방지
  const DocumentAllTotalPage({super.key, this.documents = const []});

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return const Center(child: Text("수집물이 없습니다."));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return DocumentCard(
                  document: documents[index],
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
