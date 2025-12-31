class Document {
  final String? documentId;
  final int? driftId;
  final DateTime createAt; // Local DB와 Remote DB의 Sync key?
  final String title;
  final String linkUrl;
  final String imgUrl;
  final List<String>? tags;
  final String category;
  final String platform; // String으로 할지 enum으로 할지
  final String? memo;
  final String? summary; // ai 요약

  Document({
    this.documentId,
    this.driftId,
    required this.createAt,
    required this.title,
    required this.linkUrl,
    required this.imgUrl,
    this.tags,
    required this.category,
    required this.platform,
    this.memo,
    this.summary,
  });

  factory Document.fromJson(Map<String, dynamic> data, String docId) {

    return Document(
      documentId: docId,
      createAt: data['createAt'].toDate(),
      title: data['title'],
      linkUrl: data['linkUrl'],
      imgUrl: data['imgUrl'],
      tags: data['tags'] ?? [],
      category: data['category'],
      platform: data['platform'],
      memo: data['memo'] ?? '',
      summary: data['summary'] ?? '',
    );
  }

  // Map<String, dynamic> toJson() { // 원래라면 remote db에 집어 넣는 역할. 하지만 local에 먼저 넣고 그걸 remote에 넣는데 이게 필요 할까?
  //   return {
  //     'createAt': createAt,
  //     'title': title,
  //     'linkUrl': linkUrl,
  //     'imgUrl': imgUrl,
  //     'tags': tags ?? [],
  //     'category': category,
  //     'platform': platform,
  //     'memo': memo ?? '',
  //     'summary': summary ?? '',
  //   };
  // }

}
