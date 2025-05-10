import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج بيانات تقدم الطالب في حفظ القرآن
class QuranProgressModel {
  String id;
  String studentId;
  String teacherId;
  String surahName;
  int surahNumber;
  int fromAyah;
  int toAyah;
  String type; // حفظ، مراجعة، تلاوة
  String evaluation; // ممتاز، جيد جداً، جيد، مقبول، ضعيف
  String? notes;
  DateTime date;
  bool isEvaluated;

  QuranProgressModel({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.surahName,
    required this.surahNumber,
    required this.fromAyah,
    required this.toAyah,
    required this.type,
    required this.evaluation,
    this.notes,
    required this.date,
    required this.isEvaluated,
  });

  // Create from Firestore document
  factory QuranProgressModel.fromMap(Map<String, dynamic> map, String id) {
    return QuranProgressModel(
      id: id,
      studentId: map['studentId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      surahName: map['surahName'] ?? '',
      surahNumber: map['surahNumber'] ?? 0,
      fromAyah: map['fromAyah'] ?? 0,
      toAyah: map['toAyah'] ?? 0,
      type: map['type'] ?? '',
      evaluation: map['evaluation'] ?? '',
      notes: map['notes'],
      date: (map['date'] as Timestamp).toDate(),
      isEvaluated: map['isEvaluated'] ?? false,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'teacherId': teacherId,
      'surahName': surahName,
      'surahNumber': surahNumber,
      'fromAyah': fromAyah,
      'toAyah': toAyah,
      'type': type,
      'evaluation': evaluation,
      'notes': notes,
      'date': Timestamp.fromDate(date),
      'isEvaluated': isEvaluated,
    };
  }

  // Create a copy with updated fields
  QuranProgressModel copyWith({
    String? id,
    String? studentId,
    String? teacherId,
    String? surahName,
    int? surahNumber,
    int? fromAyah,
    int? toAyah,
    String? type,
    String? evaluation,
    String? notes,
    DateTime? date,
    bool? isEvaluated,
  }) {
    return QuranProgressModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      teacherId: teacherId ?? this.teacherId,
      surahName: surahName ?? this.surahName,
      surahNumber: surahNumber ?? this.surahNumber,
      fromAyah: fromAyah ?? this.fromAyah,
      toAyah: toAyah ?? this.toAyah,
      type: type ?? this.type,
      evaluation: evaluation ?? this.evaluation,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      isEvaluated: isEvaluated ?? this.isEvaluated,
    );
  }
}