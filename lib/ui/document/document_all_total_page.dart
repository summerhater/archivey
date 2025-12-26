import 'package:archivey/ui/document/widget/document_list_card_widget.dart';
import 'package:archivey/ui/document/widget/document_list_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/domain/model/document_model.dart';

class DocumentAllTotalPage extends StatelessWidget {
  final List<DocumentModel> documents; // 부모로부터 주입받음

  // 기본값을 주어 GoRouter 에러 방지
  const DocumentAllTotalPage({super.key, this.documents = const []});

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return const Center(child: Text("수집물이 없습니다."));
    }

    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return DocumentCard(
          document: documents[index],
          isFirstItem: index == 0,
          isDetailPage: false,
        );
      },
    );
  }
}