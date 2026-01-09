import 'package:archivey/domain/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AiTaskStatus { pending, analyzing, completed, failed }

class DocumentModel {
  final String uid; ///사용자 id
  final String id;///도큐먼트 고유 id
  final DateTime createdAt;///생성일
  final CategoryModel category; ///사용자 지정 카테고리 모델
  final String userMemo;///사용자 작성 메모
  final String title;///도큐먼트 제목
  final String url;///원문 링크
  final String imageUrl;///이미지 링크 (이미지 없을 시 기본 이미지 대입)
  final String platform;///플랫폼 이름
  final String aiSummary;///AI 요약 텍스트
  final List<String> tags;///AI 생성 태그 리스트
  final AiTaskStatus aiStatus;///AI 상태

  DocumentModel({
    required this.uid,
    required this.id,
    required this.createdAt,
    required this.category,
    this.userMemo = '',
    this.title = '',
    required this.url,
    this.imageUrl = '',
    this.platform = '',
    this.aiSummary = '',
    this.tags = const [],
    this.aiStatus = AiTaskStatus.pending,
  });

  DocumentModel copyWith({
    String? uid,
    String? id,
    DateTime? createdAt,
    CategoryModel? category,
    String? userMemo,
    String? title,
    String? url,
    String? imageUrl,
    String? platform,
    String? aiSummary,
    List<String>? tags,
    AiTaskStatus? aiStatus,
  }) {
    return DocumentModel(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      userMemo: userMemo ?? this.userMemo,
      title: title ?? this.title,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      platform: platform ?? this.platform,
      aiSummary: aiSummary ?? this.aiSummary,
      tags: tags ?? this.tags,
      aiStatus: aiStatus ?? this.aiStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt, // Firestore가 자동으로 Timestamp로 변환함
      'category': category.toMap(),
      'userMemo': userMemo,
      'title': title,
      'url': url,
      'imageUrl': imageUrl,
      'platform': platform,
      'aiSummary': aiSummary,
      'tags': tags,
      'aiStatus': aiStatus.name,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      uid: map['uid'],
      id: map['id'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      category: CategoryModel.fromMap(map['category']),
      userMemo: map['userMemo'],
      title: map['title'],
      url: map['url'],
      imageUrl: map['imageUrl'],
      platform: map['platform'],
      aiSummary: map['aiSummary'],
      tags: List<String>.from(map['tags']),
      aiStatus: AiTaskStatus.values.byName(map['aiStatus'] ?? 'pending'),
    );
  }
}
