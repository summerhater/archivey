import 'package:archivey/ui/document/widget/document_list_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/ui/document/document_shell_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:archivey/domain/model/document_model.dart';

class DocumentAllTotalPage extends StatefulWidget {
  const DocumentAllTotalPage({super.key});
  @override
  State<DocumentAllTotalPage> createState() => _DocumentAllTotalPageState();
}

class _DocumentAllTotalPageState extends State<DocumentAllTotalPage> {
  bool _showFab = false;
  final ScrollController _scrollController = ScrollController();
  final List<DocumentModel> documents = DocumentDummyData.getDummyDocuments();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // 스크롤 위치가 200 이상이면 FAB 표시
    if (_scrollController.offset > 200 && !_showFab) {
      setState(() {
        _showFab = true;
      });
    } else if (_scrollController.offset <= 200 && _showFab) {
      setState(() {
        _showFab = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      // floatingActionButton: SizedBox(
      //   height: 30,
      //   width: 43,
      //   child: AnimatedOpacity(
      //     opacity: _showFab ? 1.0 : 0.0,
      //     duration: const Duration(milliseconds: 200),
      //     child: AnimatedSlide(
      //       offset: _showFab ? Offset.zero : Offset(0, 1),
      //       duration: const Duration(milliseconds: 200),
      //       child: IgnorePointer(
      //         ignoring: !_showFab,
      //         child: FloatingActionButton(
      //           backgroundColor: appColorScheme.primaryDark,
      //           foregroundColor: appColorScheme.primaryLight,
      //           elevation: 0,
      //           onPressed: () {
      //             final controller = PrimaryScrollController.of(context);
      //             controller?.animateTo(
      //               0,
      //               duration: const Duration(milliseconds: 300),
      //               curve: Curves.easeOut,
      //             );
      //           },
      //           child: SvgPicture.asset(
      //             'assets/icons/arrow_up.svg',
      //             width: 12,
      //             height: 12,
      //             colorFilter: ColorFilter.mode(
      //               appColorScheme.primaryLight,
      //               BlendMode.srcIn,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '수집물',
                        style: TextStyle(
                          fontFamily: 'scDream',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: appColorScheme.textLight,
                        ),
                      ),
                      TextSpan(
                        text: ' 365',
                        style: TextStyle(
                          fontFamily: 'scDream',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: appColorScheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},

                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory, /// 탭할 시 애니메이션 제거
                        overlayColor: Colors.transparent, ///탭할 시 하이라이트 제거
                        minimumSize: Size.zero,
                        padding: EdgeInsets.all(0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '북마크순',
                        style: TextStyle(
                          fontFamily: 'scDream',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: appColorScheme.textLight,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory, /// 탭할 시 애니메이션 제거
                        overlayColor: Colors.transparent, ///탭할 시 하이라이트 제거
                      ),
                      child: Row(
                        children: [
                          Text(
                            '최신순',
                            style: TextStyle(
                              fontFamily: 'scDream',
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: appColorScheme.textDark,
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          SvgPicture.asset(
                            'assets/icons/sort.svg',
                            width: 13,
                            height: 13,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                return DocumentCard(
                  document: doc,
                  // date: doc.date,
                  // title: doc.title,
                  // imageUrl: doc.imageUrl,
                  // tags: doc.tags,
                  // sourceType: doc.sourceType,
                  // sourceName: doc.sourceName,
                  isFirstItem: index == 0, // 첫번째 카드는 top border 추가
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
