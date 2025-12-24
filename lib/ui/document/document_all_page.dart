import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/ui/document/document_all_index_page.dart';
import 'package:archivey/ui/document/document_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'document_all_total_page.dart';

class DocumentAllPage extends StatefulWidget {
  final Widget contentPage;
  const DocumentAllPage({super.key, required this.contentPage});
  @override
  State<DocumentAllPage> createState() => _DocumentAllPageState();
}

class _DocumentAllPageState extends State<DocumentAllPage> {
  String? _searchValue;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final currentLocation = GoRouterState.of(context).uri.toString();
    final isIndexSelected = currentLocation.contains('_index');
    final isTotalSelected = currentLocation.contains('_total');
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),

                ///상단 여유 스페이스
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go('/document_all_index');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 14.0, bottom: 2.5),
                        child: Text(
                          "Index",
                          style: TextStyle(
                            fontFamily: 'theseasons',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: isIndexSelected
                                ? appColorScheme.textDark
                                : appColorScheme.textLight,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: .5,
                      height: 15,
                      color: appColorScheme.textLight,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/document_all_total');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 14,
                        ),
                        child: Text(
                          "전체",
                          style: TextStyle(
                            fontFamily: 'scDream',
                            fontSize: 16,
                            color: isTotalSelected
                                ? appColorScheme.textDark
                                : appColorScheme.textLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),

                ///검색창
                TextField(
                  onChanged: (value) {
                    _searchValue = value; // onChanged 콜백으로 실시간 텍스트 업데이트
                  },
                  cursorColor: appColorScheme.categoryTagBg, // 커서 색상 변경
                  cursorWidth: 1.0,
                  cursorHeight: 18,
                  decoration: InputDecoration(
                    hintText: '키워드 입력',
                    hintStyle: TextStyle(
                      fontFamily: 'scDream',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: appColorScheme.textLight,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: appColorScheme.textLight,
                    ),
                    filled: true,
                    fillColor: appColorScheme.searchBackground,
                    border: OutlineInputBorder(
                      // 기본 테두리 (비활성화 시)
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
              ],
            ),
          ),

          Expanded(
            child: widget.contentPage,
          ),
        ],
      ),
    );
  }
}

// class DocumentAllPage extends StatelessWidget {
//   final Widget contentPage;
//   const DocumentAllPage({super.key, required this.contentPage});
//   @override
//   Widget build(BuildContext context) {
//     final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
//     final currentLocation = GoRouterState.of(context).uri.toString();
//     final isIndexSelected = currentLocation.contains('/index');
//     final isTotalSelected = currentLocation.contains('/total');
//     return SafeArea(
//       child: Container(
//         padding: EdgeInsets.all(0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 0),
//                   child: GestureDetector(
//                     onTap: () {
//                       context.go('/document/all/index');
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.all(20.0),
//                       child: Text(
//                         "Index",
//                         style: TextStyle(
//                           fontFamily: 'theseasons',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           color: isIndexSelected
//                               ? appColorScheme.textDark
//                               : appColorScheme.textLight,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: .5,
//                   height: 12,
//                   color: appColorScheme.textLight,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     context.go('/document/all/total');
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.all(20.0),
//                     child: Text(
//                       "전체",
//                       style: TextStyle(
//                         fontFamily: 'scDream',
//                         fontSize: 16,
//                         color: isTotalSelected
//                             ? appColorScheme.textDark
//                             : appColorScheme.textLight,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             ///검색창
//             TextField(
//               onChanged: (value) {
//                 _currentSearch = value; // onChanged 콜백으로 실시간 텍스트 업데이트
//               },
//               decoration: InputDecoration(
//                 labelText: '키워드 입력',
//                 border: OutlineInputBorder(), // 테두리 스타일
//               ),
//             ),
//             Expanded(
//               child: contentPage,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
