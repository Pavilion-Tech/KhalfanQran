import 'package:cloud_firestore/cloud_firestore.dart';

enum StudentGender { male, female }

// Convert enum to string for storing in Firestore
String genderToString(StudentGender gender) {
  return gender == StudentGender.male ? 'male' : 'female';
}

// Convert string back to enum when retrieving from Firestore
StudentGender stringToGender(String genderStr) {
  return genderStr == 'male' ? StudentGender.male : StudentGender.female;
}

class StudentModel {
  String id;
  String name;
  DateTime dateOfBirth;
  StudentGender gender;
  String parentId; // Reference to parent's user ID
  String? teacherId; // Reference to teacher's user ID
  String? profileImageUrl;
  String grade;
  int level; // Quran memorization level
  List<String> memorizedSurahs; // List of Surah IDs that have been memorized
  DateTime joinDate;
  String? notes;

  StudentModel({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.parentId,
    this.teacherId,
    this.profileImageUrl,
    required this.grade,
    required this.level,
    required this.memorizedSurahs,
    required this.joinDate,
    this.notes,
  });

  // Create a student from a Firestore document
  factory StudentModel.fromMap(Map<String, dynamic> map, String id) {
    return StudentModel(
      id: id,
      name: map['name'] ?? '',
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      gender: stringToGender(map['gender'] ?? 'male'),
      parentId: map['parentId'] ?? '',
      teacherId: map['teacherId'],
      profileImageUrl: map['profileImageUrl'],
      grade: map['grade'] ?? '',
      level: map['level'] ?? 1,
      memorizedSurahs: List<String>.from(map['memorizedSurahs'] ?? []),
      joinDate: (map['joinDate'] as Timestamp).toDate(),
      notes: map['notes'],
    );
  }

  // Convert the student to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gender': genderToString(gender),
      'parentId': parentId,
      'teacherId': teacherId,
      'profileImageUrl': profileImageUrl,
      'grade': grade,
      'level': level,
      'memorizedSurahs': memorizedSurahs,
      'joinDate': Timestamp.fromDate(joinDate),
      'notes': notes,
    };
  }

  // Create a new student
  factory StudentModel.create({
    required String name,
    required DateTime dateOfBirth,
    required StudentGender gender,
    required String parentId,
    String? teacherId,
    required String grade,
  }) {
    return StudentModel(
      id: '',  // Will be set when added to Firestore
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      parentId: parentId,
      teacherId: teacherId,
      profileImageUrl: null,
      grade: grade,
      level: 1,  // Starting level
      memorizedSurahs: [],
      joinDate: DateTime.now(),
      notes: null,
    );
  }

  // Create a copy of the student with updated fields
  StudentModel copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    StudentGender? gender,
    String? parentId,
    String? teacherId,
    String? profileImageUrl,
    String? grade,
    int? level,
    List<String>? memorizedSurahs,
    DateTime? joinDate,
    String? notes,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      parentId: parentId ?? this.parentId,
      teacherId: teacherId ?? this.teacherId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      grade: grade ?? this.grade,
      level: level ?? this.level,
      memorizedSurahs: memorizedSurahs ?? this.memorizedSurahs,
      joinDate: joinDate ?? this.joinDate,
      notes: notes ?? this.notes,
    );
  }
}