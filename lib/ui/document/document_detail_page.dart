import 'package:archivey/ui/document/widget/document_list_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:archivey/config/color_scheme_extension.dart';
import 'package:archivey/ui/document/widget/document_list_card_widget.dart';
import 'package:archivey/ui/document/widget/document_detail_tab_bar_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;

    return Scaffold(
      backgroundColor: appColorScheme.documentDetailBg,
      appBar: AppBar(
        backgroundColor: appColorScheme.primaryLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          color: appColorScheme.textDark,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            color: appColorScheme.textDark,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 문서 카드 (재사용)
          DocumentCard(
            document: widget.document,
            isFirstItem: false,
            showBottomBorder: false, // 하단 border 제거
          ),

          SizedBox(height: 20),

          // 겹쳐진 탭바
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: DocumentDetailTabBarWidget(
              selectedIndex: _selectedTabIndex,
              onTabChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              tabs: ['AI 요약', 'memo'],
            ),
          ),

          // 탭 내용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                // height: MediaQuery.of(context).size.height
                //     - MediaQuery.of(context).padding.top
                //     - 40,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                decoration: BoxDecoration(
                  color: appColorScheme.primaryLight,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  border: Border(
                    left: BorderSide(color: appColorScheme.strokeLight, width: 1),
                    right: BorderSide(color: appColorScheme.strokeLight, width: 1),
                    bottom: BorderSide(color: appColorScheme.strokeLight, width: 1),
                  ),
                ),
                child: _buildTabContent(appColorScheme),
              ),
            ),
          ),
          SizedBox(height: 40,),
        ],
      ),
    );
  }

  Widget _buildTabContent(AppColorScheme appColorScheme) {
    if (_selectedTabIndex == 0) {
      // AI 요약 내용
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '세계를 사로잡은 요리 내이미얼 "멕플릭스 오리지널" 측은 지난 10월 20일 23개 지역에서 공개한 오는 16일 시즌 1완결 9부 프로그램 심사위원인 안성재 셰프의 활약이이 눈에 띄며 인기다.',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: appColorScheme.textDark,
            ),
          ),
        ],
      );
    } else {
      // memo 내용
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '메모를 입력하세요...',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
        ),
      );
    }
  }
}
