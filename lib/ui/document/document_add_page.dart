import 'package:archivey/ui/document/widget/app_snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/color_scheme_extension.dart';
import '../../config/text_theme_extension.dart';
import '../../domain/model/document_model.dart';

class DocumentAddPage extends StatefulWidget {
  const DocumentAddPage({Key? key}) : super(key: key);

  @override
  State<DocumentAddPage> createState() => _DocumentAddPageState();
}

class _DocumentAddPageState extends State<DocumentAddPage> {
  String? _selectedCategory;
  int? _selectedSubIndex = 0; /// 소분류 선택 인덱스 - 기본값 '전체'
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _memoController = TextEditingController();
  final int _maxMemoLength = 200;

  final List<String> categories = DocumentDummyData.getCategories();
  List<String> subCategories = [
    '전체',
    'sub1',
    'sub2',
    'sub3',
    'sub4',
    'sub5',
    'sub6',
  ];

  @override
  void initState() {
    super.initState();
    _memoController.addListener(() {
      setState(() {});

      ///글자수 세기 용도
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      ///todo: db 저장 로직 구현
      print({
        'url': _urlController.text,
        'category': _selectedCategory,
        'memo': _memoController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    final memoLength = _memoController.text.length;
    final isFormValid =
        _urlController.text.isNotEmpty &&
        _selectedCategory != null &&
        memoLength <= _maxMemoLength;

    return Scaffold(
      backgroundColor: appColorScheme.primaryLight,
      body: SafeArea(
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
                      onPressed: () => context.pop(),
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
                            color: appColorScheme.primaryLight,
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
                          onChanged: (_) => setState(() {}),
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

                    ///대분류 카테고리
                    Wrap(
                      spacing: 8.0,
                      children: categories.map((category) {
                        bool isSelected = _selectedCategory == category;
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;

                              /// 대분류가 바뀌거나 취소되면 소분류 선택도 초기화
                              _selectedSubIndex = 0;
                            });
                          },
                          backgroundColor: appColorScheme.primaryLight,
                          selectedColor: appColorScheme.primaryDark,
                          labelStyle: appTextTheme.labelLarge.copyWith(
                            color: isSelected
                                ? appColorScheme.primaryLight
                                : appColorScheme.primaryDark,
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
                          top: 30,
                        ),
                        child: Container(
                          width: double.infinity,
                          child: _selectedCategory == null
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
                                      children: List.generate(
                                        subCategories.length,
                                        (index) {
                                          bool isSubSelected =
                                              _selectedSubIndex == index;
                                          return ChoiceChip(
                                            showCheckmark: false,
                                            label: Text(
                                              subCategories[index],
                                              style: appTextTheme.labelLarge,
                                            ),
                                            selected: isSubSelected,
                                            onSelected: (selected) {
                                              setState(() {
                                                _selectedSubIndex = selected
                                                    ? index
                                                    : null;
                                              });
                                            },
                                            backgroundColor:
                                                appColorScheme.primaryLight,
                                            selectedColor:
                                                appColorScheme.primaryDark,
                                            shape: StadiumBorder(
                                              side: BorderSide(
                                                color:
                                                    appColorScheme.strokeLight,
                                              ),
                                            ),
                                            labelStyle: appTextTheme.bodyLarge.copyWith(
                                              color: isSubSelected
                                                  ? appColorScheme.primaryLight
                                                  : appColorScheme.primaryDark,
                                            ),
                                          );
                                        },
                                      ),
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
                        controller: _memoController,
                        maxLength: _maxMemoLength,
                        maxLines: 5,
                        style: appTextTheme.bodyMedium.copyWith(
                          color: appColorScheme.primaryLight,
                        ),
                        cursorColor: appColorScheme.strokeLight,
                        cursorWidth: 1.0,
                        cursorHeight: 18,
                        decoration: InputDecoration(
                          hintText: '이 수집물에 대한 메모를 작성해보세요..',
                          hintStyle: appTextTheme.bodyMedium.copyWith(color: appColorScheme.textLight),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                ///저장 버튼
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                            _handleSubmit();
                            context.showAppSnackBar(
                              content: Text(
                                '수집물이 추가되었습니다',
                                style: appTextTheme.bodySmall.copyWith(
                                  color: appColorScheme.primaryLight,
                                ),
                              ),
                            );
                            context.pop();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColorScheme.primaryDark,
                      foregroundColor: appColorScheme.primaryLight,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
