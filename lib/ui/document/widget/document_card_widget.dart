import 'package:archivey/ui/document/view_model/category_view_model.dart';
import 'package:archivey/ui/document/view_model/doc_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../config/text_theme_extension.dart';
import '../../../domain/model/document_model.dart';
import 'more_icon_widget.dart';
import 'dart:ui' as ui;
// import 'package:image_network/image_network.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final bool isFirstItem;
  final bool outlineBorder;
  final bool showBottomBorder;
  final VoidCallback? onTap;
  final bool isOnAllPage;
  final String categoryName;
  final VoidCallback? onDeleteConfirmed;
  final VoidCallback? onCopyLinkConfirmed;
  final VoidCallback? onShareKakaoConfirmed;
  final bool? isWeb;

  const DocumentCard({
    super.key,
    required this.document,
    required this.isFirstItem,
    required this.outlineBorder,
    this.showBottomBorder = true,
    this.onTap,
    required this.isOnAllPage,
    required this.categoryName,
    this.onShareKakaoConfirmed,
    this.onCopyLinkConfirmed,
    this.onDeleteConfirmed,
    this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;
    final bool showMoreIcon = onShareKakaoConfirmed == null &&
            onCopyLinkConfirmed == null &&
            onDeleteConfirmed == null;
    final AiTaskStatus aiStatus = document.aiStatus;
    final bool isProcessing =
        aiStatus == AiTaskStatus.pending || aiStatus == AiTaskStatus.analyzing;
    final bool isTitleGenerating =
        document.title == '제목 없는 링크' &&
        document.aiStatus != AiTaskStatus.completed;
    final String currentPath = GoRouterState.of(context).uri.path;
    final bool isReadOnlyPath = currentPath.startsWith('/share/category/');

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
        padding: outlineBorder
            ? EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16)
            : EdgeInsets.only(bottom: 10, left: 16, right: 16),
        decoration: outlineBorder
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
                !showMoreIcon
                    ? Opacity(
                        opacity: isProcessing ? 0.4 : 1.0,
                        child: IgnorePointer(
                          ignoring: isProcessing,
                          child: MoreIconWidget(
                            moreIconSettingMode: MoreIconSettingMode.document,
                            document: document,
                            onDeleteConfirmed: onDeleteConfirmed,
                            onCopyLinkConfirmed: onCopyLinkConfirmed,
                            onShareKakaoConfirmed: onShareKakaoConfirmed,
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
                // if(kIsWeb)
                //   ImageNetwork(
                //     image: document.imageUrl,
                //     height: 80.0,
                //     width: 80.0,
                //     duration: 500,
                //     curve: Curves.easeIn,
                //     onPointer: true,
                //     fitAndroidIos: BoxFit.cover,
                //     fitWeb: BoxFitWeb.fill,
                //     borderRadius: BorderRadius.circular(8),
                //     backgroundColor: Colors.grey.shade300,
                //     onLoading: Center(
                //       child: CircularProgressIndicator(
                //         strokeWidth: 2,
                //         color: Colors.grey.shade500,
                //       ),
                //     ),
                //     onError: Container(
                //       color: Colors.grey.shade300,
                //       child: Center(
                //         child: Icon(
                //           Icons.image,
                //           color: Colors.grey.shade500,
                //           size: 40,
                //         ),
                //       ),
                //     ),
                //   )
                // else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: _buildThumbnailImage(document.imageUrl),
                    ),
                  ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(8),
                //   child: CachedNetworkImage(
                //     imageUrl: document.imageUrl,
                //     width: 80,
                //     height: 80,
                //     fit: BoxFit.cover,
                //     // 로딩 중 표시
                //     placeholder: (context, url) => Container(
                //       color: Colors.grey.shade300,
                //       child: const Center(
                //         child: CircularProgressIndicator(strokeWidth: 2),
                //       ),
                //     ),
                //     // 에러 발생 시 표시
                //     errorWidget: (context, url, error) => Container(
                //       color: Colors.grey.shade300,
                //       child: Icon(Icons.image, color: Colors.grey.shade500, size: 40),
                //     ),
                //   ),
                // ),
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
            _buildBottomTags(context, document, isWeb),
          ],
        ),
      ),
    );
  }
}

Widget _buildThumbnailImage(String imageUrl) {
  // 인스타그램 등 403을 자주 내는 도메인이나 빈 URL은 바로 플레이스홀더 표시
  final uri = Uri.tryParse(imageUrl);
  final isBlockedHost = uri == null ||
      imageUrl.isEmpty ||
      uri.host.contains('instagram.com') ||
      uri.host.contains('cdninstagram.com');

  if (isBlockedHost) {
    return _thumbnailPlaceholder();
  }

  return Image.network(
    kIsWeb
        ? 'https://proxy-gqfi74i22a-uc.a.run.app/proxy?url=$imageUrl'
        : imageUrl,
    fit: BoxFit.cover,
    webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
    errorBuilder: (context, error, stackTrace) {
      return _thumbnailPlaceholder();
    },
  );
}

Widget _thumbnailPlaceholder() {
  return Container(
    color: Colors.grey.shade300,
    child: const Center(
      child: Icon(
        Icons.image,
        color: Colors.grey,
        size: 40,
      ),
    ),
  );
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

Widget _buildBottomTags(BuildContext context, DocumentModel document, isWeb) {
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

  return _buildNormalBottomTags(context, document, isWeb);
}

Widget _buildAiRetryTag(BuildContext context, DocumentModel document) {
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          context.read<DocViewModel>().retryAiAnalysis(document);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(5),
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

Widget _buildNormalBottomTags(BuildContext context, DocumentModel document, bool? isWeb) {
  final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
  final appTextTheme = Theme.of(context).extension<AppTextTheme>()!;

  /// 북마크 아이콘 공간을 제외한 태그 영역의 여유 공간 (아이콘 24 + 여백 등)
  const double actionAreaWidth = 48.0;
  const double tagSpacing = 8.0;

  return LayoutBuilder(
    builder: (context, constraints) {
      final maxWidth = constraints.maxWidth - actionAreaWidth;

      List<String> visibleTags = [];
      int hiddenCount = 0;
      double currentWidth = 0;

      for (var tag in document.tags) {
        /// 텍스트 너비 계산
        final textPainter = TextPainter(
          text: TextSpan(text: tag, style: appTextTheme.labelLarge),
          maxLines: 1,
          textDirection: ui.TextDirection.ltr,
        )..layout();

        /// 컨테이너 패딩(12*2) + 태그 간격(8) 포함 너비
        final tagWidth = textPainter.width + 24 + tagSpacing;

        /// '+N'표시하기 위한 최소 공간 계산
        if (currentWidth + tagWidth + 35 < maxWidth) {
          visibleTags.add(tag);
          currentWidth += tagWidth;
        } else {
          hiddenCount = document.tags.length - visibleTags.length;
          break;
        }
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Wrap(
              spacing: tagSpacing,
              runSpacing: 8,
              children: [
                ...visibleTags.map((tag) => _buildTagItem(tag, appColorScheme, appTextTheme)),
                if (hiddenCount > 0)
                  _buildTagItem('+$hiddenCount', appColorScheme, appTextTheme),
              ],
            ),
          ),
          /// 북마크
          // if (isWeb == null)
          //   IconButton(
          //     onPressed: () async{
          //       // TODO 함수 콜백으로 받기
          //       await Provider.of<DocViewModel>(context, listen: false).updateDocument(document.copyWith(isBookmark: !document.isBookmark));
          //     },
          //     icon: document.isBookmark ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),
          //     color: Colors.grey.shade400,
          //     iconSize: 24,
          //     visualDensity: VisualDensity(horizontal: -4.0),
          //   ),
            () {
            final String currentPath = GoRouterState.of(context).uri.path;
            final bool isReadOnlyPath = currentPath.startsWith('/share/category/');

            if (isReadOnlyPath) {
              ///공유 경로(Read-only)일 때
              return document.isBookmark
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Icon(Icons.bookmark, color: appColorScheme.textLight, size: 24),
              )
                  : const SizedBox.shrink();
            } else {
              return IconButton(
                onPressed: () async {
                  await Provider.of<DocViewModel>(context, listen: false)
                      .updateDocument(document.copyWith(isBookmark: !document.isBookmark));
                },
                icon: Icon(document.isBookmark ? Icons.bookmark : Icons.bookmark_border),
                color: appColorScheme.textLight,
                iconSize: 24,
                visualDensity: const VisualDensity(horizontal: -4.0),
              );
            }
          }(),
        ],
      );
    },
  );
}

// 공통 태그 아이템 빌더
Widget _buildTagItem(String text, AppColorScheme colorScheme, AppTextTheme textTheme) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: colorScheme.searchBackground,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: textTheme.labelLarge.copyWith(
        color: colorScheme.categoryTagBg,
      ),
    ),
  );
}
