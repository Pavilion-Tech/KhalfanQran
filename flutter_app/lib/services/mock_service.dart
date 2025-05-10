// هذا الملف يحتوي على خدمات وهمية مؤقتة للتطوير المحلي
// بدون الحاجة إلى اتصال Firebase

import 'package:khalfan_center/models/user_model.dart';
import 'package:khalfan_center/models/student_model.dart';
import 'package:khalfan_center/models/attendance_model.dart';
import 'package:khalfan_center/models/document_model.dart';
import 'package:khalfan_center/models/quran_progress_model.dart';
import 'package:khalfan_center/models/request_model.dart';

// فئات وهمية لمحاكاة Firebase
class MockFirestore {
  MockCollectionReference collection(String name) {
    return MockCollectionReference(name);
  }
}

class MockAuth {
  MockUser? currentUser;
}

class MockUser {
  final String uid;
  final String email;
  
  MockUser(this.uid, this.email);
}

class MockCollectionReference {
  final String name;
  
  MockCollectionReference(this.name);
  
  MockDocumentReference doc(String id) {
    return MockDocumentReference('$name/$id');
  }
  
  Future<void> add(Map<String, dynamic> data) async {
    // تخزين البيانات في نسخة محلية وهمية
    print('Added document to $name: $data');
  }
  
  MockQuery where(String field, {dynamic isEqualTo, dynamic isGreaterThanOrEqualTo, dynamic isLessThanOrEqualTo}) {
    return MockQuery('$name where $field');
  }
  
  Future<MockQuerySnapshot> get() async {
    return MockQuerySnapshot([]);
  }
}

class MockDocumentReference {
  final String path;
  
  MockDocumentReference(this.path);
  
  Future<MockDocumentSnapshot> get() async {
    return MockDocumentSnapshot({}, path.split('/').last);
  }
  
  Future<void> set(Map<String, dynamic> data) async {
    // تخزين البيانات في نسخة محلية وهمية
    print('Set document at $path: $data');
  }
  
  Future<void> delete() async {
    print('Deleted document at $path');
  }
}

class MockQuery {
  final String description;
  
  MockQuery(this.description);
  
  MockQuery where(String field, {dynamic isEqualTo, dynamic isGreaterThanOrEqualTo, dynamic isLessThanOrEqualTo}) {
    return MockQuery('$description and $field');
  }
  
  Future<MockQuerySnapshot> get() async {
    return MockQuerySnapshot([]);
  }
}

class MockQuerySnapshot {
  final List<MockDocumentSnapshot> docs;
  
  MockQuerySnapshot(this.docs);
  
  int get size => docs.length;
}

class MockDocumentSnapshot {
  final Map<String, dynamic> _data;
  final String id;
  
  MockDocumentSnapshot(this._data, this.id);
  
  bool get exists => _data.isNotEmpty;
  
  Map<String, dynamic>? data() => _data;
}

// مزود البيانات الوهمية
class MockDataProvider {
  // المستخدمين النموذجيين
  static List<UserModel> getSampleUsers() {
    final now = DateTime.now();
    return [
      UserModel(
        id: 'admin1',
        name: 'مدير النظام',
        email: 'admin@example.com',
        phone: '050-1234567',
        role: UserRole.admin,
        createdAt: now.subtract(const Duration(days: 180)),
        lastLogin: now.subtract(const Duration(hours: 2)),
      ),
      UserModel(
        id: 'teacher1',
        name: 'عبدالله محمد',
        email: 'abdullah@example.com',
        phone: '052-1234567',
        role: UserRole.teacher,
        createdAt: now.subtract(const Duration(days: 120)),
        lastLogin: now.subtract(const Duration(hours: 5)),
      ),
      UserModel(
        id: 'teacher2',
        name: 'نورة أحمد',
        email: 'noura@example.com',
        phone: '050-7654321',
        role: UserRole.teacher,
        createdAt: now.subtract(const Duration(days: 90)),
        lastLogin: now.subtract(const Duration(hours: 2)),
      ),
      UserModel(
        id: 'parent1',
        name: 'محمد علي',
        email: 'mohammed@example.com',
        phone: '056-1234567',
        role: UserRole.parent,
        createdAt: now.subtract(const Duration(days: 60)),
        lastLogin: now.subtract(const Duration(days: 1)),
        studentIds: ['student1', 'student2'],
      ),
    ];
  }

  // الطلاب النموذجيين
  static List<StudentModel> getSampleStudents() {
    return [
      StudentModel(
        id: 'student1',
        name: 'أحمد محمد',
        dateOfBirth: DateTime(2010, 5, 15),
        gender: StudentGender.male,
        parentId: 'parent1',
        grade: 'الصف الخامس',
        level: 2,
        memorizedSurahs: ['1', '112', '113', '114'],
        joinDate: DateTime(2022, 9, 1),
      ),
      StudentModel(
        id: 'student2',
        name: 'فاطمة علي',
        dateOfBirth: DateTime(2011, 7, 22),
        gender: StudentGender.female,
        parentId: 'parent1',
        grade: 'الصف الرابع',
        level: 1,
        memorizedSurahs: ['1', '112'],
        joinDate: DateTime(2023, 1, 15),
      ),
      StudentModel(
        id: 'student3',
        name: 'محمد خالد',
        dateOfBirth: DateTime(2009, 3, 10),
        gender: StudentGender.male,
        parentId: 'parent2',
        grade: 'الصف السادس',
        level: 3,
        memorizedSurahs: ['1', '112', '113', '114', '2'],
        joinDate: DateTime(2021, 10, 5),
      ),
    ];
  }

  // سجلات الحضور النموذجية
  static List<AttendanceModel> getSampleAttendance() {
    final now = DateTime.now();
    return [
      AttendanceModel(
        studentId: 'student1',
        date: now.subtract(const Duration(days: 1)),
        status: AttendanceStatus.present,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      AttendanceModel(
        studentId: 'student1',
        date: now.subtract(const Duration(days: 2)),
        status: AttendanceStatus.absent,
        notes: 'مريض',
        createdAt: now.subtract(const Duration(days: 2, hours: 2)),
      ),
      AttendanceModel(
        studentId: 'student2',
        date: now.subtract(const Duration(days: 1)),
        status: AttendanceStatus.present,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
    ];
  }
  
  // الإعلانات النموذجية
  static List<Map<String, dynamic>> getSampleAnnouncements() {
    final now = DateTime.now();
    return [
      {
        'id': 'announcement1',
        'title': 'تغيير موعد الاختبار الشهري',
        'content': 'نود إعلامكم بتغيير موعد الاختبار الشهري ليكون يوم الثلاثاء القادم بدلاً من يوم الأربعاء. يرجى الاستعداد والحضور في الموعد الجديد.',
        'date': now.subtract(const Duration(days: 2)),
        'priority': 'مهم',
        'isActive': true,
        'targetAudience': 'أولياء الأمور',
      },
      {
        'id': 'announcement2',
        'title': 'اجتماع أولياء الأمور',
        'content': 'سيتم عقد اجتماع أولياء الأمور يوم الخميس القادم الساعة 7 مساءً لمناقشة مستوى الطلاب والإجابة على استفساراتكم.',
        'date': now.subtract(const Duration(days: 5)),
        'priority': 'عادي',
        'isActive': true,
        'targetAudience': 'أولياء الأمور',
      },
      {
        'id': 'announcement3',
        'title': 'مسابقة حفظ القرآن السنوية',
        'content': 'يسرنا الإعلان عن بدء التسجيل في مسابقة حفظ القرآن السنوية. آخر موعد للتسجيل هو 15 يونيو. للتسجيل يرجى التواصل مع إدارة المركز.',
        'date': now.subtract(const Duration(days: 1)),
        'priority': 'مهم',
        'isActive': true,
        'targetAudience': 'أولياء الأمور',
      },
      {
        'id': 'announcement4',
        'title': 'تحديث مناهج التحفيظ',
        'content': 'تم تحديث مناهج التحفيظ للفصل الدراسي القادم. يمكنكم الاطلاع على التغييرات من خلال الحساب الشخصي.',
        'date': now.subtract(const Duration(days: 10)),
        'priority': 'متوسط',
        'isActive': true,
        'targetAudience': 'أولياء الأمور',
      },
    ];
  }
}