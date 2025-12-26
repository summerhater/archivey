import 'package:archivey/ui/document/widget/app_snack_bar_widget.dart';
import 'package:archivey/ui/document/widget/document_list_card_widget.dart';
import 'package:archivey/ui/document/widget/more_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/ui/document/widget/document_detail_tab_bar_widget.dart';
import 'package:go_router/go_router.dart';

import '../../config/text_theme_extension.dart';
import '../../domain/model/document_model.dart';

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
  late TextEditingController _tagController;
  final FocusNode _memoFocusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.document.memo);
    _tagController = TextEditingController();

    /// 메모 포커스 리스너
    _memoFocusNode.addListener(_focusListener);

    /// 태그 포커스 리스너 추가
    _tagFocusNode.addListener(_focusListener);
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
        backgroundColor: appColorScheme.primaryLight,
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
            /// 수집물 카드 (재사용)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DocumentCard(
                document: widget.document,
                isFirstItem: false,
                isDetailPage: true,
                showBottomBorder: false,
              ),
            ),

            /// 겹쳐진 탭바
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
                        color: appColorScheme.primaryLight,
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
                        color: appColorScheme.primaryLight,
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis velit at urna tempor, id semper est mattis. Mauris eu nulla condimentum, suscipit massa sed, suscipit quam. Aliquam quis commodo ex, non dapibus arcu. Nullam velit purus, finibus ut congue ut, consectetur dictum turpis. Vestibulum eu orci eget risus rutrum pretium. Donec ipsum sem, porttitor eget erat at, cursus gravida arcu. Integer tincidunt eu felis in imperdiet. Ut vitae est aliquet, sagittis felis eget, ornare sem. Nulla consectetur ullamcorper ligula, a iaculis odio aliquam non. Ut ac massa a felis hendrerit cursus. Nulla mauris nisi, interdum et varius quis, sagittis id velit. Proin posuere vitae diam sed efficitur.',
            style: appTextTheme.bodySmall.copyWith(
              fontWeight: FontWeight.w300,
              color: appColorScheme.textDark,
              height: 1.6,
            ),
          ),
        ],
      );
    } else if (_selectedTabIndex == 1) {
      return _buildMemoContent(appColorScheme, appTextTheme);
    } else {
      return _buildTagContent(appColorScheme, appTextTheme);
    }
  }

  Widget _buildMemoContent(
    AppColorScheme appColorScheme,
    AppTextTheme appTextTheme,
  ) {
    if (_isEditing) {
      return Column(
        children: [
          TextField(
            controller: _memoController,
            focusNode: _memoFocusNode,
            maxLines: 10,
            maxLength: 200,
            style: appTextTheme.bodySmall.copyWith(
              fontWeight: FontWeight.w300,
              color: appColorScheme.textDark,
              height: 1.6,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: appColorScheme.documentDetailBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: '메모를 입력하세요..',
            ),
          ),
        ],
      );
    }
    return Text(
      widget.document.memo ?? '저장된 메모가 아직 없어요 📝',
      style: appTextTheme.bodySmall.copyWith(
        fontWeight: FontWeight.w300,
        color: appColorScheme.textDark,
        height: 1.6,
      ),
    );
  }

  /// 2. 태그 탭 내용 (수정 모드 포함)
  Widget _buildTagContent(
    AppColorScheme appColorScheme,
    AppTextTheme appTextTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.document.tags!.map((tag) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: appColorScheme.searchBackground,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tag,
                    style: appTextTheme.labelLarge.copyWith(
                      color: appColorScheme.categoryTagBg,
                    ),
                  ),
                  if (_isEditing) ...[
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.document.tags!.remove(tag);
                        });
                      },
                      child: Icon(
                        Icons.close,
                        size: 12,
                        color: appColorScheme.categoryTagBg,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
        if (_isEditing) ...[
          SizedBox(height: 20),
          TextField(
            controller: _tagController,
            focusNode: _tagFocusNode,
            autofocus: true,
            cursorColor: appColorScheme.categoryTagBg,
            cursorWidth: 1.0,
            cursorHeight: 18,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                if (widget.document.tags!.length >= 4) {
                  context.showAppSnackBar(
                    content: Text(
                      '태그는 최대 4개까지만 등록 할 수 있어요!',
                      style: appTextTheme.bodySmall.copyWith(
                        height: 1.8,
                        color: appColorScheme.primaryLight,
                      ),
                    ),
                  );
                  // _tagController.clear();
                  _tagFocusNode.requestFocus();
                } else {
                  setState(() {
                    widget.document.tags!.add(value);
                    _tagController.clear();
                  });
                  _tagFocusNode.requestFocus();
                }
              } else {
                _tagFocusNode.unfocus();
              }
            },
            decoration: InputDecoration(
              hintText: '태그를 입력해 주세요..',
              hintStyle: appTextTheme.bodySmall.copyWith(
                color: appColorScheme.textLight,
              ),
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
