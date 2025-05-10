class AppConfig {
  // App details
  static const String appName = 'مركز خلفان لتحفيظ القرآن الكريم';
  static const String appNameEn = 'Khalfan Quran Memorization Center';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String studentsCollection = 'students';
  static const String teachersCollection = 'teachers';
  static const String attendanceCollection = 'attendance';
  static const String progressCollection = 'progress';
  static const String documentsCollection = 'documents';
  static const String requestsCollection = 'requests';
  static const String notificationsCollection = 'notifications';
  static const String newsCollection = 'news';
  static const String eventsCollection = 'events';
  static const String circlesCollection = 'circles'; // Study circles/groups
  
  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleSupervisor = 'supervisor';
  static const String roleTeacher = 'teacher';
  static const String roleParent = 'parent';
  static const String roleStudent = 'student';
  
  // Request Types
  static const String requestTypeAbsence = 'absence';
  static const String requestTypeSuggestion = 'suggestion';
  static const String requestTypeComplaint = 'complaint';
  static const String requestTypeEarlyLeave = 'earlyLeave';
  static const String requestTypeVacation = 'vacation';
  
  // Request Status
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';
  static const String statusCompleted = 'completed';
  
  // Document Types
  static const String docTypeID = 'id';
  static const String docTypePassport = 'passport';
  static const String docTypeResidency = 'residency';
  static const String docTypePhoto = 'photo';
  static const String docTypeCertificate = 'certificate';
  static const String docTypeMedical = 'medical';
  
  // API Endpoints
  static const String firebaseFunctionsUrl = 'https://us-central1-khalfan-center.cloudfunctions.net/api';
  
  // Default Images
  static const String defaultProfileImage = 'assets/images/default_profile.svg';
  static const String defaultLogo = 'assets/images/khalfan_logo.svg';
  
  // Shared Preferences Keys
  static const String prefUserLoggedIn = 'user_logged_in';
  static const String prefUserRole = 'user_role';
  static const String prefUserID = 'user_id';
  static const String prefLanguage = 'language';
  static const String prefThemeMode = 'theme_mode';
  
  // App Constants
  static const int attendanceReminderHour = 7; // 7 AM
  static const int maxAbsencesBeforeWarning = 3;
  static const Duration sessionTimeout = Duration(minutes: 30);
}
