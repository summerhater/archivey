import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../config/color_scheme_extension.dart';
import '../../../domain/model/document_model.dart';
import 'more_icon_widget.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  // final String date;
  // final String title;
  // final String imageUrl;
  // final List<String> tags;
  // final String sourceType;
  // final String sourceName;
  final bool isFirstItem;
  final bool showBottomBorder; /// 하단 border 제어
  final VoidCallback? onTap;

  const DocumentCard({
    super.key,
    required this.document,
    // required this.date,
    // required this.title,
    // required this.imageUrl,
    // required this.tags,
    // required this.sourceType,
    // required this.sourceName,
    required this.isFirstItem,
    this.showBottomBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    return Container(
      padding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
          top: isFirstItem ? BorderSide(
            color: appColorScheme.strokeLight,
            width: .5,
          ) : BorderSide.none,
          bottom: showBottomBorder
              ? BorderSide(
            color: appColorScheme.strokeLight,
            width: .5,
          ) : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///날짜, 더보기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                document.date,
                style: TextStyle(
                  fontFamily: 'scDream',
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
              MoreIconWidget(moreIconSettingMode: MoreIconSettingMode.document, document: document),
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
                child: Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          document.title,
                          style: TextStyle(
                            fontSize: 12,
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
                          Container(
                            padding: EdgeInsets.symmetric(
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
                                SvgPicture.asset('assets/icons/inbox_text.svg', width: 13, height: 13, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                                SizedBox(width: 4),
                                Text(
                                  document.sourceType,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: appColorScheme.primaryDark,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              document.sourceName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
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
          Row(
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
                        style: TextStyle(
                          fontSize: 10,
                          color: appColorScheme.categoryTagBg,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // SizedBox(width: 8),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.bookmark_border,),
                color: Colors.grey.shade400,
                iconSize: 24,
                visualDensity: VisualDensity(horizontal: -4.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}