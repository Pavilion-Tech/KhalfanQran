// Implementación temporal de FirebaseService que usa datos mock
// para poder desarrollar la interfaz de usuario sin depender de Firebase
import 'package:khalfan_center/services/mock_service.dart';
import '../models/student_model.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../models/document_model.dart';
import '../models/request_model.dart';
import '../models/quran_progress_model.dart';

// Clase auxiliar para simular un documento de Firestore
class MockDocument {
  final Map<String, dynamic> data;
  final String id;
  
  MockDocument(this.data, this.id);
}

class FirebaseService {
  // Mock data
  List<UserModel> _users = [];
  List<StudentModel> _students = [];
  List<AttendanceModel> _attendance = [];
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _announcements = [];
  
  // Constructor que carga datos de muestra
  FirebaseService() {
    _users = MockDataProvider.getSampleUsers();
    _students = MockDataProvider.getSampleStudents();
    _attendance = MockDataProvider.getSampleAttendance();
    _announcements = MockDataProvider.getSampleAnnouncements();
    
    // Mock classes data
    _classes = [
      {
        'id': 'class1',
        'name': 'حلقة حفظ القرآن للمبتدئين',
        'teacherId': 'teacher1',
        'teacherName': 'عبدالله محمد',
        'days': ['السبت', 'الاثنين', 'الأربعاء'],
        'time': '4:00 - 5:30 مساءً',
        'location': 'قاعة A1',
        'maxStudents': 15,
        'currentStudents': 10,
        'level': 'مبتدئ',
        'status': 'نشط',
      },
      {
        'id': 'class2',
        'name': 'حلقة تحفيظ للأطفال',
        'teacherId': 'teacher2',
        'teacherName': 'نورة أحمد',
        'days': ['الأحد', 'الثلاثاء', 'الخميس'],
        'time': '5:00 - 6:30 مساءً',
        'location': 'قاعة B2',
        'maxStudents': 12,
        'currentStudents': 8,
        'level': 'مبتدئ',
        'status': 'نشط',
      },
    ];
    
    // Mock announcements data
    _announcements = [
      {
        'id': 'announcement1',
        'title': 'تغيير موعد الاختبار الشهري',
        'content': 'نود إعلامكم بتغيير موعد الاختبار الشهري ليكون يوم الثلاثاء القادم بدلاً من يوم الأربعاء. يرجى الاستعداد والحضور في الموعد الجديد.',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'priority': 'مهم',
        'isActive': true,
        'targetAudience': 'الطلاب',
      },
      {
        'id': 'announcement2',
        'title': 'اجتماع أولياء الأمور',
        'content': 'سيتم عقد اجتماع أولياء الأمور يوم الخميس القادم الساعة 7 مساءً لمناقشة مستوى الطلاب والإجابة على استفساراتكم.',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'priority': 'عادي',
        'isActive': true,
        'targetAudience': 'أولياء الأمور',
      },
    ];
  }

  // Simulate Firestore and Auth instance with mock classes
  final dynamic _firestore = MockFirestore();
  final dynamic _auth = MockAuth();
  
  // Get current authenticated user
  dynamic get currentUser => null;

  // ---------------- USER MANAGEMENT ----------------

  // Get user data from mock data
  Future<UserModel?> getUserData(String uid) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Find user by ID
      final user = _users.firstWhere(
        (user) => user.id == uid,
        orElse: () => throw Exception('User not found'),
      );
      
      return user;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Add or update user data 
  Future<void> setUserData(UserModel user) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index >= 0) {
        _users[index] = user;
      } else {
        _users.add(user);
      }
    } catch (e) {
      print('Error setting user data: $e');
      throw e;
    }
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _users.removeWhere((user) => user.id == uid);
    } catch (e) {
      print('Error deleting user: $e');
      throw e;
    }
  }
  
  // Get user by ID - مطلوب للكود الحالي
  Future<UserModel?> getUserById(String uid) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final user = _users.firstWhere(
        (user) => user.id == uid,
        orElse: () => throw Exception('User not found'),
      );
      
      return user;
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }
  
  // تحديث بيانات المستخدم - مطلوب للكود الحالي
  Future<void> updateUser(UserModel user) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index >= 0) {
        _users[index] = user;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }

  // Get all users of a specific role
  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _users.where((user) => user.role == role).toList();
    } catch (e) {
      print('Error getting users by role: $e');
      return [];
    }
  }

  // Get teachers count
  Future<int> getTeachersCount() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _users.where((user) => user.role == UserRole.teacher).length;
    } catch (e) {
      print('Error getting teachers count: $e');
      return 0;
    }
  }

  // ---------------- STUDENT MANAGEMENT ----------------

  // Get students for a specific parent
  Future<List<StudentModel>> getStudentsForParent(String parentId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _students.where((student) => student.parentId == parentId).toList();
    } catch (e) {
      print('Error getting students for parent: $e');
      return [];
    }
  }
  
  // Alias method to maintain compatibility with StudentBloc
  Future<List<StudentModel>> getStudentsByParentId(String parentId) async {
    return getStudentsForParent(parentId);
  }

  // Get students for a specific teacher
  Future<List<StudentModel>> getStudentsForTeacher(String teacherId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _students.where((student) => student.teacherId == teacherId).toList();
    } catch (e) {
      print('Error getting students for teacher: $e');
      return [];
    }
  }
  
  // Alias method to maintain compatibility with StudentBloc
  Future<List<StudentModel>> getStudentsByTeacherId(String teacherId) async {
    return getStudentsForTeacher(teacherId);
  }
  
  // Get student by ID
  Future<StudentModel?> getStudentById(String studentId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _students.firstWhere(
        (student) => student.id == studentId,
        orElse: () => throw Exception('Student not found'),
      );
    } catch (e) {
      print('Error getting student by ID: $e');
      return null;
    }
  }

  // Get all students
  Future<List<StudentModel>> getAllStudents() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return List.from(_students);
    } catch (e) {
      print('Error getting all students: $e');
      return [];
    }
  }

  // Get students count
  Future<int> getStudentsCount() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _students.length;
    } catch (e) {
      print('Error getting students count: $e');
      return 0;
    }
  }

  // Add or update student data
  Future<void> setStudentData(StudentModel student) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _students.indexWhere((s) => s.id == student.id);
      if (index >= 0) {
        _students[index] = student;
      } else {
        _students.add(student);
      }
    } catch (e) {
      print('Error setting student data: $e');
      throw e;
    }
  }

  // Delete student
  Future<void> deleteStudent(String studentId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _students.removeWhere((student) => student.id == studentId);
    } catch (e) {
      print('Error deleting student: $e');
      throw e;
    }
  }

  // ---------------- ATTENDANCE MANAGEMENT ----------------

  // Mark attendance for a student
  Future<void> markAttendance(AttendanceModel attendance) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Find if attendance for this student and date already exists
      final index = _attendance.indexWhere(
        (a) => a.studentId == attendance.studentId && 
               a.date.year == attendance.date.year &&
               a.date.month == attendance.date.month &&
               a.date.day == attendance.date.day
      );
      
      if (index >= 0) {
        _attendance[index] = attendance;
      } else {
        _attendance.add(attendance);
      }
    } catch (e) {
      print('Error marking attendance: $e');
      throw e;
    }
  }

  // Get attendance records for a student in a month
  Future<List<AttendanceModel>> getStudentAttendance(String studentId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (startDate != null && endDate != null) {
        return _attendance.where((a) => 
          a.studentId == studentId && 
          a.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          a.date.isBefore(endDate.add(const Duration(days: 1)))
        ).toList();
      } else if (startDate != null) {
        return _attendance.where((a) => 
          a.studentId == studentId && 
          a.date.isAfter(startDate.subtract(const Duration(days: 1)))
        ).toList();
      } else {
        return _attendance.where((a) => a.studentId == studentId).toList();
      }
    } catch (e) {
      print('Error getting attendance records: $e');
      return [];
    }
  }
  
  // Get student progress records
  Future<List<QuranProgressModel>> getStudentProgress(String studentId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In a real implementation, we would query Firestore for the student's progress
      // For now, return an empty list
      return [];
    } catch (e) {
      print('Error getting student progress: $e');
      return [];
    }
  }
  
  // Add a new progress record
  Future<void> addProgress(QuranProgressModel progress) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In a real implementation, we would save this to Firestore
      print('Added progress record for student ${progress.studentId}');
    } catch (e) {
      print('Error adding progress: $e');
      throw e;
    }
  }
  
  // Get student documents
  Future<List<DocumentModel>> getStudentDocuments(String studentId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In a real implementation, we would query Firestore for the student's documents
      // For now, return an empty list
      return [];
    } catch (e) {
      print('Error getting student documents: $e');
      return [];
    }
  }
  
  // Get student requests
  Future<List<RequestModel>> getRequestsByStudentId(String studentId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In a real implementation, we would query Firestore for the student's requests
      // For now, return an empty list
      return [];
    } catch (e) {
      print('Error getting student requests: $e');
      return [];
    }
  }
  
  // Add a new request
  Future<void> addRequest(RequestModel request) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In a real implementation, we would save this to Firestore
      print('Added request for student ${request.studentId}');
    } catch (e) {
      print('Error adding request: $e');
      throw e;
    }
  }

  // Get attendance statistics for a class
  Future<Map<String, dynamic>> getClassAttendanceStats(String classId, DateTime date) async {
    // Mock statistics
    return {
      'totalStudents': 10,
      'presentStudents': 8,
      'absentStudents': 1,
      'excusedStudents': 1,
      'lateStudents': 0,
      'attendanceRate': 0.8,
    };
  }

  // ---------------- CLASS MANAGEMENT ----------------

  // Add or update class
  Future<void> setClass(Map<String, dynamic> classData, String? classId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (classId != null) {
        final index = _classes.indexWhere((c) => c['id'] == classId);
        if (index >= 0) {
          _classes[index] = {...classData, 'id': classId};
        } else {
          _classes.add({...classData, 'id': classId});
        }
      } else {
        // Generate a new ID
        final newId = 'class_${DateTime.now().millisecondsSinceEpoch}';
        _classes.add({...classData, 'id': newId});
      }
    } catch (e) {
      print('Error setting class data: $e');
      throw e;
    }
  }

  // Get a specific class
  Future<Map<String, dynamic>?> getClass(String classId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final classData = _classes.firstWhere(
        (c) => c['id'] == classId,
        orElse: () => throw Exception('Class not found'),
      );
      
      return Map<String, dynamic>.from(classData);
    } catch (e) {
      print('Error getting class data: $e');
      return null;
    }
  }

  // Get all classes
  Future<List<Map<String, dynamic>>> getAllClasses() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return List<Map<String, dynamic>>.from(_classes);
    } catch (e) {
      print('Error getting all classes: $e');
      return [];
    }
  }

  // Get classes count
  Future<int> getClassesCount() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _classes.length;
    } catch (e) {
      print('Error getting classes count: $e');
      return 0;
    }
  }

  // Delete class
  Future<void> deleteClass(String classId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _classes.removeWhere((c) => c['id'] == classId);
    } catch (e) {
      print('Error deleting class: $e');
      throw e;
    }
  }

  // Get students in a class
  Future<List<StudentModel>> getStudentsInClass(String classId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In a real implementation, we would query students with matching classId
      // For the mock, we'll return some sample students
      return _students.take(3).toList();
    } catch (e) {
      print('Error getting students in class: $e');
      return [];
    }
  }

  // ---------------- ANNOUNCEMENT MANAGEMENT ----------------


  // Add or update announcement
  Future<void> setAnnouncement(Map<String, dynamic> announcementData, String? announcementId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (announcementId != null) {
        final index = _announcements.indexWhere((a) => a['id'] == announcementId);
        if (index >= 0) {
          _announcements[index] = {...announcementData, 'id': announcementId};
        } else {
          _announcements.add({...announcementData, 'id': announcementId});
        }
      } else {
        // Generate a new ID
        final newId = 'announcement_${DateTime.now().millisecondsSinceEpoch}';
        _announcements.add({...announcementData, 'id': newId});
      }
    } catch (e) {
      print('Error setting announcement data: $e');
      throw e;
    }
  }

  // Get all announcements
  Future<List<Map<String, dynamic>>> getAllAnnouncements() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return List<Map<String, dynamic>>.from(_announcements);
    } catch (e) {
      print('Error getting all announcements: $e');
      return [];
    }
  }
  
  // الحصول على آخر الأخبار - مطلوب للكود الحالي
  Future<List<Map<String, dynamic>>> getLatestNews() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return List<Map<String, dynamic>>.from(_announcements);
    } catch (e) {
      print('Error getting latest news: $e');
      return [];
    }
  }
  
  // الحصول على الفعاليات القادمة - مطلوب للكود الحالي
  Future<List<Map<String, dynamic>>> getUpcomingEvents() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // في التطبيق الحقيقي سنجلب بيانات الفعاليات من Firestore
      // للاختبار نعيد قائمة مؤقتة
      return [
        {
          'id': 'event1',
          'title': 'مسابقة حفظ القرآن الكريم',
          'description': 'مسابقة سنوية لحفظ القرآن الكريم للطلاب المتميزين',
          'date': DateTime.now().add(const Duration(days: 5)),
          'location': 'قاعة المركز الرئيسية',
          'startTime': '10:00 صباحاً',
          'endTime': '1:00 ظهراً',
          'organizer': 'إدارة المركز',
          'isRegistrationRequired': true,
          'registrationDeadline': DateTime.now().add(const Duration(days: 2)),
        },
        {
          'id': 'event2',
          'title': 'الاجتماع الشهري لأولياء الأمور',
          'description': 'مناقشة تقدم الطلاب والخطط المستقبلية',
          'date': DateTime.now().add(const Duration(days: 10)),
          'location': 'قاعة الاجتماعات بالطابق الثاني',
          'startTime': '7:00 مساءً',
          'endTime': '8:30 مساءً',
          'organizer': 'قسم شؤون أولياء الأمور',
          'isRegistrationRequired': false,
        },
      ];
    } catch (e) {
      print('Error getting upcoming events: $e');
      return [];
    }
  }

  // Get announcements count
  Future<int> getAnnouncementsCount() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _announcements.length;
    } catch (e) {
      print('Error getting announcements count: $e');
      return 0;
    }
  }
  
  // ---------------- NOTIFICATIONS MANAGEMENT ----------------
  
  // الحصول على إشعارات المستخدم - مطلوب للكود الحالي
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // للاختبار نعيد قائمة مؤقتة من الإشعارات
      return [
        {
          'id': 'notification1',
          'userId': userId,
          'title': 'تذكير بالاختبار الشهري',
          'body': 'الاختبار الشهري سيُعقد غداً في تمام الساعة 10 صباحاً',
          'date': DateTime.now().subtract(const Duration(hours: 2)),
          'isRead': false,
          'type': 'reminder',
        },
        {
          'id': 'notification2',
          'userId': userId,
          'title': 'تحديث في جدول الحصص',
          'body': 'تم تحديث جدول الحصص الأسبوعي، يرجى الاطلاع عليه',
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'isRead': true,
          'type': 'update',
        },
      ];
    } catch (e) {
      print('Error getting user notifications: $e');
      return [];
    }
  }
  
  // تحديث إشعار كمقروء - مطلوب للكود الحالي
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // في التطبيق الحقيقي سنقوم بتحديث حالة الإشعار في Firestore
      print('تم تحديث الإشعار $notificationId كمقروء');
    } catch (e) {
      print('Error marking notification as read: $e');
      throw e;
    }
  }

  // Get announcements for a specific audience
  Future<List<Map<String, dynamic>>> getAnnouncementsForAudience(String audience) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Filtrar anuncios por audiencia objetivo
      final filteredAnnouncements = _announcements.where((a) => 
        a['isActive'] == true && 
        (a['targetAudience'] == audience || a['targetAudience'] == 'الجميع')
      ).toList();
      
      // Ordenar por fecha (más reciente primero)
      filteredAnnouncements.sort((a, b) {
        final dateA = a['date'] as DateTime;
        final dateB = b['date'] as DateTime;
        return dateB.compareTo(dateA);
      });
      
      return filteredAnnouncements;
    } catch (e) {
      print('Error getting announcements for audience: $e');
      return [];
    }
  }

  // Delete announcement
  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _announcements.removeWhere((a) => a['id'] == announcementId);
    } catch (e) {
      print('Error deleting announcement: $e');
      throw e;
    }
  }
}