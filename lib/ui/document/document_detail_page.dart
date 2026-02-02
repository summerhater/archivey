import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:archivey/ui/document/view_model/document_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import 'package:archivey/utils/app_snack_bar_widget.dart';
import 'package:archivey/ui/document/widget/document_card_widget.dart';
import 'package:archivey/ui/document/widget/more_icon_widget.dart';
import 'package:archivey/ui/document/widget/document_detail_tab_bar_widget.dart';
import 'package:archivey/ui/document/widget/document_detail_ai_summary_widget.dart';
import 'package:archivey/ui/document/widget/document_detail_memo_widget.dart';
import 'package:archivey/ui/document/widget/document_detail_tag_widget.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:provider/provider.dart';

class DocumentDetailPage extends StatefulWidget {
  final DocumentModel document;

  const DocumentDetailPage({
    super.key,
    required this.document,
  });

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  int _selectedTabIndex = 0;
  bool _isEditing = false;
  List<String>? _editingTags;

  late TextEditingController _memoController;
  final FocusNode _memoFocusNode = FocusNode();
  late TextEditingController _tagController;
  final FocusNode _tagFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Provider.of<DocViewModel>(context, listen: false);

    _editingTags = List.from(widget.document.tags);

    _memoController = TextEditingController(text: widget.document.userMemo);
    _memoFocusNode.addListener(_focusListener);

    _tagController = TextEditingController();
    _tagFocusNode.addListener(_focusListener);
  }

  ///포커스 해제 시 자동 저장
  void _focusListener() {
    if (!_memoFocusNode.hasFocus || !_tagFocusNode.hasFocus) {
      if (_isEditing) {
        _saveData(context);
      }
    }
  }

  Future<void> _saveData(BuildContext context) async {
    final documentVM = Provider.of<DocViewModel>(context, listen: false);

    ///위젯이 가진 데이터가 아닌 ViewModel(appState)의 최신 데이터와 비교
    final currentDoc = documentVM.documents.firstWhere(
          (doc) => doc.id == widget.document.id,
      orElse: () => widget.document,
    );

    final String currentMemo = _memoController.text.trim();

    ///최신 상태(currentDoc)와 현재 입력값 비교
    final bool isMemoChanged = currentDoc.userMemo != currentMemo;
    final bool isTagsChanged = !listEquals(currentDoc.tags, _editingTags);

    if (!isMemoChanged && !isTagsChanged) return; /// 변경사항 없으면 종료

    final docToUpdate = currentDoc.copyWith( /// widget이 아닌 최신 데이터를 베이스로 복사
      userMemo: currentMemo,
      tags: _editingTags,
    );

    try {
      documentVM.updateDocument(docToUpdate);

      if (isMemoChanged) {
        context.showAppMessageSnackBar('메모 수정이 완료되었습니다. ☻');
      }
      if (isTagsChanged) {
        context.showAppMessageSnackBar('태그 수정이 완료되었습니다. ☻');
      }
      setState(() {
        _editingTags = List.from(docToUpdate.tags);
      });
    } catch (e) {
      print("저장 중 오류 발생: $e");
    }
  }

  List<String> _getDisplayTags(DocumentModel doc) {
    if (_isEditing) {
      return _editingTags ?? List.from(doc.tags);
    }
    return List.from(doc.tags);
  }

  @override
  void dispose() {
    _memoController.dispose();
    _tagController.dispose();
    _memoFocusNode.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

    return Consumer<DocViewModel>(
      builder: (context, vm, _) {
        final currentDoc = vm.getDocumentById(widget.document.id, fallback: widget.document);
        final List<String> displayTags = _getDisplayTags(currentDoc);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: appColorScheme.documentDetailBg,
          appBar: AppBar(
            backgroundColor: appColorScheme.primary,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 18),
              color: appColorScheme.textDark,
              onPressed: () {
                context.pop();
              },
            ),
            actions: [
              MoreIconWidget(
                moreIconSettingMode: MoreIconSettingMode.documentDetail,
                onEditPressed: () {
                  setState(() {
                    _editingTags = List.from(currentDoc.tags);
                    _isEditing = true;
                    if (_selectedTabIndex == 0) {
                      _selectedTabIndex = 1;
                    }
                  });
                },
              ),
              SizedBox(width: 10),
            ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                    child: DocumentCard(
                      document: currentDoc,
                      isFirstItem: false,
                      outlineBorder: true,
                      showBottomBorder: false,
                      isOnAllPage: true,
                      categoryName: vm.getRootCategoryNameByDocument(currentDoc),
                    ),
                  ),

                  /// 겹쳐진 탭바 (ai요약, 메모, 태그)
                  DocumentDetailTabBarWidget(
                    selectedIndex: _selectedTabIndex,
                    onTabChanged: (index) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    tabs: ['AI 요약', 'memo', 'tag'],
                  ),

                  /// 탭 내용
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5, // 예: 화면 높이의 절반 차지
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 25,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: appColorScheme.primary,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: appColorScheme.strokeLight,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: _buildTabContent(
                                      appColorScheme,
                                      appTextTheme,
                                      currentDoc,
                                      displayTags,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 21,
                          child: Container(
                            width: 253,
                            height: 1.5,
                            decoration: BoxDecoration(
                              color: appColorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 30),
                ],
              ),
            ),
          ),
        );
      });
  }

  Widget _buildTabContent(
    AppColorScheme appColorScheme,
    AppTextTheme appTextTheme,
    DocumentModel currentDoc,
      List<String> tags,
  ) {
    if (_selectedTabIndex == 0) {
      return DocumentDetailAiSummaryWidget(aiSummary: currentDoc.aiSummary);
    } else if (_selectedTabIndex == 1) {
      return DocumentDetailMemoWidget(
        isEditing: _isEditing,
        memo: currentDoc.userMemo,
        controller: _memoController,
        focusNode: _memoFocusNode,
      );
    } else {
      return DocumentDetailTagWidget(
        isEditing: _isEditing,
        tags: _editingTags ?? [],
        controller: _tagController,
        focusNode: _tagFocusNode,
        onTagDeleted: (tag) {
          setState(() {
            _editingTags?.remove(tag);
          });
        },
        onTagAdded: (value) {
          if (tags.length >= 4) {
            context.showAppMessageSnackBar('태그는 최대 4개까지만 등록 할 수 있어요!');
          } else {
            setState(() {
              _editingTags ??= [];
              _editingTags!.add(value);
              _tagController.clear();
            });
          }
          _tagFocusNode.requestFocus();
        },
      );
    }
  }
}
