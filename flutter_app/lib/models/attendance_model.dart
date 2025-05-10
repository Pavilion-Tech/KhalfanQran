import 'package:cloud_firestore/cloud_firestore.dart';

enum AttendanceStatus { present, absent, excused, late }

// Convert enum to string for storing in Firestore
String attendanceStatusToString(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return 'present';
    case AttendanceStatus.absent:
      return 'absent';
    case AttendanceStatus.excused:
      return 'excused';
    case AttendanceStatus.late:
      return 'late';
    default:
      return 'absent';
  }
}

// Convert string back to enum when retrieving from Firestore
AttendanceStatus stringToAttendanceStatus(String statusStr) {
  switch (statusStr) {
    case 'present':
      return AttendanceStatus.present;
    case 'absent':
      return AttendanceStatus.absent;
    case 'excused':
      return AttendanceStatus.excused;
    case 'late':
      return AttendanceStatus.late;
    default:
      return AttendanceStatus.absent;
  }
}

class AttendanceModel {
  String studentId;
  DateTime date;
  AttendanceStatus status;
  String? notes;
  String? markedBy; // ID of user who marked the attendance (teacher/admin)
  DateTime createdAt;
  DateTime? updatedAt;

  AttendanceModel({
    required this.studentId,
    required this.date,
    required this.status,
    this.notes,
    this.markedBy,
    required this.createdAt,
    this.updatedAt,
  });

  // Create an attendance record from a Firestore document
  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      studentId: map['studentId'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      status: stringToAttendanceStatus(map['status'] ?? 'absent'),
      notes: map['notes'],
      markedBy: map['markedBy'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert the attendance record to a map for Firestore
  Map<String, dynamic> toMap() {
    final map = {
      'studentId': studentId,
      'date': Timestamp.fromDate(date),
      'status': attendanceStatusToString(status),
      'notes': notes,
      'markedBy': markedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
    
    if (updatedAt != null) {
      map['updatedAt'] = Timestamp.fromDate(updatedAt!);
    }
    
    return map;
  }

  // Create a new attendance record
  factory AttendanceModel.create({
    required String studentId,
    required DateTime date,
    required AttendanceStatus status,
    String? notes,
    String? markedBy,
  }) {
    final now = DateTime.now();
    return AttendanceModel(
      studentId: studentId,
      date: date,
      status: status,
      notes: notes,
      markedBy: markedBy,
      createdAt: now,
      updatedAt: null,
    );
  }

  // Create a copy of the attendance record with updated fields
  AttendanceModel copyWith({
    String? studentId,
    DateTime? date,
    AttendanceStatus? status,
    String? notes,
    String? markedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceModel(
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      markedBy: markedBy ?? this.markedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update when changing
    );
  }
}