import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NewsModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final List<String> imageUrls;
  final String authorId;
  final String authorName;
  final DateTime date;
  final List<String> tags;
  final bool isPublished;
  final bool isFeatured;
  final int viewCount;
  final String category; // news, announcement, event
  final bool isExternal;
  final String? externalUrl;

  const NewsModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    this.imageUrls = const [],
    required this.authorId,
    required this.authorName,
    required this.date,
    this.tags = const [],
    this.isPublished = true,
    this.isFeatured = false,
    this.viewCount = 0,
    required this.category,
    this.isExternal = false,
    this.externalUrl,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map, String id) {
    return NewsModel(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      content: map['content'] ?? '',
      imageUrls: map['imageUrls'] != null 
        ? List<String>.from(map['imageUrls']) 
        : [],
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      tags: map['tags'] != null 
        ? List<String>.from(map['tags']) 
        : [],
      isPublished: map['isPublished'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
      viewCount: map['viewCount'] ?? 0,
      category: map['category'] ?? 'news',
      isExternal: map['isExternal'] ?? false,
      externalUrl: map['externalUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'imageUrls': imageUrls,
      'authorId': authorId,
      'authorName': authorName,
      'date': Timestamp.fromDate(date),
      'tags': tags,
      'isPublished': isPublished,
      'isFeatured': isFeatured,
      'viewCount': viewCount,
      'category': category,
      'isExternal': isExternal,
      'externalUrl': externalUrl,
    };
  }

  NewsModel copyWith({
    String? title,
    String? subtitle,
    String? content,
    List<String>? imageUrls,
    String? authorId,
    String? authorName,
    DateTime? date,
    List<String>? tags,
    bool? isPublished,
    bool? isFeatured,
    int? viewCount,
    String? category,
    bool? isExternal,
    String? externalUrl,
  }) {
    return NewsModel(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      isPublished: isPublished ?? this.isPublished,
      isFeatured: isFeatured ?? this.isFeatured,
      viewCount: viewCount ?? this.viewCount,
      category: category ?? this.category,
      isExternal: isExternal ?? this.isExternal,
      externalUrl: externalUrl ?? this.externalUrl,
    );
  }
  
  String getCategoryName() {
    switch (category) {
      case 'news':
        return 'خبر';
      case 'announcement':
        return 'إعلان';
      case 'event':
        return 'فعالية';
      default:
        return 'خبر';
    }
  }
  
  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  String getFormattedDate() {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    content,
    imageUrls,
    authorId,
    authorName,
    date,
    tags,
    isPublished,
    isFeatured,
    viewCount,
    category,
    isExternal,
    externalUrl,
  ];
}
