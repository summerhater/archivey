import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/ui/document/view_model/document_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';
import '../../../domain/model/document_model.dart';
import '../../../domain/model/document_model.dart';
import 'more_icon_widget.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final bool isFirstItem;
  final bool isDetailPage;
  final bool showBottomBorder;
  final VoidCallback? onTap;
  final bool isOnAllPage;

  const DocumentCard({
    super.key,
    required this.document,
    required this.isFirstItem,
    required this.isDetailPage,
    this.showBottomBorder = true,
    this.onTap,
    required this.isOnAllPage,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    final categoryVM = context.watch<CategoryViewModel>();
    String categoryName;
    if (document.category.parentId != null) {
      final rootCategory = categoryVM.getRootCategoryByParentId(
        document.category.parentId!,
      );
      categoryName = rootCategory!.categoryName;
    } else {
      categoryName = document.category.categoryName;
    }
    final AiTaskStatus aiStatus = document.aiStatus;
    final bool isProcessing =
        aiStatus == AiTaskStatus.pending || aiStatus == AiTaskStatus.analyzing;
    final bool isTitleGenerating =
        document.title == '제목 없는 링크' &&
        document.aiStatus != AiTaskStatus.completed;

    return InkWell(
      onTap: () async {
        final url = document.url;
        if (isProcessing) return;
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: isDetailPage
            ? EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16)
            : EdgeInsets.only(bottom: 10, left: 16, right: 16),
        decoration: isDetailPage
            ? BoxDecoration(
                color: appColorScheme.primary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: appColorScheme.strokeLight,
                  width: 1,
                ),
              )
            : BoxDecoration(
                color: null,
                border: Border(
                  top: isFirstItem
                      ? BorderSide(
                          color: appColorScheme.strokeLight,
                          width: .5,
                        )
                      : BorderSide.none,
                  bottom: showBottomBorder
                      ? BorderSide(
                          color: appColorScheme.strokeLight,
                          width: .5,
                        )
                      : BorderSide.none,
                ),
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///저장 날짜, 더보기 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy.MM.dd').format(document.createdAt),
                  style: appTextTheme.labelLarge.copyWith(
                    fontFamily: 'scDream',
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                !isDetailPage
                    ? Opacity(
                        opacity: isProcessing ? 0.4 : 1.0,
                        child: IgnorePointer(
                          ignoring: isProcessing,
                          child: MoreIconWidget(
                            moreIconSettingMode: MoreIconSettingMode.document,
                            document: document,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 30,
                      ),
              ],
            ),

            /// 썸네일, 제목, 카테고리명 및 플랫폼
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 썸네일 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: Image.network(
                      document.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.grey.shade500,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: isTitleGenerating
                              ? _buildTitleShimmer()
                              : Text(
                                  document.title,
                                  style: appTextTheme.bodySmall.copyWith(
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),

                        /// 카테고리 이름, 플랫폼
                        Row(
                          children: [
                            if (isOnAllPage) ...[
                              Flexible(
                                fit: FlexFit.loose,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: appColorScheme.categoryTagBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/inbox_text.svg',
                                        width: 13,
                                        height: 13,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          categoryName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: appTextTheme.labelLarge
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: appColorScheme.primaryStrong,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                document.platform,
                                style: appTextTheme.labelLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            /// 하단 태그, 북마크 아이콘
            _buildBottomTags(context, document),
          ],
        ),
      ),
    );
  }
}

Widget _buildTitleShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: 20,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

Widget _buildBottomTags(BuildContext context, DocumentModel document) {
  final status = document.aiStatus;

  if (status == AiTaskStatus.pending || status == AiTaskStatus.analyzing) {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 20,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  if (status == AiTaskStatus.failed) {
    return _buildAiRetryTag(context, document);
  }

  return _buildNormalBottomTags(context, document);
}

Widget _buildAiRetryTag(BuildContext context, DocumentModel document) {
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          context.read<DocumentViewModel>().retryAiAnalysis(document);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'AI 요약 다시 시도',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildNormalBottomTags(BuildContext context, DocumentModel document) {
  final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
  final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: document.tags.map((tag) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: appColorScheme.searchBackground,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                tag,
                style: appTextTheme.labelLarge.copyWith(
                  color: appColorScheme.categoryTagBg,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.bookmark_border,
        ),
        color: Colors.grey.shade400,
        iconSize: 24,
        visualDensity: VisualDensity(horizontal: -4.0),
      ),
    ],
  );
}
