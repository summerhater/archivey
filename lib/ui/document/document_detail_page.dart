import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/config/text_theme_extension.dart';
import '../../domain/model/document_model.dart';
import 'package:archivey/ui/document/widget/app_snack_bar_widget.dart';
import 'package:archivey/ui/document/widget/document_card_widget.dart';
import 'package:archivey/ui/document/widget/more_icon_widget.dart';
import 'package:archivey/ui/document/widget/document_detail_tab_bar_widget.dart';
import 'package:archivey/ui/document/widget/document_detail_ai_summary_widget.dart';
import 'package:archivey/ui/document/widget/document_detail_memo_widget.dart';
import 'package:archivey/ui/document/widget/document_detail_tag_widget.dart';

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

  late TextEditingController _memoController;
  final FocusNode _memoFocusNode = FocusNode();
  late TextEditingController _tagController;
  final FocusNode _tagFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.document.memo);
    _memoFocusNode.addListener(_focusListener);

    ///메모 포커스 리스너
    _tagController = TextEditingController();
    _tagFocusNode.addListener(_focusListener);

    ///태그 포커스 리스너 추가
  }

  ///포커스 해제 시 자동 저장
  void _focusListener() {
    if (!_memoFocusNode.hasFocus && !_tagFocusNode.hasFocus) {
      if (_isEditing) {
        _saveData();
        setState(() {
          _isEditing = false;
        });
      }
    }
  }

  void _saveData() {
    /// db 저장하는 로직 호출 필요
    print("자동 저장: ${_memoController.text}");
    setState(() => _isEditing = false);
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

    return Scaffold(
      backgroundColor: appColorScheme.documentDetailBg,
      appBar: AppBar(
        backgroundColor: appColorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18),
          color: appColorScheme.textDark,
          onPressed: () => context.pop(),
        ),
        actions: [
          MoreIconWidget(
            moreIconSettingMode: MoreIconSettingMode.documentDetail,
            onEditPressed: () {
              setState(() {
                _isEditing = true;
                _selectedTabIndex = 1;
              });
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            /// 선택한 수집물 카드 ui
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DocumentCard(
                document: widget.document,
                isFirstItem: false,
                isDetailPage: true,
                showBottomBorder: false,
              ),
            ),

            /// 겹쳐진 탭바 (ai요약, 메모, 태그)
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: DocumentDetailTabBarWidget(
                selectedIndex: _selectedTabIndex,
                onTabChanged: (index) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                tabs: ['AI 요약', 'memo', 'tag'],
              ),
            ),

            /// 탭 내용
            Expanded(
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
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    AppColorScheme appColorScheme,
    AppTextTheme appTextTheme,
  ) {
    if (_selectedTabIndex == 0) {
      return DocumentDetailAiSummaryWidget();
    } else if (_selectedTabIndex == 1) {
      return DocumentDetailMemoWidget(
        isEditing: _isEditing,
        memo: widget.document.memo,
        controller: _memoController,
        focusNode: _memoFocusNode,
      );
    } else {
      return DocumentDetailTagWidget(
        isEditing: _isEditing,
        tags: widget.document.tags ?? [],
        controller: _tagController,
        focusNode: _tagFocusNode,
        onTagDeleted: (tag) {
          setState(() {
            widget.document.tags!.remove(tag);
          });
        },
        onTagAdded: (value) {
          if (widget.document.tags!.length >= 4) {
            context.showAppSnackBar(
              content: Text(
                '태그는 최대 4개까지만 등록 할 수 있어요!',
                style: appTextTheme.bodySmall.copyWith(
                  height: 1.8,
                  color: appColorScheme.primary,
                ),
              ),
            );
          } else {
            setState(() {
              widget.document.tags!.add(value);
              _tagController.clear();
            });
          }
          _tagFocusNode.requestFocus();
        },
      );
    }
  }
}
