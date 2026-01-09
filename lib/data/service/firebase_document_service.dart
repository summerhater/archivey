import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:firebase_ai/firebase_ai.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/document_model_on_progress.dart';

enum DataQuality {
  enough,
  titleOnly,
  contentOnly,
  none,
}

class FirebaseDocumentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  final String _collectionPath = 'documents';

  final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );

  Map<String, dynamic> _scrapeMetaData(dom.Document document) {
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

  String _scrapePlatform(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();

      /// 1: 명확한 처리가 필요한 슈퍼 플랫폼 10~20개만 매핑 (예외 처리용)
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

      /// 호스트의 끝부분이 매핑 테이블에 있는지 확인
      for (var domain in superPlatforms.keys) {
        if (host.endsWith(domain)) return superPlatforms[domain]!;
      }

      /// 2: 자동 추출 알고리즘 (나머지 수만 개의 사이트 대응)
      // 공통적인 서브도메인(www, m, blog, news )과 TLD(.com, .co.kr)를 제거
      List<String> parts = host.split('.');

      /// 제거할 무의미한 서브도메인들
      const junkSubdomains = {
        'www',
        'm',
        'blog',
        'news',
        'cafe',
        'app',
        'shop',
        'mail',
        'api',
      };

      /// junkSubdomains에 해당하는 앞부분을 제거
      List<String> filteredParts = parts
          .where((p) => !junkSubdomains.contains(p))
          .toList();

      if (filteredParts.isNotEmpty) {
        /// 가장 핵심이 되는 첫 번째 마디를 대문자로 변환 (예: zigzag.kr -> ZIGZAG)
        return filteredParts[0].toUpperCase();
      }

      return host;
      // return 'Unknown';
    } catch (e) {
      return "Unknown";
    }
  }

  Future<String> _getYoutubeTranscript(String url) async {
    final _youtube = YoutubeExplode();
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

  Future<String> _scrapeBodyText(String url, dom.Document document) async {
    String mainContent = "";
    if (url.contains("youtube.com") || url.contains("youtu.be")) {
      mainContent = await _getYoutubeTranscript(url);
    } else {
      document
          .querySelectorAll(
            'script, style, nav, footer, header, aside, form, iframe, button',
          )
          .forEach((e) => e.remove());
      mainContent = document.body?.text.trim() ?? "";
    }
    return mainContent;
  }

  String _makeValidContentText(
    String? metadataDescription,
    String bodyText,
    String sharedUrlCaption,
  ) {
    StringBuffer buf = StringBuffer();

    if (metadataDescription != null && metadataDescription.isNotEmpty) {
      buf.writeln("[메타데이터 Description]");
      buf.writeln(metadataDescription);
      buf.writeln('');
    }

    if (sharedUrlCaption.isNotEmpty) {
      buf.writeln('[링크와 함께 공유된 캡션 텍스트]');
      buf.writeln(sharedUrlCaption);
      buf.writeln('');
    }

    if (bodyText.contains('<style>') || bodyText.contains('errorContainer')) {
      bodyText = "본문 텍스트를 가져올 수 없는 URL입니다.";
    } else {
      if (bodyText.length > 4000) {
        bodyText = bodyText.substring(0, 4000);
      }
    }

    buf.writeln("[웹페이지 본문]");
    buf.writeln(bodyText);
    buf.writeln('');

    return buf.toString();
  }

  Future<(DocumentModel, String)> scrapeUrlAndPrepare(
    String rawText,
    CategoryModel category,
    String? memo,
  ) async {
    final urlMatch = RegExp(r"(https?://[^\s]+)").firstMatch(rawText);
    if (urlMatch == null) throw Exception('URL을 찾을 수 없습니다.');
    final url = urlMatch.group(0)!;
    final sharedUrlCaption = rawText.replaceAll(url, "").trim();

    try {
      final response = await http
          .get(
            Uri.parse(url),
            // headers: {
            //   'User-Agent':
            //       'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            // },
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) throw Exception('페이지를 불러올 수 없습니다.');

      final document = MetadataFetch.responseToDocument(response);
      if (document == null) throw Exception('URL 파싱 실패');

      final platform = _scrapePlatform(url);

      Map<String, dynamic> metadata = {};
      try {
        metadata = _scrapeMetaData(document);
      } catch (e) {
        print('Metadata 스크래핑 실패 : $e');
      }

      print('metadata: $metadata');

      String bodyText = "";
      try {
        bodyText = await _scrapeBodyText(url, document);
      } catch (e) {
        print('bodyText 스크래핑 실패: $e');
      }

      final contentText = _makeValidContentText(
        metadata['description'],
        bodyText,
        sharedUrlCaption,
      );

      if (user == null) {
        throw Exception('User not authenticated');
      }

      final newDoc = DocumentModel(
        uid: user!.uid,
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
        url: url,
        title: (metadata['title']?.toString().trim() ?? '').isNotEmpty
            ? metadata['title']
                  .toString()
                  .trim()
            : (sharedUrlCaption.isNotEmpty ? sharedUrlCaption : '제목 없는 링크'),
        imageUrl: metadata['image'] ?? '',
        platform: platform,
        category: category,
        userMemo: memo ?? '',
        aiStatus: AiTaskStatus.analyzing,
      );

      return (newDoc, contentText);
    } catch (e) {
      print('스크래핑 에러: $e');
      rethrow;
    }
  }

  DataQuality evaluateDataQuality({
    required String title,
    required String contentText,
  }) {
    final hasTitle = title != '제목 없는 링크';
    final hasContent = contentText.length > 150 ? true : false;

    if (hasTitle && hasContent) return DataQuality.enough;
    if (hasTitle && !hasContent) return DataQuality.titleOnly;
    if (!hasTitle && hasContent) return DataQuality.contentOnly;
    return DataQuality.none;
  }

  List<Content> buildPromptByDataQuality({
    required DataQuality quality,
    required DocumentModel document,
    required String contentText,
  }) {
    /// 공통 제약사항
    const commonInstructions = '''
언어: 모든 응답은 한국어로 작성하라. 문어체(~함, ~임)가 아닌 서술체(~입니다)로 작성하라. 
형식: 반드시 순수 JSON 데이터만 출력하라. (마크다운 코드 블록 제외, 텍스트 설명 금지)
주의: JSON 문법을 엄격히 준수하라.
중요 제약사항: 만약 [본문 내용]이 "자바스크립트 활성화 요청", "브라우저 업데이트 안내", "로그인 페이지" 등 
   실제 콘텐츠와 무관한 시스템 메시지라면, [본문 내용]을 무시하고 오직 URL과 제목 정보를 바탕으로 
   콘텐츠의 성격을 추론하여 요약하라. 절대 "자바스크립트 활성화가 필요합니다"라는 식의 답변을 summary와 tags에 포함하지 마라.
''';

    if (quality == DataQuality.enough) {
      print('Data Quality: enough');
      print('contentText : $contentText');
      return [
        Content.text('''
$commonInstructions
너는 전문적인 콘텐츠 요약가이다. 제공된 본문을 분석하여 핵심 내용을 추출하라.

[데이터]
- URL: ${document.url}
- 제목: ${document.title}
- 플랫폼: ${document.platform}
- 본문 내용: $contentText

[요약 가이드라인]
1. **요약의 길이는 본문의 정보 밀도에 비례해야 한다.**
   - 본문이 짧거나 정보가 제한적일 경우: 핵심을 3~4문장 내외로 간결하게 요약하라.
   - 본문이 길고 유용한 정보(수치, 구체적 사례, 단계별 설명 등)가 많을 경우: 이를 누락하지 말고 10문장 이상의 상세한 요약(Detail Summary)을 작성하라.
2. 중요한 세부 사항(구체적인 방법론, 가격, 위치, 팁 등)을 요약 효율성을 이유로 임의로 제거하지 마라. 
3. 본문에 없는 사실을 왜곡하거나 상상해서 적지 마라.
4. 태그는 본문에서 가장 중요한 키워드 4개를 선정하되, 플랫폼명이나 제목의 일부보다는 의미 있는 단어를 사용하라.

[응답 포맷]
{
  "summary": "핵심 요약 내용",
  "tags": ["키워드1", "키워드2", "키워드3", "키워드4"]
}
'''),
      ];
    } else if (quality == DataQuality.titleOnly) {
      print('Data Quality: titleOnly');
      print('title: ${document.title}');
      return [
        Content.text('''
$commonInstructions
제공된 정보가 제한적이다. 제목과 URL 정보를 바탕으로 해당 콘텐츠의 성격을 전문적으로 추론하여 설명하라.

[데이터]
- URL: ${document.url}
- 제목: ${document.title}
- 플랫폼: ${document.platform}

[가이드라인]
1. 제목에 포함된 단어와 플랫폼의 특성을 결합하여, 사용자가 이 링크를 클릭했을 때 기대할 수 있는 내용을 2~3줄로 설명하라.
2. 제목이 곧 요약이 되지 않도록 문장을 재구성하라.
3. 태그는 해당 주제 분야(예: 기술, 요리, 뉴스)와 핵심 대상을 포함하라.

[응답 포맷]
{
  "summary": "제목 기반 콘텐츠 예상 설명",
  "tags": ["분야", "주제", "대상", "특징"]
}
'''),
      ];
    } else if (quality == DataQuality.contentOnly) {
      print('Data Quality: contentOnly');
      return [
        Content.text('''
$commonInstructions
이 링크는 제목 정보가 없고 본문만 존재한다. 본문 내용을 분석하여 적절한 제목을 생성하고 내용을 요약하라.

[데이터] URL: ${document.url}, 플랫폼: ${document.platform}, 본문: $contentText

[요약 가이드라인]
1. 본문의 핵심 내용을 관통하는 명확하고 매력적인 "제목"을 새로 생성하라.
2. **요약의 길이는 본문의 정보 밀도에 비례해야 한다.**
   - 본문이 짧거나 정보가 제한적일 경우: 핵심을 3~4문장 내외로 간결하게 요약하라.
   - 본문이 길고 유용한 정보(수치, 구체적 사례, 단계별 설명 등)가 많을 경우: 이를 누락하지 말고 10문장 이상의 상세한 요약(Detail Summary)을 작성하라.
3. 중요한 세부 사항(구체적인 방법론, 가격, 위치, 팁 등)을 요약 효율성을 이유로 임의로 제거하지 마라.
3. 태그는 4개 생성하라.

[응답 포맷]
{
  "title": "생성된 제목",
  "summary": "내용 설명",
  "tags": ["키워드1", "키워드2", "키워드3", "키워드4"]
}
'''),
      ];
    } else {
      // DataQuality.none
      print('Data Quality: none');
      return [
        Content.text('''
$commonInstructions
이 링크는 제목과 본문 정보가 없다. URL과 플랫폼을 분석하여 제목을 추측하고 콘텐츠를 요약하라.

[데이터] URL: ${document.url}, 플랫폼: ${document.platform}

[가이드라인]
1. URL 구조와 도메인을 분석하여 가장 가능성 높은 "제목"을 추측하여 생성하라.
2. 콘텐츠의 성격을 추정하여 2~3줄로 설명하라. (추정임을 명시)

[응답 포맷]
{
  "title": "추론된 제목",
  "summary": "추정에 기반한 설명",
  "tags": ["키워드1", "키워드2", "키워드3", "키워드4"]
}
'''),
      ];
    }
  }

  Future<DocumentModel> getAiSummary({
    required DocumentModel document,
    required String contentText,
  }) async {
    DataQuality quality = evaluateDataQuality(
      title: document.title,
      contentText: contentText,
    );

    final prompt = buildPromptByDataQuality(
      document: document,
      quality: quality,
      contentText: contentText,
    );

    try {
      final response = await _model.generateContent(prompt);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        return document.copyWith(aiStatus: AiTaskStatus.failed, aiSummary: "AI 요약 실패");
      }

      String cleanJson = responseText;
      if (responseText.contains("```json")) {
        cleanJson = responseText.split("```json")[1].split("```")[0].trim();
      } else if (responseText.contains("```")) {
        cleanJson = responseText.split("```")[1].split("```")[0].trim();
      }

      final decoded = jsonDecode(cleanJson);

      /// AI가 제목을 새로 생성했는지 확인 (없으면 기존 제목 유지)
      String finalTitle = decoded['title']?.toString() ?? document.title;

      return document.copyWith(
        title: finalTitle,
        aiSummary: decoded['summary']?.toString() ?? "요약 정보가 없습니다.",
        tags: decoded['tags'] != null ? List<String>.from(decoded['tags']) : [],
        aiStatus: AiTaskStatus.completed,
      );
    } catch (e) {
      print("AI 요약 실패 원인: $e");
      return document.copyWith(aiStatus: AiTaskStatus.failed, aiSummary: "에러: $e");
    }
  }

  Future<List<DocumentModel>> fetchDocuments() async {
    try {
      /// 'documents' 컬렉션에서 생성일(createdAt) 역순으로 정렬하여 가져옴
      final querySnapshot = await _db
          .collection(_collectionPath)
          .orderBy('createdAt', descending: true)
          .get();

      /// 가져온 문서를 DocumentModel 객체 리스트로 변환
      return querySnapshot.docs
          .map((doc) => DocumentModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("데이터 불러오기 에러: $e");
      return []; /// 에러면 빈 리스트 반환
    }
  }

  // CREATE: 도큐먼트 저장
  Future<void> saveDocument(DocumentModel document) async {
    await _db
        .collection(_collectionPath)
        .doc(document.id)
        .set(document.toMap());
  }

  // READ: 실시간 스트림 (최신순)
  Stream<List<DocumentModel>> getDocumentsStream() {
    return _db
        .collection(_collectionPath)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DocumentModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // UPDATE: 특정 필드 혹은 전체 업데이트 (AI 요약 완료 시 호출)
  Future<void> updateDocument(DocumentModel document) async {
    await _db
        .collection(_collectionPath)
        .doc(document.id)
        .update(document.toMap());
  }

  // DELETE: 삭제
  Future<void> deleteDocument(String id) async {
    await _db.collection(_collectionPath).doc(id).delete();
  }
}
