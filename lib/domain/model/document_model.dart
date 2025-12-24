class DocumentModel {
  final String date;
  final String title;
  final String url;
  final String imageUrl;
  final List<String> tags;
  final String sourceType;
  final String sourceName;

  DocumentModel({
    required this.date,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.tags,
    required this.sourceType,
    required this.sourceName,
  });
}

// 더미 데이터
class DocumentDummyData {
  static List<DocumentModel> getDummyDocuments() {
    return [
      DocumentModel(
        date: '2025.12.13',
        title: '안성재 단골 맛집 (60년 + 15개 블루리본) 안국역 백반집 핫한 맛집 안성재 단골 맛집 (60년 + 15개 블루리본)',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['해장국', '맛집', '삼겹살', '안성재'],
        sourceType: '맛집',
        sourceName: 'Instagram',
      ),
      DocumentModel(
        date: '2025.12.12',
        title: '서울 핫플레이스 TOP 10 정리',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['서울', '여행', '핫플'],
        sourceType: '링크',
        sourceName: 'Naver',
      ),
      DocumentModel(
        date: '2025.12.11',
        title: '집에서 만드는 간단한 파스타 레시피',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['요리', '레시피', '파스타', '간단'],
        sourceType: '레시피',
        sourceName: 'YouTube',
      ),
      DocumentModel(
        date: '2025.12.10',
        title: 'Flutter 개발자 되기 로드맵',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['개발', 'Flutter', '취업'],
        sourceType: '링크',
        sourceName: 'Medium',
      ),
      DocumentModel(
        date: '2025.12.09',
        title: '제주도 3박 4일 여행 코스 추천',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['제주도', '여행', '국내여행'],
        sourceType: '여행',
        sourceName: '네이버 Blog',
      ),
    ];
  }
}