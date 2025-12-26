import 'package:archivey/ui/document/widget/app_snack_bar_widget.dart';
import 'package:archivey/ui/document/widget/bottom_sheet_category_add_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/ui/document/widget/more_icon_widget.dart';
import 'package:archivey/ui/document/widget/document_all_index_post_count_widget.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/text_theme_extension.dart';

class DocumentAllIndexPage extends StatefulWidget {
  const DocumentAllIndexPage({super.key});
  @override
  State<DocumentAllIndexPage> createState() => _DocumentAllIndexPageState();
}

class _DocumentAllIndexPageState extends State<DocumentAllIndexPage> {
  Future<void> _onAddCategoryPressed() async {
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final newCategoryName = await showModalBottomSheet<String>(
      isScrollControlled: true,
      context: context,
      useRootNavigator: true,
      builder: (_) => BottomSheetCategoryAddEditWidget(
        categorySettingMode: CategorySettingMode.add,
      ),
    );

    if (!mounted) return;

    if (newCategoryName != null && newCategoryName.isNotEmpty) {
      context.showAppSnackBar(
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '\'$newCategoryName\'',
                style: appTextTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ' 카테고리가 추가 되었습니다 ☻'),
            ],
            style: appTextTheme.bodySmall.copyWith(
              color: appColorScheme.primaryLight,
            ),
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: SizedBox(
        height: 43,
        child: FloatingActionButton.extended(
          onPressed: _onAddCategoryPressed,
          backgroundColor: appColorScheme.primaryDark,
          foregroundColor: appColorScheme.primaryLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Adjust radius as needed
          ),
          label: Text(
            '새 카테고리 추가',
            style: appTextTheme.bodySmall.copyWith(
              height: 1.2
            ),
          ),
          icon: SvgPicture.asset(
            'assets/images/logo_variation_plus.svg',
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(
              appColorScheme.primaryLight,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: appColorScheme.strokeLight,
                      width: .5,
                    ),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.only(
                    left: 18,
                    top: 9,
                    bottom: 9,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "아이템 $index",
                        style: appTextTheme.headlineSmallKo.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Row(
                        children: [
                          DocumentAllIndexPostCountWidget(),
                          SizedBox(width: 10,),
                          MoreIconWidget(moreIconSettingMode: MoreIconSettingMode.category,),
                          SizedBox(width: 8,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


