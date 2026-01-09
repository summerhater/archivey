enum AnalysisStatus { pending, analyzing, completed, failed }

class AIAnalysis {
  final String? summary;
  final List<String> tags;
  final AnalysisStatus status;

  AIAnalysis({
    this.summary,
    this.tags = const [],
    this.status = AnalysisStatus.pending,
  });
}

class DocumentModel {
  final String id;
  final DateTime createdAt;
  final String title;
  final String url;
  final String imageUrl;
  final String platform; /// 플랫폼 이름 (Naver, YouTube 등등)
  final String category;
  final String? extraText; /// 공유 시 딸려온 텍스트 (e.g. 남산와이너리 어때요? 캐치테이블에서 확인해보세요!)
  final String? mainContent; /// 추출된 본문,자막 등 요약에 도움이될만한 컨텐츠
  final AIAnalysis aiAnalysis;

  DocumentModel({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.platform,
    required this.category,
    this.extraText,
    this.mainContent,
    required this.aiAnalysis,
  });
}