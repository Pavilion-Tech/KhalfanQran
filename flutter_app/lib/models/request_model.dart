import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج بيانات الطلبات المقدمة من الطلاب أو أولياء الأمور
class RequestModel {
  String id;
  String studentId;
  String parentId;
  String title;
  String description;
  String type; // إجازة، استفسار، شكوى، اقتراح، إلخ
  String status; // قيد المراجعة، موافق، مرفوض، مكتمل
  DateTime createdAt;
  DateTime? resolvedAt;
  String? adminId; // معرف المسؤول الذي عالج الطلب
  String? responseMessage;

  RequestModel({
    required this.id,
    required this.studentId,
    required this.parentId,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.adminId,
    this.responseMessage,
  });

  // Create from Firestore document
  factory RequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RequestModel(
      id: id,
      studentId: map['studentId'] ?? '',
      parentId: map['parentId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      status: map['status'] ?? 'قيد المراجعة',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      resolvedAt: map['resolvedAt'] != null 
          ? (map['resolvedAt'] as Timestamp).toDate() 
          : null,
      adminId: map['adminId'],
      responseMessage: map['responseMessage'],
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'parentId': parentId,
      'title': title,
      'description': description,
      'type': type,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'adminId': adminId,
      'responseMessage': responseMessage,
    };
  }

  // Create a copy with updated fields
  RequestModel copyWith({
    String? id,
    String? studentId,
    String? parentId,
    String? title,
    String? description,
    String? type,
    String? status,
    DateTime? createdAt,
    DateTime? resolvedAt,
    String? adminId,
    String? responseMessage,
  }) {
    return RequestModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      adminId: adminId ?? this.adminId,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }
}