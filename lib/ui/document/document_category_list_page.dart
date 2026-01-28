import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:archivey/ui/document/widget/document_card_widget.dart';
import 'package:archivey/ui/document/widget/document_list_header_widget.dart';


//todo: jh all_total_page와, category_list_page가 filter 처리 방식이 다름. 일치되어야함.
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
  late String _selectedCategoryId;
  bool _isLatest = true;
  bool _isBookmarkMode = false;

  ///selectedSubId가 null -> view에서의 selectedCategoryId은 rootCategoryId
  String get _getSelectedCategoryId {
    return _selectedSubId ?? widget.categoryId;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      displayDoc();
    });

  }

  void displayDoc(){
    context.read<DocViewModel>().getDisplayDocuments(
      categoryId: _getSelectedCategoryId,
      isLatestMode: _isLatest,
      isBookmarkMode: _isBookmarkMode,
    );
  }

  @override
  void didUpdateWidget(covariant DocumentCategoryListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        displayDoc();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocViewModel>(
        builder: (context, vm, _) {
          final displayDocuments = vm.filteredDisplayDocuments;

          return SafeArea(
            child: Column(
              children: [
                DocumentListHeaderWidget(
                  isOnAllPage: false,
                  rootCategory: vm.getCategory(widget.categoryId),
                  documentCount: displayDocuments.length,
                  selectedSubCategory: (String? subId) {
                    _selectedSubId = subId;
                    displayDoc();
                  },
                  isLatest: _isLatest,
                  onDateSortPressed: () {
                    _isBookmarkMode = false;
                    _isLatest = !_isLatest;
                    displayDoc();
                  },
                  isBookmarkSelected: _isBookmarkMode,
                  onBookmarkSortPressed: () {
                    _isBookmarkMode = !_isBookmarkMode;
                    displayDoc();
                  },
                ),
                if (displayDocuments.isEmpty)
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        vm.isSearching
                            ? 'assets/images/empty_state_no_search_result.svg'
                            : _isBookmarkMode
                            ? 'assets/images/empty_state_no_bookmark.svg'
                            : 'assets/images/empty_state_no_document.svg',
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                    ),
                  )
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
        });
  }
}
