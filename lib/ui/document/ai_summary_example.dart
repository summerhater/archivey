import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:firebase_ai/firebase_ai.dart';

///임시모델
enum AnalysisStatus { pending, analyzing, completed, failed }

class AIAnalysis {
  final String? platform;///임시
  final String? summary;
  final List<String> tags;
  final AnalysisStatus status;

  AIAnalysis({
    this.platform,///임시
    this.summary,
    this.tags = const [],
    this.status = AnalysisStatus.pending,
  });
}

class DocumentModel {
  final String id;
  final String title;
  final String url;
  final String imageUrl;
  final String platform;
  final String category;
  final AIAnalysis aiAnalysis;

  DocumentModel({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.platform,
    required this.category,
    required this.aiAnalysis,
  });

  DocumentModel copyWith({AIAnalysis? aiAnalysis}) {
    return DocumentModel(
      id: id,
      title: title,
      url: url,
      imageUrl: imageUrl,
      platform: platform,
      category: category,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
    );
  }
}

///로직
class LinkProcessor {
  final _youtube = YoutubeExplode();
  final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );

  Map<String, dynamic> extractMetaData(dom.Document document) {
    final ogData = MetadataParser.openGraph(document);
    final htmlData = MetadataParser.htmlMeta(document);
    final twitterCardData = MetadataParser.twitterCard(document);
    final structuredData = MetadataParser.jsonLdSchema(document);

    String? title;
    String? description;
    String? image;

    /// 우선순위 : OG -> HTML -> Twitter -> JSON-LD 순
    /// 각 필드별로 우선순위에 따라 제일 먼저 채워지는 데이터 추출

    // print('------------------ result ------------------');
    if (ogData.title != null) {
      title = ogData.title;
      // print('1. get title : ogData');
    } else if (htmlData.title != null) {
      title = htmlData.title;
      // print('1. get title : htmlData');
    } else if (twitterCardData.title != null) {
      title = twitterCardData.title;
      // print('1. get title : twitterData');
    } else {
      title = structuredData.title;
      // print('1. get title : structuredData');
    }

    if (ogData.description != null) {
      description = ogData.description;
      // print('2. get description : ogData');
    } else if (htmlData.description != null) {
      description = htmlData.description;
      // print('2. get description : htmlData');
    } else if (twitterCardData.description != null) {
      description = twitterCardData.description;
      // print('2. get description : twitterCardData');
    } else {
      description = structuredData.description;
      // print('2. get description : structuredData');
    }

    if (ogData.image != null) {
      image = ogData.image;
      // print('3. get imageURL : ogData');
    } else if (htmlData.image != null) {
      image = htmlData.image;
      // print('3. get imageURL : htmlData');
    } else if (twitterCardData.image != null) {
      image = twitterCardData.image;
      // print('3. get imageURL : twitterCardData');
    } else {
      image = structuredData.image;
      // print('3. get imageURL : structuredData');
    }

    return {
      'title': title,
      'description': description,
      'image': image,
    };
  }

  String extractPlatform(String url) {
    // try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();

      // 1단계: 명확한 처리가 필요한 "슈퍼 플랫폼" 10~20개만 매핑 (예외 처리용)
      const superPlatforms = {
        'naver.com': '네이버',
        'youtube.com': 'YouTube',
        'youtu.be': 'YouTube',
        'x.com': 'X',
        'twitter.com': 'X',
        'facebook.com': 'Facebook',
        'instagram.com': 'Instagram',
        'tistory.com': '티스토리',
        'brunch.co.kr': '브런치',
        'github.com': 'GitHub',
      };

      // 호스트의 끝부분이 매핑 테이블에 있는지 확인
      for (var domain in superPlatforms.keys) {
        if (host.endsWith(domain)) return superPlatforms[domain]!;
      }

      // // 2단계: 자동 추출 알고리즘 (나머지 수만 개의 사이트 대응)
      // // 공통적인 서브도메인(www, m, blog, news 등)과 TLD(.com, .co.kr)를 제거
      // List<String> parts = host.split('.');
      //
      // // 제거할 무의미한 서브도메인들
      // const junkSubdomains = {'www', 'm', 'blog', 'news', 'cafe', 'app', 'shop', 'mail', 'api'};
      //
      // // junkSubdomains에 해당하는 앞부분을 제거
      // List<String> filteredParts = parts.where((p) => !junkSubdomains.contains(p)).toList();
      //
      // if (filteredParts.isNotEmpty) {
      //   // 가장 핵심이 되는 첫 번째 마디를 대문자로 변환 (예: zigzag.kr -> ZIGZAG)
      //   return filteredParts[0].toUpperCase();
      // }

      // return host;
    return 'Unknown';
    // } catch (e) {
    //   return "Unknown";
    // }
  }

  Future<Map<String, dynamic>> urlScrapper (
    String rawText,
    String category,
  ) async {
    ///1. todo: 외부에서 공유된 텍스트 받기
    final url = RegExp(r"(https?://[^\s]+)").firstMatch(rawText)?.group(0) ?? ""; ///1-1. rawText에서 정규식으로 링크 추출
    final sharedUrlCaption = rawText.replaceAll(url, "").trim(); ///1-2. rawText에서 링크 캡션 텍스트 추출

    if (url.isEmpty) throw Exception("urlScrapper: URL을 찾을 수 없습니다.");

    /// 2. HTTP 요청 및 OpenGraph & 메타데이터 파싱
    final response = await http.get(Uri.parse(url)); /// 2-1. http 요청
    final document = MetadataFetch.responseToDocument(response); /// 2-2. HTML 문자열 전체 가져오기
    if (document == null) throw Exception('urlScrapper: HTML 문자열을 가져올 수 없습니다.');
    final platform = extractPlatform(url);
    final resultMeta = extractMetaData(document);

    // print('플랫폼 : |$platform|');
    // print('combined map: $resultMeta');


    String mainContent = "";
    if (url.contains("youtube.com") || url.contains("youtu.be")) {
      mainContent = await _getYoutubeTranscript(url);
    } else {
      /// 본문 텍스트 추출 (스크립트 제외, 광고같은것도 걸러주는지는 잘 모르겠)
      document
          ?.querySelectorAll('script, style, nav, footer')
          .forEach((e) => e.remove());
      mainContent = document?.body?.text.trim() ?? "";
    }

    final doc = DocumentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      url: url,
      imageUrl: '',
      platform: '',
      category: category,
      aiAnalysis: AIAnalysis(status: AnalysisStatus.analyzing),
    );

    print('doc: $doc');
    print('resultMeta: $resultMeta');
    print('mainContent: $mainContent');
    print('sharedUrlCaption: $sharedUrlCaption');
    return {
      "document": doc,
      "metaData":  resultMeta,
      "mainContent": mainContent,
      "sharedUrlCaption": sharedUrlCaption,
    };
  }

  Future<AIAnalysis> processStep2({
    required DocumentModel doc,
    required Map<String, dynamic> metaData,
    required String mainContent,
    required String sharedUrlCaption,
  }) async {
    final prompt = [
      Content.text('''
      반드시 다음 JSON 형식을 지켜서 응답해줘. 다른 말은 하지 마.
      
      정보:
      - url: ${doc.url}
      - 메타설명: $metaData
      - 본문내용: ${mainContent.length > 2000 ? mainContent.substring(0, 2000) : mainContent}
      - url 캡션: $sharedUrlCaption

      응답 포맷:
      {"platform": "url로 알아낸 플랫폼 이름(예시: 네이버 블로그, 무신사, 알리익스프레스 등)", "summary": "내용 요약 3줄", "tags": ["키워드1", "키워드2", "키워드3", "키워드4"]}
    '''),
    ];

    try {
      final response = await _model.generateContent(prompt);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        print("AI 응답 비어있음");
        return AIAnalysis(status: AnalysisStatus.failed, summary: "AI 응답 없음");
      }

      /// JSON 부분만 추출하는 코드 추가 (Markdown 태그 제거)
      String cleanJson = responseText;
      if (responseText.contains("```json")) {
        cleanJson = responseText.split("```json")[1].split("```")[0].trim();
      } else if (responseText.contains("```")) {
        cleanJson = responseText.split("```")[1].split("```")[0].trim();
      }

      final decoded = jsonDecode(cleanJson);
      return AIAnalysis(
        platform: decoded['platform']?.toString() ?? "알 수 없는 플랫폼",
        summary: decoded['summary']?.toString() ?? "요약 정보가 없습니다.",
        tags: decoded['tags'] != null
            ? List<String>.from(decoded['tags'])
            : [],
        status: AnalysisStatus.completed,
      );
    } catch (e) {
      print("AI 요약 실패 원인: $e");
      return AIAnalysis(status: AnalysisStatus.failed, summary: "에러: $e");
    }
  }

  Future<String> _getYoutubeTranscript(String url) async {
    try {
      var video = await _youtube.videos.get(url);
      var manifest = await _youtube.videos.closedCaptions.getManifest(video.id);
      if (manifest.tracks.isNotEmpty) {
        var track =
            manifest.tracks.where((e) => e.language.code == 'ko').firstOrNull ??
            manifest.tracks.first;
        var captions = await _youtube.videos.closedCaptions.get(track);
        return captions.captions.map((e) => e.text).join(' ');
      }
      return video.description;
    } catch (_) {
      return "";
    }
  }
}

///UI
class AIValidationPage extends StatefulWidget {
  const AIValidationPage({super.key});

  @override
  State<AIValidationPage> createState() => _AIValidationPageState();
}

class _AIValidationPageState extends State<AIValidationPage> {
  final LinkProcessor _processor = LinkProcessor();
  List<DocumentModel> _items = [];

  ///테스트 리스트
  final List<String> _testUrls = [
    'https://www.instagram.com/p/DSFFEw9kwzs/?igsh=eWJzYTV4ODZxdmdm',
    'https://x.com/imrealdonmisae/status/1986016225462460591?s=20',
    'https://x.com/imrealdonmisae/status/2006942288954695851?s=46',
    'https://m.blog.naver.com/bboddo00_/224127191364',
    '남산와이너리 어때요? 캐치테이블에서 확인해보세요! https://app.catchtable.co.kr/ct/shop/namsan_winery?from=share&type=DINING',
    'https://www.teamblind.com/kr/company/%EC%98%A4%EB%B8%8C%EC%A0%A0/',
    'https://api-shein.shein.com/h5/sharejump/appjump?link=lorEeS6nUwg_8&localcountry=KR&url_from=GM76053970465',
    'https://www.figma.com/design/2eMChlR1tjc8ljbynEMPXI/archivy-%EA%B0%80%EC%A0%9C-?node-id=55-448&t=4L4gninoHGtHati6-1',
    'https://a.aliexpress.com/_c4X3Qfnr',
    'https://naver.me/FFaMMrC0',
    'https://velog.io/@dkdldhels10/%EC%99%9C-%EC%B7%A8%EC%97%85%EC%9D%B4-%ED%9E%98%EB%93%A4%EA%B9%8C',
    'https://github.com/summerhater/teeklit',
    'https://youtube.com/shorts/ZwocDHFD5V4?si=ar92HnSuTphH79Wi',
    'https://youtu.be/8PEUBRxlzFQ?si=vf6UWvFd3BypN_Mt',
    '[Blind] 블라인드에 올라온 글 보셨어요? 프로토스를 상징하는 유닛은 뭐라고생각함?? (블라블라) https://www.teamblind.com/kr/s/bbr45epg',
    'https://www.yna.co.kr/view/AKR20251230156300004?section=local/all',
    'https://mediahub.seoul.go.kr/archives/2016614',
    'https://www.joongang.co.kr/article/25393978',
    'https://brunch.co.kr/@b3124d27a8eb4a1/20',
    'https://damduck01.tistory.com/3746',
    'https://www.gpters.org/marketing/post/converting-toss-voice-stone-Sx4k3fHwbrSietx',
    'https://engineering.linecorp.com/ko/blog/flutter-architecture-getx-bloc-provider',
    'https://zigzag.kr/catalog/products/141360158',
    'https://musinsa.onelink.me/PvkC/r1zgkhb8',
  ];

  int _currentIdx = 0;

  void _handleSave() async {
    final rawText = _testUrls[_currentIdx];
    _currentIdx = (_currentIdx + 1) % _testUrls.length;

    try {
      final result = await _processor.urlScrapper(rawText, "테스트");
      DocumentModel doc = result['document'];
      setState(() => _items.insert(0, doc));
      final aiResult = await _processor.processStep2(
        doc: doc,
        metaData: result['metaData'],
        mainContent: result['mainContent'],
        sharedUrlCaption: result['sharedUrlCaption'],
      );


      setState(() {
        int index = _items.indexWhere((item) => item.id == doc.id);
        if (index != -1)
          _items[index] = _items[index].copyWith(aiAnalysis: aiResult);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("에러: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI 요약 테스트")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleSave,
        label: Text("다음 링크 추가"),
        icon: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: item.imageUrl.isNotEmpty
                  ? NetworkImage(item.imageUrl)
                  : null,
              child: item.imageUrl.isEmpty ? Icon(Icons.link) : null,
            ),
            title: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              item.aiAnalysis.status == AnalysisStatus.analyzing
                  ? "AI가 내용을 읽는 중..."
                  : item.aiAnalysis.tags.map((t) => "#$t").join(" "),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailPage(doc: item)),
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final DocumentModel doc;
  const DetailPage({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doc.platform)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (doc.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(doc.imageUrl),
              ),
            SizedBox(height: 24),
            Text(
              doc.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(doc.url, style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI 요약",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (doc.aiAnalysis.status == AnalysisStatus.analyzing)
                    LinearProgressIndicator()
                  else
                    Text(
                      doc.aiAnalysis.summary ?? "요약 실패",
                      style: TextStyle(height: 1.6),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: doc.aiAnalysis.tags
                  .map((t) => Chip(label: Text("#$t")))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
