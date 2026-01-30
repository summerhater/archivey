import 'package:archivey/domain/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AiTaskStatus { pending, analyzing, completed, failed }
enum SyncStatus { synced, pending }

/// 앱 내에서 사용하는 Document Model
///
/// 변수 수정 시, 아래의 method 업데이트 필요
///
/// document_model의 copyWith, toMap, fromMap
///
/// document_mapper의 toDocumentCompanion, toDomain, toDocumentCompanion
///
/// tables.drift의 CREATE TABLE Documents(필요 시 FTS, TRIGGER, JOIN TABLE 포함)
///
/// app_database의 migration, pullSyncUpdate
class DocumentModel {
  final String uid; ///사용자 id
  final String id;///도큐먼트 고유 id
  final DateTime createdAt;///생성일
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final CategoryModel category; ///사용자 지정 카테고리 모델
  final String userMemo;///사용자 작성 메모
  final String title;///도큐먼트 제목
  final String url;///원문 링크
  final String imageUrl;///이미지 링크 (이미지 없을 시 기본 이미지 대입)
  final String platform;///플랫폼 이름
  final String aiSummary;///AI 요약 텍스트
  final List<String> tags;///AI 생성 태그 리스트
  final AiTaskStatus aiStatus;///AI 상태
  final bool isBookmark;///북마크 상태

  DocumentModel({
    required this.uid,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.category,
    this.userMemo = '',
    this.title = '',
    required this.url,
    this.imageUrl = '',
    this.platform = '',
    this.aiSummary = '',
    this.tags = const [],
    this.aiStatus = AiTaskStatus.pending,
    required this.isBookmark,
  });

  DocumentModel copyWith({
    String? uid,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    CategoryModel? category,
    String? userMemo,
    String? title,
    String? url,
    String? imageUrl,
    String? platform,
    String? aiSummary,
    List<String>? tags,
    AiTaskStatus? aiStatus,
    bool? isBookmark,
  }) {
    return DocumentModel(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      category: category ?? this.category,
      userMemo: userMemo ?? this.userMemo,
      title: title ?? this.title,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      platform: platform ?? this.platform,
      aiSummary: aiSummary ?? this.aiSummary,
      tags: tags ?? this.tags,
      aiStatus: aiStatus ?? this.aiStatus,
      isBookmark: isBookmark ?? this.isBookmark,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'id': id,
      'createdAt': createdAt,
      'updatedAt': DateTime.now(), // Sync를 위해, 서버에 업로드 하는 시점으로 설정
      'deletedAt': deletedAt,
      'category': category.toMap(),
      'userMemo': userMemo,
      'title': title,
      'url': url,
      'imageUrl': imageUrl,
      'platform': platform,
      'aiSummary': aiSummary,
      'tags': tags,
      'aiStatus': aiStatus.name,
      'isBookmark': isBookmark,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      uid: map['uid'],
      id: map['id'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      deletedAt: (map['deletedAt'] != null) ? (map['deletedAt'] as Timestamp).toDate() : null,
      category: CategoryModel.fromMap(map['category']),
      userMemo: map['userMemo'],
      title: map['title'],
      url: map['url'],
      imageUrl: map['imageUrl'],
      platform: map['platform'],
      aiSummary: map['aiSummary'],
      tags: List<String>.from(map['tags']),
      aiStatus: AiTaskStatus.values.byName(map['aiStatus'] ?? 'pending'),
      isBookmark: map['isBookmark'] ?? false,
    );
  }
}