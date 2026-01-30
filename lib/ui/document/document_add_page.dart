import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:archivey/utils/app_snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/color_scheme_extension.dart';
import '../../config/text_theme_extension.dart';

class DocumentAddPage extends StatefulWidget {
  final String? sharedText;
  const DocumentAddPage({super.key, this.sharedText});

  @override
  State<DocumentAddPage> createState() => _DocumentAddPageState();
}

class _DocumentAddPageState extends State<DocumentAddPage> {
  CategoryModel? _selectedCategory;
  CategoryModel? _selectedSubCategory;
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _memoController = TextEditingController();
  final int _maxMemoLength = 200;
  String _sharedURLCaptionText = '';

  void _handleSharingIntent(sharedText) {
    ///텍스트 받기 -> url만 추출해서 controller.text에 주입 -> 나머지 텍스트는 String으로 만들기 -> vm에게 url, urlCaptionText 따로 넘겨줌

    final foundURLMatch = RegExp(r"(https?://[^\s]+)").firstMatch(sharedText);
    final sharedURL = foundURLMatch?.group(0) ?? '';
    if (sharedURL.isNotEmpty) {
      setState(() {
        _urlController.text = sharedURL;
        _sharedURLCaptionText = sharedText.replaceAll(sharedURL, '').trim();
      });
    }
  }

  Future<void> _handleSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) return;

    final vm = context.read<DocViewModel>();
    final targetCategory = _selectedSubCategory ?? _selectedCategory!;

    try {
      await vm.addDocumentProcess(
        sharedURL: _urlController.text,
        sharedURLCaptionText: _sharedURLCaptionText,
        category: targetCategory,
        memo: _memoController.text,
      );

      if (!mounted) return;
      // 단순 pop 대신 명시적으로 리스트 페이지로 이동하여
      // go_router의 ImperativeRouteMatch 중복 완료 이슈를 피한다.
      context.go('/document_all_total');
      context.showAppMessageSnackBar('수집물 아카이빙이 완료되었습니다 ☻');
    } catch (e) {
      context.showAppMessageSnackBar('수집물 아카이빙에 실패했습니다 : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.sharedText != null){
      _handleSharingIntent(widget.sharedText);
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    final categoryVM = context.read<CategoryViewModel>();
    final List<CategoryModel> categories = categoryVM.rootCategories;
    final List<CategoryModel> subCategories=categoryVM.getSubCategories(_selectedCategory?.categoryId);
    var memoLength = _memoController.text.length;
    final isFormValid = _urlController.text.isNotEmpty &&
        _selectedCategory != null &&
        memoLength <= _maxMemoLength;

    return Scaffold(
      backgroundColor: appColorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '수집물 추가하기',
                            style: appTextTheme.headlineLargeKo.copyWith(
                              color: appColorScheme.textDark,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Imperative pop 대신 선언적 go 사용으로
                              // Future already completed 에러를 방지
                              context.go('/document_all_total');
                            },
                            icon: const Icon(Icons.close),
                            color: appColorScheme.textLight,
                            iconSize: 24,
                          ),
                        ],
                      ),

                      /// URL 링크
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '원문 링크',
                              style: appTextTheme.bodyMedium.copyWith(
                                color: appColorScheme.textDark,
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: appColorScheme.categoryTagBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: appColorScheme.strokeLight),
                              ),
                              child: TextFormField(
                                controller: _urlController,
                                style: appTextTheme.bodyMedium.copyWith(
                                  color: appColorScheme.primary,
                                ),
                                cursorColor: appColorScheme.strokeLight,
                                cursorWidth: 1.0,
                                cursorHeight: 18,
                                decoration: InputDecoration(
                                  hintText: 'https://example.com',
                                  hintStyle: appTextTheme.bodyMedium.copyWith(
                                    color: appColorScheme.textLight,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.link,
                                    color: appColorScheme.textLight,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '링크를 입력해주세요';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///카테고리 선택 칩
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '카테고리',
                            style: appTextTheme.bodyMedium.copyWith(
                              color: appColorScheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),

                          /// 대분류 카테고리
                          Wrap(
                            spacing: 8.0,
                            children: categories.map((category) {
                              bool isSelected = _selectedCategory == category;
                              return ChoiceChip(
                                showCheckmark: false,
                                label: Text(category.categoryName),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = selected ? category : null;
                                    /// 대분류가 바뀌거나 취소되면 소분류 선택도 초기화
                                    _selectedSubCategory = null;
                                  });
                                },
                                backgroundColor: appColorScheme.primary,
                                selectedColor: appColorScheme.primaryStrong,
                                labelStyle: appTextTheme.labelLarge.copyWith(
                                  color: isSelected
                                      ? appColorScheme.primary
                                      : appColorScheme.primaryStrong,
                                ),
                              );
                            }).toList(),
                          ),

                          ///소분류 카테고리
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            alignment: Alignment.topCenter,
                            curve: Curves.easeInOut,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: _selectedCategory == null || subCategories.isEmpty
                                    ? const SizedBox.shrink()
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '소분류 카테고리',
                                            style: appTextTheme.bodyMedium.copyWith(
                                              color: appColorScheme.textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Wrap(
                                            spacing: 8.0,
                                            children: subCategories.map((sub) {
                                              // 2. 객체 비교를 통해 선택 여부 확인
                                              bool isSubSelected = _selectedSubCategory == sub;

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 20,
                                                ),
                                                child: ChoiceChip(
                                                  showCheckmark: false,
                                                  label: Text(
                                                    sub.categoryName, // 모델의 이름 표시
                                                    style: appTextTheme.labelLarge,
                                                  ),
                                                  selected: isSubSelected,
                                                  onSelected: (selected) {
                                                    setState(() {
                                                      _selectedSubCategory = selected ? sub : null;
                                                    });
                                                  },
                                                  backgroundColor: appColorScheme.primary,
                                                  selectedColor: appColorScheme.primaryStrong,
                                                  shape: StadiumBorder(
                                                    side: BorderSide(
                                                      color: appColorScheme.strokeLight,
                                                    ),
                                                  ),
                                                  labelStyle: appTextTheme.bodyLarge.copyWith(
                                                    color: isSubSelected
                                                        ? appColorScheme.primary
                                                        : appColorScheme.primaryStrong,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      ///메모 입력 필드
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '메모',
                                style: appTextTheme.bodyMedium.copyWith(
                                  color: appColorScheme.textDark,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$memoLength/$_maxMemoLength',
                                    style: appTextTheme.bodySmall.copyWith(
                                      color: appColorScheme.textLight,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: appColorScheme.categoryTagBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: appColorScheme.strokeLight),
                            ),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {});
                              },
                              controller: _memoController,
                              maxLength: _maxMemoLength,
                              maxLines: 5,
                              style: appTextTheme.bodyMedium.copyWith(
                                color: appColorScheme.primary,
                              ),
                              cursorColor: appColorScheme.strokeLight,
                              cursorWidth: 1.0,
                              cursorHeight: 18,
                              decoration: InputDecoration(
                                hintText: '이 수집물에 대한 메모를 작성해보세요..',
                                hintStyle: appTextTheme.bodySmall.copyWith(color: appColorScheme.textLight),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                                counterText: '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 10),
              color: appColorScheme.primary,
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                          _handleSave(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColorScheme.primaryStrong,
                    foregroundColor: appColorScheme.primary,
                    disabledBackgroundColor: appColorScheme.strokeLight,
                    disabledForegroundColor: appColorScheme.snackBarBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '저장하기',
                    style: appTextTheme.headlineSmallKo,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
