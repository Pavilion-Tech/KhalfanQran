import 'package:flutter/material.dart';
import 'package:khalfan_center/screens/auth/forgot_password_screen.dart';
import 'package:khalfan_center/screens/auth/login_screen.dart';
import 'package:khalfan_center/screens/auth/register_screen.dart';
import 'package:khalfan_center/screens/home/calendar_screen.dart';
import 'package:khalfan_center/screens/home/home_screen.dart';
import 'package:khalfan_center/screens/home/news_screen.dart';
import 'package:khalfan_center/screens/parent/attendance_screen.dart';
import 'package:khalfan_center/screens/parent/certificates_screen.dart';
import 'package:khalfan_center/screens/parent/documents_screen.dart';
import 'package:khalfan_center/screens/parent/learning_plan_screen.dart';
import 'package:khalfan_center/screens/parent/notifications_screen.dart';
import 'package:khalfan_center/screens/parent/parent_dashboard.dart';
import 'package:khalfan_center/screens/parent/progress_screen.dart';
import 'package:khalfan_center/screens/parent/requests_screen.dart';
import 'package:khalfan_center/screens/parent/student_details_screen.dart';
import 'package:khalfan_center/screens/profile/edit_profile_screen.dart';
import 'package:khalfan_center/screens/profile/profile_screen.dart';
import 'package:khalfan_center/screens/splash_screen.dart';
import 'package:khalfan_center/screens/student/daily_plan_screen.dart';
import 'package:khalfan_center/screens/student/quran_progress_screen.dart';
import 'package:khalfan_center/screens/student/student_dashboard.dart';
import 'package:khalfan_center/screens/teacher/mark_attendance_screen.dart';
import 'package:khalfan_center/screens/teacher/student_progress_screen.dart';
import 'package:khalfan_center/screens/teacher/students_list_screen.dart';
import 'package:khalfan_center/screens/teacher/teacher_dashboard.dart';
import 'package:khalfan_center/screens/admin/admin_dashboard.dart';

// Define route names as constants
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String news = '/news';
  static const String calendar = '/calendar';
  
  // Parent routes
  static const String parentDashboard = '/parent/dashboard';
  static const String studentDetails = '/parent/student-details';
  static const String learningPlan = '/parent/learning-plan';
  static const String progress = '/parent/progress';
  static const String attendance = '/parent/attendance';
  static const String certificates = '/parent/certificates';
  static const String requests = '/parent/requests';
  static const String documents = '/parent/documents';
  static const String notifications = '/parent/notifications';
  
  // Teacher routes
  static const String teacherDashboard = '/teacher/dashboard';
  static const String studentsList = '/teacher/students-list';
  static const String studentProgress = '/teacher/student-progress';
  static const String markAttendance = '/teacher/mark-attendance';
  
  // Student routes
  static const String studentDashboard = '/student/dashboard';
  static const String quranProgress = '/student/quran-progress';
  static const String dailyPlan = '/student/daily-plan';
  
  // Admin routes
  static const String adminDashboard = '/admin/dashboard';
}

// App routes map
final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.splash: (context) => SplashScreen(),
  AppRoutes.login: (context) => LoginScreen(),
  AppRoutes.register: (context) => RegisterScreen(),
  AppRoutes.forgotPassword: (context) => ForgotPasswordScreen(),
  AppRoutes.home: (context) => HomeScreen(),
  AppRoutes.profile: (context) => ProfileScreen(),
  AppRoutes.editProfile: (context) => EditProfileScreen(),
  AppRoutes.news: (context) => NewsScreen(),
  AppRoutes.calendar: (context) => CalendarScreen(),
  
  // Parent routes
  AppRoutes.parentDashboard: (context) => ParentDashboard(),
  AppRoutes.studentDetails: (context) => StudentDetailsScreen(),
  AppRoutes.learningPlan: (context) => LearningPlanScreen(),
  AppRoutes.progress: (context) => ProgressScreen(),
  AppRoutes.attendance: (context) => AttendanceScreen(),
  AppRoutes.certificates: (context) => CertificatesScreen(),
  AppRoutes.requests: (context) => RequestsScreen(),
  AppRoutes.documents: (context) => DocumentsScreen(),
  AppRoutes.notifications: (context) => NotificationsScreen(),
  
  // Teacher routes
  AppRoutes.teacherDashboard: (context) => TeacherDashboard(),
  AppRoutes.studentsList: (context) => StudentsListScreen(),
  AppRoutes.studentProgress: (context) => StudentProgressScreen(),
  AppRoutes.markAttendance: (context) => MarkAttendanceScreen(),
  
  // Student routes
  AppRoutes.studentDashboard: (context) => StudentDashboard(),
  AppRoutes.quranProgress: (context) => QuranProgressScreen(),
  AppRoutes.dailyPlan: (context) => DailyPlanScreen(),
  
  // Admin routes
  AppRoutes.adminDashboard: (context) => AdminDashboard(),
};
