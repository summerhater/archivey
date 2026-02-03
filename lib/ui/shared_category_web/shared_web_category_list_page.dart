import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:archivey/ui/shared_category_web/view_model/shared_category_web_view_model.dart';
import 'package:archivey/ui/shared_category_web/widget/document_list_header_widget_for_web.dart';
import 'package:archivey/ui/document/widget/document_card_widget.dart';


class SharedCategoryWebPage extends StatefulWidget {
  final String shareId;
  const SharedCategoryWebPage({super.key, required this.shareId});

  @override
  State<SharedCategoryWebPage> createState() => _SharedCategoryWebPageState();
}

class _SharedCategoryWebPageState extends State<SharedCategoryWebPage> {
  String? _selectedSubId;
  bool _isLatest = true;
  bool _isBookmarkMode = false;

  ///selectedSubId가 null -> view에서의 selectedCategoryId은 rootCategoryId
  String get _getSelectedCategoryId {
    final viewModel = context.read<SharedCategoryWebViewModel>();
    return _selectedSubId ?? viewModel.categoryId;
  }

  void displayDoc(){
    context.read<SharedCategoryWebViewModel>().getDisplayDocuments(
      categoryId: _getSelectedCategoryId,
      isLatest: _isLatest,
      isBookmarkMode: _isBookmarkMode,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SharedCategoryWebViewModel>().initSharedWebState(widget.shareId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double imageWidth = constraints.maxWidth * 0.3;
            /// 웹 가로 너비가 800px 넘지 않게 제한
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Consumer<SharedCategoryWebViewModel>(
                  builder: (context, vm, _) {
                    if (vm.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (vm.errorMessage != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                vm.errorMessage!,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // 데이터 로드 실패 시 예외 처리
                    if (vm.category == null) {
                      return const Center(child: Text("카테고리 정보를 불러올 수 없습니다."));
                    }
                    final displayDocuments = vm.displayDocuments;
                    return SafeArea(
                      child: Column(
                        children: [
                          DocumentListHeaderWidgetForWeb(
                            rootCategory: vm.category,
                            documentCount: displayDocuments.length,
                            selectedSubCategory: (String? subId) {
                              setState(() {
                                _selectedSubId = subId;
                              });
                              displayDoc();
                            },
                            isLatest: _isLatest,
                            onDateSortPressed: () {
                              setState(() {
                                _isBookmarkMode = false;
                                _isLatest = !_isLatest;
                              });
                              displayDoc();
                            },
                            isBookmarkSelected: _isBookmarkMode,
                            onBookmarkSortPressed: () {
                              setState(() {
                                _isBookmarkMode = !_isBookmarkMode;
                              });
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
                                  width: imageWidth,
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
                                    outlineBorder: false,
                                    isOnAllPage: false,
                                    categoryName: vm.category!.categoryName,
                                    isWeb : true,
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  })
            );
          },
        ),
      ),
    );
  }
}