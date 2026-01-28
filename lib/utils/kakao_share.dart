import 'package:archivey/config/share_category_link_config.dart';
import 'package:archivey/domain/model/category_model.dart';
import 'package:archivey/domain/model/document_model.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

//todo: jh , service layer로 보내도 될것 같음. vm의 중복은 KakaoShareMixin 으로 분리하는 방식 선택할 수 있다.

Future<void> kakaoShareCategoryURL(String urlToShare, CategoryModel category) async {
  print('urlToShare : $urlToShare');
  final FeedTemplate defaultFeed = FeedTemplate(
    content: Content(
      title: category.categoryName, // 문서 제목 직접 주입
      description: '아카이비에서 공유한 카테고리 수집물을 확인해보세요.',
      imageUrl: Uri.parse("${ShareCategoryLinkConfig.baseUrl}/assets/meta_thumnail.png"),
      link: Link(
        mobileWebUrl: Uri.parse(urlToShare),
        webUrl: Uri.parse(urlToShare),
      ),
    ),
    buttons: [
      Button(
        title: '수집물 보러가기',
        link: Link(
          mobileWebUrl: Uri.parse(urlToShare),
          webUrl: Uri.parse(urlToShare),
        ),
      ),
    ],
  );

  bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

  if (isKakaoTalkSharingAvailable) {
    try {
      print('urlToShare : $urlToShare');
      Uri uri = await ShareClient.instance.shareDefault(template: defaultFeed);
      print('카카오톡 공유 준비');
      await ShareClient.instance.launchKakaoTalk(uri);
      print('카카오톡 공유 완료');
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  } else {
    print('카카오톡 안깔려서 안 열림! : urlToShare : $urlToShare');
    try {
      Uri shareUrl = await WebSharerClient.instance.makeScrapUrl(
        url: urlToShare,
        templateArgs: {'key1': 'value1'},
      );
      await launchBrowserTab(shareUrl, popupOpen: true);
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  }
}

Future<void> kakaoShareDocumentURL(String urlToShare, DocumentModel doc) async {
  final FeedTemplate defaultFeed = FeedTemplate(
    content: Content(
      title: doc.title,
      description: '아카이비에서 공유한 수집물입니다. ${doc.aiSummary}',
      imageUrl: Uri.parse(doc.imageUrl),
      link: Link(
        mobileWebUrl: Uri.parse(urlToShare), // 리다이렉트 경로 (go.html)
        webUrl: Uri.parse(urlToShare),
      ),
    ),
    buttons: [
      Button(
        title: '수집물 보러가기',
        link: Link(
          mobileWebUrl: Uri.parse(urlToShare),
          webUrl: Uri.parse(urlToShare),
        ),
      ),
    ],
  );

  bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

  try {
    Uri uri;
    if (isKakaoTalkSharingAvailable) {
      uri = await ShareClient.instance.shareDefault(template: defaultFeed);
      await ShareClient.instance.launchKakaoTalk(uri);
    } else {
      uri = await WebSharerClient.instance.makeDefaultUrl(template: defaultFeed);
      await launchBrowserTab(uri, popupOpen: true);
    }
  } catch (error) {
    print('공유 실패: $error');
  }
}