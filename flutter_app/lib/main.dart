import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalfan_center/app.dart';
import 'package:khalfan_center/bloc/auth/auth_bloc.dart';
import 'package:khalfan_center/bloc/student/student_bloc.dart';
import 'package:khalfan_center/config/firebase_config.dart';
import 'package:khalfan_center/services/auth_service.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/services/mock_service.dart';

// خطأ تجريبي لطباعة المستوى التصحيحي سيعلمنا ما يحدث
class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  // سجل المراقب لتتبع أخطاء BLoC
  Bloc.observer = SimpleBlocObserver();

  // تأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  print('تطبيق مركز خلفان قيد التشغيل...');
  
  // محاولة تهيئة Firebase إذا كانت متغيرات البيئة متاحة
  bool firebaseInitialized = false;
  late FirebaseService firebaseService;
  late AuthService authService;
  
  try {
    print('بدء محاولة تهيئة Firebase...');
    final options = getFirebaseOptions();
    print('خيارات Firebase: ${options.apiKey.isEmpty ? "API key غير متوفر" : "API key متوفر"}');
    print('خيارات Firebase: ${options.projectId.isEmpty ? "Project ID غير متوفر" : "Project ID متوفر"}');
    
    if (options.apiKey.isNotEmpty && options.projectId.isNotEmpty && options.appId.isNotEmpty) {
      // تهيئة Firebase
      await Firebase.initializeApp(options: options);
      firebaseInitialized = true;
      print('تم تهيئة Firebase بنجاح');
      
      // إنشاء خدمات مع Firebase الحقيقي
      firebaseService = FirebaseService();
      authService = AuthService(firebaseService);
    } else {
      print('متغيرات البيئة لـ Firebase غير موجودة، استخدام الخدمات التجريبية');
      // استخدام الخدمات التجريبية
      firebaseService = MockService() as FirebaseService;
      authService = AuthService(firebaseService);
    }
  } catch (e) {
    print('خطأ في تهيئة Firebase: $e');
    // استخدام الخدمات التجريبية كحل بديل
    firebaseService = MockService() as FirebaseService;
    authService = AuthService(firebaseService);
  }
  
  print('تشغيل التطبيق...');
  
  // تشغيل التطبيق مع مزودي BLoC
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: authService),
        ),
        BlocProvider<StudentBloc>(
          create: (context) => StudentBloc(firebaseService: firebaseService),
        ),
      ],
      child: KhalfanCenterApp(
        firebaseInitialized: firebaseInitialized,
        authService: authService,
        firebaseService: firebaseService,
      ),
    ),
  );
}
