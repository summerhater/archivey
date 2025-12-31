import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:firebase_ai/firebase_ai.dart'; // 프로젝트 설정에 맞춰 확인 필요

class AiSummaryTest extends StatefulWidget {
  const AiSummaryTest({super.key});

  @override
  State<AiSummaryTest> createState() => _AiSummaryTestState();
}

class _AiSummaryTestState extends State<AiSummaryTest> {
  // 1. 테스트 URL 리스트
  final List<String> urlList = [
    'https://api-shein.shein.com/h5/sharejump/appjump?link=lorEeS6nUwg_8&localcountry=KR&url_from=GM76053970465',
    'https://a.aliexpress.com/_c4X3Qfnr',
    'https://naver.me/FFaMMrC0',
    'https://www.instagram.com/p/DSFFEw9kwzs/?igsh=eWJzYTV4ODZxdmdm',
    'https://m.blog.naver.com/bboddo00_/224127191364',
    'https://app.catchtable.co.kr/ct/shop/namsan_winery?from=share&type=DINING',
    'https://velog.io/@dkdldhels10/%EC%99%9C-%EC%B7%A8%EC%97%85%EC%9D%B4-%ED%9E%98%EB%93%A4%EA%B9%8C',
    'https://github.com/summerhater/teeklit',
    'https://youtube.com/shorts/ZwocDHFD5V4?si=ar92HnSuTphH79Wi',
    'https://youtu.be/8PEUBRxlzFQ?si=vf6UWvFd3BypN_Mt',
    'https://www.teamblind.com/kr/company/%EC%98%A4%EB%B8%8C%EC%A0%A0/',
    'https://www.teamblind.com/kr/s/bbr45epg',
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

  Map<String, dynamic> testResults = {};
  bool isTesting = false;

  // 2. 단축 URL 해제 (Redirect 추적)
  Future<String> getFinalUrl(String url) async {
    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url))..followRedirects = false;
      final response = await client.send(request);

      if (response.statusCode >= 300 && response.statusCode < 400) {
        String? location = response.headers['location'];
        if (location != null) return location;
      }
    } catch (e) {
      print('Redirect Error: $e');
    }
    return url;
  }

  // 3. 핵심 파이프라인: Metadata -> Data Quality Check -> Gemini Fallback
  Future<void> runValidation() async {
    setState(() {
      isTesting = true;
      testResults = {};
    });

    for (String url in urlList) {
      String finalUrl = await getFinalUrl(url);

      // [1단계] Metadata 추출
      var data = await MetadataFetch.extract(finalUrl);

      String title = data?.title ?? "No Title";
      String? imageUrl = data?.image;

      // [2단계] 데이터 질 판별 (SPA나 보안 페이지 특징 필터링)
      bool isPoor = title.length < 10 ||
          title.contains("Challenge") ||
          title.toLowerCase() == "shein" ||
          title.toLowerCase() == "instagram";

      String finalAnalysis = "";

      if (isPoor && imageUrl != null) {
        // [3단계] Gemini Multimodal (이론상 호출 부분)
        finalAnalysis = "[AI 분석 필요] 이미지($imageUrl)와 플랫폼명($title)으로 분석 수행 예정";
        // 실제 연동 시: await callGeminiVision(imageUrl, title);
      } else {
        finalAnalysis = "[정상 추출] $title";
      }

      setState(() {
        testResults[url] = {
          "title": title,
          "image": imageUrl,
          "isPoor": isPoor,
          "analysis": finalAnalysis,
        };
      });
    }

    setState(() => isTesting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("스크래핑 기술 검증")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isTesting ? null : runValidation,
              child: isTesting ? const CircularProgressIndicator() : const Text("전체 리스트 테스트 시작"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: urlList.length,
              itemBuilder: (context, index) {
                String url = urlList[index];
                var res = testResults[url];
                if (res == null) return ListTile(title: Text(url), subtitle: const Text("대기 중..."));

                return Card(
                  color: res['isPoor'] ? Colors.orange[50] : Colors.green[50],
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: res['image'] != null
                        ? Image.network(res['image'], width: 50, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
                        : const Icon(Icons.image_not_supported),
                    title: Text(res['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("URL: $url", maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text("결과: ${res['analysis']}", style: TextStyle(color: res['isPoor'] ? Colors.red : Colors.blue)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as html_parser;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_ai/firebase_ai.dart';
// import 'package:metadata_fetch/metadata_fetch.dart';
// import '../../firebase_options.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// class AiSummaryTest extends StatefulWidget {
//   const AiSummaryTest({super.key});
//
//   @override
//   State<AiSummaryTest> createState() => _AiSummaryTestState();
// }
//
// class _AiSummaryTestState extends State<AiSummaryTest> {
//   String parsedTitle = '';
//   String unshorteningUrl = '';
//
//   Future<String> getFinalUrl(String url) async {
//     final client = http.Client();
//     final request = http.Request('GET', Uri.parse(url))
//       ..followRedirects = false;
//
//     /// 자동 리디렉션 끄고 직접 추적
//
//     final response = await client.send(request);
//
//     // 301(Moved Permanently) 또는 302(Found) 체크
//     if (response.statusCode == 301 || response.statusCode == 302) {
//       var finalUrl = response.headers['location'];
//       if (finalUrl != null) {
//         if (finalUrl.startsWith('/')) {
//           final uri = Uri.parse(url);
//           finalUrl = '${uri.scheme}://${uri.host}$finalUrl';
//         }
//       }
//       return finalUrl ?? url;
//     }
//
//     return url;
//
//     /// 리디렉션이 없으면 원래 URL 반환(일반 링크일때)
//   }
//
//   // Future<void> fetchData() async {
//   //   // unshorteningUrl= await getFinalUrl('https://buly.kr/EI4xZnk');
//   //   unshorteningUrl= await getFinalUrl('https://www.instagram.com/p/DCYgzsIyqHD/?utm_source=ig_web_copy_link&igsh=NTc4MTIwNjQ2YQ==');
//   //   final response = await http.get(Uri.parse(unshorteningUrl));
//   //
//   //   if (response.statusCode == 200) {
//   //     final htmlString = response.body;
//   //     final document = htmlParser.parse(htmlString);
//   //
//   //     // 원하는 HTML 요소를 선택하고 값 추출
//   //     final titleElement = document.querySelector('title');
//   //     final title = titleElement?.text ?? '';
//   //
//   //     setState(() {
//   //       parsedTitle = title; // 원하는 정보로 변경
//   //     });
//   //   } else {
//   //     // HTTP 요청이 실패한 경우 예외 처리를 추가
//   //     print('Failed to load HTML');
//   //   }
//   // }
//
//   Future<String?> getHtmlContent(String url) async {
//     try {
//       // 1. 단순하게 HTML 텍스트만 바로 읽어오기
//       // (리디렉션이 모두 완료된 최종 URL을 넣는 것이 좋습니다)
//
//       final String html = await http.read(Uri.parse(url));
//       return html;
//     } catch (e) {
//       print('HTML 로딩 실패: $e');
//       return null;
//     }
//   }
//
//   String cleanHtml(String html) {
//     var document = html_parser.parse(html);
//     // script, style 태그 제거
//     // document.querySelectorAll('script, style, noscript, iframe, head').forEach((e) => e.remove());
//     // 텍스트만 추출하거나, 특정 ID/Class의 본문만 추출
//     return document.body?.text ?? "";
//   }
//
//   Map<String, String> imageAndTextTest1(String html) {
//     var document = html_parser.parse(html);
//
//     String? imageUrl =
//         document
//             .querySelector('meta[property="og:image"]')
//             ?.attributes['content'] ??
//         document
//             .querySelector('meta[name="twitter:image"]')
//             ?.attributes['content'];
//
//     // 전략 B: 메타 태그에 없으면 본문의 첫 번째 큰 이미지
//     if (imageUrl == null || imageUrl.isEmpty) {
//       var firstImg = document.querySelector(
//         'img[src^="http"]',
//       ); // http로 시작하는 src 찾기
//       print('firstImg : $firstImg');
//       imageUrl = firstImg?.attributes['src'];
//     }
//
//     // 2. 유의미한 텍스트 추출 (청소 로직)
//     // 분석에 방해되는 태그들 완전히 제거
//     document
//         .querySelectorAll(
//           'script, style, noscript, head, header, footer, nav, iframe',
//         )
//         .forEach((e) => e.remove());
//
//     // 본문에서 텍스트만 뽑고 공백 정리
//     String rawText = document.body?.text ?? "";
//     print('rawText : $rawText');
//     String cleanText = rawText.replaceAll(RegExp(r'\s+'), ' ').trim();
//     print('cleanText : $cleanText');
//
//     // 3. 텍스트가 너무 길면 Gemini 토큰 제한을 위해 자르기 (약 5000자 권장)
//     if (cleanText.length > 5000) {
//       cleanText = cleanText.substring(0, 5000) + "...(이하 생략)";
//     }
//
//     print('imageUrl : $imageUrl');
//     print('text : $cleanText');
//
//     return {
//       'imageUrl': imageUrl ?? '',
//       'text': cleanText,
//     };
//   }
//
//   Future<String?> getResponseFromGemini(String html) async {
//     ///1. 퓨어한 unshortening url 알아내기
//     unshorteningUrl = await getFinalUrl(html);
//     print('unshorteningURL : $unshorteningUrl');
//
//     ///2. url의 html 받아오기
//     String? unfilteredHTML = await getHtmlContent(unshorteningUrl);
//     if (unfilteredHTML == null) {
//       print('unfilteredHTML이 null입니다.');
//     }
//
//     ///3. html 코드에서 불필요한 부분을 잘라내기
//     String filteredHTML = cleanHtml(unfilteredHTML!);
//
//     ///4. 필터링한 cleanHTML을 gemini에게 넘기고 분석 요청하기
//
//     return filteredHTML;
//     // Initialize the Gemini Developer API backend service
//     // Create a `GenerativeModel` instance with a model that supports your use case
//     // final model =
//     FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
//     //
//     // // Provide a prompt that contains text
//     // final prompt = [Content.text('너는 최고의 ai 에이전트로써 ')];
//     //
//     // // To generate text output, call generateContent with the text input
//     // final response = await model.generateContent(prompt);
//     //
//     // return response.text;
//   }
//
//   HeadlessInAppWebView? headlessWebView;
//
//   Future<String?> getHtmlGoodExample(String url) async {
//     // 1. "완료될 때까지 기다려!"라고 선언하는 박스 생성
//     final Completer<String?> completer = Completer<String?>();
//
//     headlessWebView = HeadlessInAppWebView(
//       initialUrlRequest: URLRequest(
//         url: WebUri(url),
//         headers: {
//           'User-Agent':
//               'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
//           'Accept-Language': 'ko-KR,ko;q=0.9,en-US;q=0.8',
//         },
//       ),
//       initialSettings: InAppWebViewSettings(
//         javaScriptEnabled: true, // 자바스크립트 허용 (필수)
//         isInspectable: true,
//         useShouldOverrideUrlLoading: true,
//         userAgent:
//             'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', // 다시 한번 강조
//       ),
//       onLoadStop: (controller, url) async {
//         await Future.delayed(Duration(seconds: 2));
//         String? html = await controller.getHtml();
//         // 2. 데이터가 도착하면 박스를 채우고 '완료' 신호를 보냄
//         completer.complete(html);
//         headlessWebView?.dispose();
//       },
//     );
//
//     await headlessWebView?.run();
//
//     // 3. 박스가 채워질 때까지 리턴하지 않고 여기서 기다림(await)
//     return completer.future;
//   }
//
//   Future<Metadata?> getQuickInfo(String url) async {
//     Metadata? data = await MetadataFetch.extract(url);
//     // print('url : ${data?.url}'); // 상품명
//     // print('title : ${data?.title}'); // 상품명
//     // print('image : ${data?.image}'); // 상품명
//     // print('description : ${data?.description}'); // 상품명
//     return data;
//   }
//
//   Future<String> getResponseMapFromGemini(String html) async {
//     //Future<GenerateContentResponse> getResponseMapFromGemini(String html) async
//     ///1. 퓨어한 unshortening url 알아내기
//     unshorteningUrl = await getFinalUrl(html);
//     print('unshorteningURL : $unshorteningUrl');
//
//     ///2. url의 html 받아오기
//     String? unfilteredHTML = await getHtmlContent(unshorteningUrl);
//     // print('unfilteredHTML: ${unfilteredHTML?.length}');
//     // String? unfilteredHTML = await getHtmlGoodExample(unshorteningUrl);
//     // await getQuickInfo(unshorteningUrl);
//     if (unfilteredHTML == null) {
//       print('unfilteredHTML이 null입니다.');
//     } else {
//       // print('unfilteredHTML: $unfilteredHTML');
//     }
//     String filteredHTML = cleanHtml(unfilteredHTML!);
//     return filteredHTML ?? '';
//
//     ///3. html 코드에서 불필요한 부분을 잘라내기
//     // Map<String, String> filteredMap = imageAndTextTest1(unfilteredHTML!);
//     // Map<String, String> filteredMap = imageAndTextTest1('');
//     ///4. 필터링한 cleanHTML을 gemini에게 넘기고 분석 요청하기
//     // print('imageUrl : ${filteredMap['imageUrl']}');
//     // print('text : ${filteredMap['text']}');
// //     final model = FirebaseAI.googleAI().generativeModel(
// //       model: 'gemini-2.5-flash',
// //     );
// //
// //     // Provide a prompt that contains text
// //     final prompt = [
// //       Content.text('''
// // 너는 웹 페이지 분석 전문가야. 아래 제공된 텍스트 데이터를 읽고 사용자가 내용을 한눈에 파악할 수 있도록 정리해줘.
// //
// // [지침]
// // - 전문적인 톤을 유지하되 이해하기 쉽게 작성할 것.
// // - 데이터에 구체적인 수치(가격, 날짜 등)가 있다면 반드시 포함할 것.
// // - 만약 데이터가 부족하여 파악이 어렵다면 "정보 부족"이라고 명시할 것.
// //
// // [데이터 시작]
// // $unfilteredHTML
// // [데이터 끝]
// //
// // [응답 양식]
// // ■ 플랫폼 이름:
// // ■ 제목:
// // ■ 요약:
// //   •
// //   •
// //   •
// // ■ 주요 포인트:
// // ■ 연관 태그:
// // '''),
// //     ];
//
//     // To generate text output, call generateContent with the text input
//     // final response = await model.generateContent(prompt);
//     // return response;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // fetchData();
//     _quickInfoFutures = urlList.map((url) => getQuickInfo(url)).toList();
//   }
//
//   String _displayText = '버튼을 눌러 분석을 시작하세요.';
//   String _displayPhotoUrl = '';
//   bool _isLoading = false; // 로딩 상태 확인용
//
//   List<String> urlList = [
//     'https://api-shein.shein.com/h5/sharejump/appjump?link=lorEeS6nUwg_8&localcountry=KR&url_from=GM76053970465',
//     'https://a.aliexpress.com/_c4X3Qfnr',
//     'https://naver.me/FFaMMrC0',
//     'https://www.instagram.com/p/DSFFEw9kwzs/?igsh=eWJzYTV4ODZxdmdm',
//     'https://m.blog.naver.com/bboddo00_/224127191364',
//     'https://app.catchtable.co.kr/ct/shop/namsan_winery?from=share&type=DINING',
//     'https://velog.io/@dkdldhels10/%EC%99%9C-%EC%B7%A8%EC%97%85%EC%9D%B4-%ED%9E%98%EB%93%A4%EA%B9%8C',
//     'https://github.com/summerhater/teeklit',
//     'https://youtube.com/shorts/ZwocDHFD5V4?si=ar92HnSuTphH79Wi',
//     'https://youtube.com/shorts/A_mU7gvTyjM?si=ovfltZF_qmdsvb-c',
//     'https://youtu.be/8PEUBRxlzFQ?si=vf6UWvFd3BypN_Mt',
//   ];
//
//   late final List<Future<Metadata?>> _quickInfoFutures;
//     String? text = '';
//   @override
//   Widget build(BuildContext context) {
//     String? imageUrl;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, size: 18),
//           color: Colors.deepOrange,
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 text = await getResponseMapFromGemini(
//                   'https://app.catchtable.co.kr/ct/shop/namsan_winery?from=share&type=DINING',
//                 );
//                 // print(test1.text);
//                 // print(test1);
//                 setState(() {
//                   // imageUrl = appUrlFiltered['imageUrl'];
//                   // text = appUrlFiltered['text'];
//                   // text = test1.text;
//                   text;
//                 });
//               },
//               child: Text('버튼'),
//             ),
//             Text('추출된 filteredhtml text : '),
//              Expanded(
//                child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Expanded(child: SingleChildScrollView(child: Text(text!))),
//                 ),
//              ),
//             SizedBox(
//               height: 30,
//             ),
//             // Expanded(
//             //   child: ListView.builder(
//             //     padding: const EdgeInsets.symmetric(vertical: 20),
//             //     itemCount: urlList.length,
//             //     itemBuilder: (context, index) {
//             //       return FutureBuilder<Metadata?>(
//             //         future: _quickInfoFutures[index],
//             //         builder: (context, snapshot) {
//             //           if (snapshot.connectionState == ConnectionState.waiting) {
//             //             return const Padding(
//             //               padding: EdgeInsets.all(16),
//             //               child: CircularProgressIndicator(),
//             //             );
//             //           }
//             //
//             //           if (!snapshot.hasData) {
//             //             return const SizedBox.shrink();
//             //           }
//             //
//             //           final data = snapshot.data!;
//             //
//             //           return Container(
//             //             color: Colors.grey,
//             //             padding: const EdgeInsets.all(12),
//             //             child: Column(
//             //               crossAxisAlignment: CrossAxisAlignment.start,
//             //               children: [
//             //                 Text('title : ${data.title ?? ''}'),
//             //                 Text('url : ${data.url ?? ''}'),
//             //                 Text('image : ${data.image ?? ''}'),
//             //                 Text('description : ${data.description ?? ''}'),
//             //                 const Divider(height: 40),
//             //               ],
//             //             ),
//             //           );
//             //         },
//             //       );
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             ListView.builder(
//               itemCount: urlList.length,
//               itemBuilder: (context, index) {
//                 return FutureBuilder(
//                   future: _quickInfoFutures[index],
//                   builder: (context, asyncSnapshot) {
//                     final data = asyncSnapshot.data;
//                     return Container(
//                       color: Colors.grey,
//                       child: Column(
//                         children: [
//                           Text('title : ${data?.title ?? ''}'),
//                           Text('url : ${data?.url ?? ''}'),
//                           Text('image : ${data?.image ?? ''}'),
//                           Text('description : ${data?.description ?? ''}'),
//                           const Divider(height: 40),
//                           SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//             // ElevatedButton(
//             //   onPressed: _isLoading
//             //       ? null // 로딩 중에는 버튼 비활성화
//             //       : () async {
//             //     // 2. 로딩 시작 상태로 변경
//             //     setState(() {
//             //       _isLoading = true;
//             //       _displayText = 'AI가 분석 중입니다...';
//             //     });
//             //
//             //     try {
//             //       // 3. 비동기 함수 호출 (await 사용)
//             //       final cleanHTML = await getResponseMapFromGemini('https://api-shein.shein.com/h5/sharejump/appjump?link=lorEeS6nUwg_8&localcountry=KR&url_from=GM76053970465');
//             //       // 4. 결과 업데이트 및 로딩 종료
//             //       setState(() {
//             //         _displayText = cleanHTML['text'] ?? '결과를 가져오지 못했습니다.';
//             //         _displayPhotoUrl = cleanHTML['imageUrl'] ?? '사진 결과를 가져오지 못했습니다.';
//             //         _isLoading = false;
//             //       });
//             //     } catch (e) {
//             //       setState(() {
//             //         _displayText = '에러 발생: $e';
//             //         _isLoading = false;
//             //       });
//             //     }
//             //   },
//             //   child: _isLoading
//             //       ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
//             //       : const Text('클린 html 보기'),
//             // ),
//             // const Divider(height: 40),
//             // 5. 결과물 출력 부분
//             // Padding(
//             //   padding: const EdgeInsets.all(16.0),
//             //   child: Container(
//             //     width: double.infinity,
//             //     padding: const EdgeInsets.all(12),
//             //     decoration: BoxDecoration(
//             //       color: Colors.grey[100],
//             //       borderRadius: BorderRadius.circular(8),
//             //     ),
//             //     child: Column(
//             //       children: [
//             //         Text('이미지 url: $_displayPhotoUrl'),
//             //         Text(_displayText),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
