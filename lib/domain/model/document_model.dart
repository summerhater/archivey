class DocumentModel {
  final String date;
  final String title;
  final String url;
  final String imageUrl;
  final List<String>? tags;
  final String category;
  final String platform;
  final String? memo;

  DocumentModel({
    required this.date,
    required this.title,
    required this.url,
    required this.imageUrl,
    this.tags,
    required this.category,
    required this.platform,
    this.memo,
  });
}

// 더미 데이터
class DocumentDummyData {
  static List<String> _cachedCategories = [];
  static List<DocumentModel> getDummyDocuments() {
    return [
      DocumentModel(
        date: '2025.12.13',
        title:
            '안성재 단골 맛집 (60년 + 15개 블루리본) 안국역 백반집 핫한 맛집 안성재 단골 맛집 (60년 + 15개 블루리본)',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['해장국', '맛집', '삼겹살', '안성재'],
        category: '맛집',
        platform: 'Instagram',
        memo: '새해에는 꼭 가보기',
      ),
      DocumentModel(
        date: '2025.12.12',
        title: '서울 핫플레이스 TOP 10 정리',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['서울', '여행', '핫플'],
        category: '링크',
        platform: 'Naver',
      ),
      DocumentModel(
        date: '2025.12.11',
        title: '집에서 만드는 간단한 파스타 레시피',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['요리', '레시피', '파스타', '간단'],
        category: '레시피',
        platform: 'YouTube',
      ),
      DocumentModel(
        date: '2025.12.10',
        title: 'Flutter 개발자 되기 로드맵',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['개발', 'Flutter', '취업'],
        category: '링크',
        platform: 'Medium',
      ),
      DocumentModel(
        date: '2025.12.09',
        title: '제주도 3박 4일 여행 코스 추천',
        url: '',
        imageUrl: 'https://via.placeholder.com/120x120',
        tags: ['제주도', '여행', '국내여행'],
        category: '여행',
        platform: '네이버 Blog',
      ),
    ];
  }

  // static List<String> getCategories() {
  //   final allDocs = getDummyDocuments();
  //   // 'ALL'을 처음에 넣고, 나머지는 데이터에서 추출하여 중복 제거
  //   final categories = allDocs.map((doc) => doc.category).toSet().toList();
  //   return ['ALL', ...categories];
  // }

  static List<String> getCategories() {
    if (_cachedCategories.isEmpty) {
      ///todo: 초기 데이터 로드, DB나 API에서 가져오게 처리해야함
      _cachedCategories = ['ALL', '맛집', '링크', '레시피', '여행', '스크랩'];
    }
    return _cachedCategories;
  }

  ///ALL을 제외한 실제 순서 바꿀 수 있는 관리용 카테고리만 반환
  static List<String> getManageableCategories() {
    final all = getCategories();
    return all.where((c) => c != 'ALL').toList();
  }

  ///카테고리 순서 변경 로직
  static void reorderCategories(int oldIndex, int newIndex) {
    /// getManageableCategories 기준의 idx를 실제 _cachedCategories idx로 치환
    ///ALL이 인덱스 0번에 고정이라 1을 더해줌.
    int oldIdx = oldIndex + 1;
    int newIdx = newIndex + 1;

    if (newIdx > oldIdx) newIdx -= 1;

    if (oldIdx < 0 || oldIdx >= _cachedCategories.length) return;
    if (newIdx < 0 || newIdx >= _cachedCategories.length) return;

    final String item = _cachedCategories.removeAt(oldIdx);
    _cachedCategories.insert(newIdx, item);
  }
}
