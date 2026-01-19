import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:archivey/ui/document/view_model/document_view_model.dart';
import 'package:flutter/material.dart';
import 'package:archivey/ui/document/widget/document_card_widget.dart';
import 'package:provider/provider.dart';

class DocumentAllTotalPage extends StatefulWidget {

  /// 기본값 강제로 빈 리스트 반환해서 GoRouter 에러 방지
  const DocumentAllTotalPage({super.key});

  @override
  State<DocumentAllTotalPage> createState() => _DocumentAllTotalPageState();
}

class _DocumentAllTotalPageState extends State<DocumentAllTotalPage> {

  @override
  void initState() {
    super.initState();
    // Provider.of<DocumentViewModel>(context, listen: false).readDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocViewModel>(
      builder: (context, vm, _){
        if (vm.documents.isEmpty) {
          return const Center(child: Text("수집물이 없습니다."));
        }
        return ListView.builder(
          itemCount: vm.documents.length,
          itemBuilder: (context, index) {
            return DocumentCard(
              document: vm.documents[index],
              isFirstItem: index == 0,
              isDetailPage: false,
              isOnAllPage: true,
            );
          },
        );
      }
    );
  }
}
