import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, teacher, parent, student }

// Convert enum to string for storing in Firestore
String userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'admin';
    case UserRole.teacher:
      return 'teacher';
    case UserRole.parent:
      return 'parent';
    case UserRole.student:
      return 'student';
    default:
      return 'parent';
  }
}

// Convert string back to enum when retrieving from Firestore
UserRole stringToUserRole(String roleStr) {
  switch (roleStr) {
    case 'admin':
      return UserRole.admin;
    case 'teacher':
      return UserRole.teacher;
    case 'parent':
      return UserRole.parent;
    case 'student':
      return UserRole.student;
    default:
      return UserRole.parent;
  }
}

class UserModel {
  String id;
  String name;
  String email;
  String phone;
  UserRole role;
  String? profileImageUrl;
  DateTime createdAt;
  DateTime lastLogin;
  List<String>? studentIds; // IDs of students associated with parent
  String? teacherId; // ID of teacher assigned to student

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
    required this.lastLogin,
    this.studentIds,
    this.teacherId,
  });

  // Create a user from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: stringToUserRole(map['role'] ?? 'parent'),
      profileImageUrl: map['profileImageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLogin: (map['lastLogin'] as Timestamp).toDate(),
      studentIds: map['studentIds'] != null 
          ? List<String>.from(map['studentIds'])
          : null,
      teacherId: map['teacherId'],
    );
  }

  // Convert the user to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': userRoleToString(role),
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'studentIds': studentIds,
      'teacherId': teacherId,
    };
  }

  // Create a new user
  factory UserModel.create({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: '',  // Will be set after Firebase Auth registration
      name: name,
      email: email,
      phone: phone,
      role: role,
      profileImageUrl: null,
      createdAt: now,
      lastLogin: now,
      studentIds: role == UserRole.parent ? [] : null,
      teacherId: role == UserRole.student ? null : null,
    );
  }

  // Create a copy of the user with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    List<String>? studentIds,
    String? teacherId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      studentIds: studentIds ?? this.studentIds,
      teacherId: teacherId ?? this.teacherId,
    );
  }
}