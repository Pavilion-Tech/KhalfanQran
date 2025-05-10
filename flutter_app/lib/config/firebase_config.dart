import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dart:js' as js;

// هذا الملف يحتوي على تكوين Firebase لتطبيق مركز خلفان لتحفيظ القرآن الكريم

/// تكوين Firebase للويب
FirebaseOptions getFirebaseOptions() {
  // محاولة الحصول على التكوين من window.firebaseConfig
  if (kIsWeb) {
    try {
      final hasFirebaseConfig = js.context.hasProperty('firebaseConfig');
      if (hasFirebaseConfig) {
        final firebaseConfig = js.context['firebaseConfig'];
        print('Found Firebase config in window');
        return FirebaseOptions(
          apiKey: firebaseConfig['apiKey'] ?? '',
          appId: firebaseConfig['appId'] ?? '',
          projectId: firebaseConfig['projectId'] ?? '',
          authDomain: firebaseConfig['authDomain'] ?? '',
          messagingSenderId: firebaseConfig['messagingSenderId'] ?? '',
          storageBucket: firebaseConfig['storageBucket'] ?? '',
        );
      }
    } catch (e) {
      print('Error getting Firebase config from window: $e');
    }
  }

  // استخدام متغيرات البيئة
  return FirebaseOptions(
    apiKey: String.fromEnvironment('VITE_FIREBASE_API_KEY', defaultValue: ''),
    appId: String.fromEnvironment('VITE_FIREBASE_APP_ID', defaultValue: ''),
    projectId: String.fromEnvironment('VITE_FIREBASE_PROJECT_ID', defaultValue: ''),
    authDomain: String.fromEnvironment('VITE_FIREBASE_PROJECT_ID', defaultValue: '') + '.firebaseapp.com',
    messagingSenderId: '',
    storageBucket: String.fromEnvironment('VITE_FIREBASE_PROJECT_ID', defaultValue: '') + '.appspot.com',
  );
}