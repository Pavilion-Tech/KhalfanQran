import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج بيانات المستندات الخاصة بالطالب
class DocumentModel {
  String id;
  String studentId;
  String name;
  String type; // شهادة ميلاد، جواز سفر، بطاقة هوية، شهادة دراسية، إلخ
  String url; // رابط المستند المخزن في Firebase Storage
  DateTime uploadDate;
  bool isVerified;
  String? notes;

  DocumentModel({
    required this.id,
    required this.studentId,
    required this.name,
    required this.type,
    required this.url,
    required this.uploadDate,
    required this.isVerified,
    this.notes,
  });

  // Create from Firestore document
  factory DocumentModel.fromMap(Map<String, dynamic> map, String id) {
    return DocumentModel(
      id: id,
      studentId: map['studentId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      url: map['url'] ?? '',
      uploadDate: (map['uploadDate'] as Timestamp).toDate(),
      isVerified: map['isVerified'] ?? false,
      notes: map['notes'],
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'type': type,
      'url': url,
      'uploadDate': Timestamp.fromDate(uploadDate),
      'isVerified': isVerified,
      'notes': notes,
    };
  }

  // Create a copy with updated fields
  DocumentModel copyWith({
    String? id,
    String? studentId,
    String? name,
    String? type,
    String? url,
    DateTime? uploadDate,
    bool? isVerified,
    String? notes,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      uploadDate: uploadDate ?? this.uploadDate,
      isVerified: isVerified ?? this.isVerified,
      notes: notes ?? this.notes,
    );
  }
}