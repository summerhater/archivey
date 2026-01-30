import 'package:archivey/config/share_category_link_config.dart';
import 'package:archivey/data/service/kakao_sdk_share_service.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:archivey/ui/document/view_model/document_view_model.dart';
import 'package:archivey/utils/app_snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:archivey/ui/document/widget/document_card_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DocumentAllTotalPage extends StatefulWidget {
  final bool isBookmarkMode;
  final bool isLatest;
  const DocumentAllTotalPage({super.key, required this.isBookmarkMode, required this.isLatest});

  @override
  State<DocumentAllTotalPage> createState() => _DocumentAllTotalPageState();
}

class _DocumentAllTotalPageState extends State<DocumentAllTotalPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      displayDoc();
    });
  }

  @override
  void didUpdateWidget(covariant DocumentAllTotalPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isBookmarkMode != widget.isBookmarkMode ||
        oldWidget.isLatest != widget.isLatest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        displayDoc();
      });
    }

  }

  void displayDoc(){
   context.read<DocViewModel>().getDisplayDocuments(
      isLatestMode: widget.isLatest,
      isBookmarkMode: widget.isBookmarkMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Consumer<DocViewModel>(
        builder: (context, vm, _){
          List<DocumentModel> displayDocuments=vm.filteredDisplayDocuments;
          if (displayDocuments.isEmpty) {
            return Center(
              child: SizedBox(
                child: SvgPicture.asset(
                  vm.isSearching
                      ? 'assets/images/empty_state_no_search_result.svg'
                      : widget.isBookmarkMode
                      ? 'assets/images/empty_state_no_bookmark.svg'
                      : 'assets/images/empty_state_no_document.svg',
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: displayDocuments.length,
            itemBuilder: (context, index) {
              return DocumentCard(
                document: displayDocuments[index],
                isFirstItem: index == 0,
                outlineBorder: false,
                isOnAllPage: true,
                categoryName: vm.getRootCategoryNameByDocument(displayDocuments[index]),
                onDeleteConfirmed: () {
                  vm.deleteDocument(displayDocuments[index].id);
                },
                onCopyLinkConfirmed: () async {

                  await Clipboard.setData(ClipboardData(text: displayDocuments[index].url));
                  if(!context.mounted) return;
                  context.showAppMessageSnackBar('수집물 원문 링크가 복사되었습니다. ☻');
                },
                onShareKakaoConfirmed: () {
                  String originalUrl = displayDocuments[index].url;
                  String url = "${ShareCategoryLinkConfig.baseUrl}/share/go.html?target=$originalUrl";
                  vm.kakaoShareDocumentURL(url, displayDocuments[index]);
                },
              );
            },
          );
        }
      ),
    );
  }
}
