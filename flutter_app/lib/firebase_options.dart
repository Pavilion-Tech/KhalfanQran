import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('VITE_FIREBASE_API_KEY', defaultValue: 'AIzaSyDefault'),
    appId: String.fromEnvironment('VITE_FIREBASE_APP_ID', defaultValue: '1:215540613:web:default'),
    messagingSenderId: '215540613',
    projectId: String.fromEnvironment('VITE_FIREBASE_PROJECT_ID', defaultValue: 'khalfan-center-demo'),
    authDomain: '${String.fromEnvironment('VITE_FIREBASE_PROJECT_ID', defaultValue: 'khalfan-center-demo')}.firebaseapp.com',
    storageBucket: '${String.fromEnvironment('VITE_FIREBASE_PROJECT_ID', defaultValue: 'khalfan-center-demo')}.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxHtygDTl3C8nD-o9Mz4ufRQPgFSIGgPY',
    appId: '1:215540613:android:d4ee36cca2e9eb24a5d5de',
    messagingSenderId: '215540613',
    projectId: 'khalfan-center',
    storageBucket: 'khalfan-center.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxPc0KQ1fqG8Jy_ZpQLbdEplGz-MZh4Ko',
    appId: '1:215540613:ios:b74c38eeb7f1dbd8a5d5de',
    messagingSenderId: '215540613',
    projectId: 'khalfan-center',
    storageBucket: 'khalfan-center.appspot.com',
    iosClientId: '215540613-cc5a8h6b7oqgq7mqg9ejsq4cvr5v1lh5.apps.googleusercontent.com',
    iosBundleId: 'com.khalfancenter.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxPc0KQ1fqG8Jy_ZpQLbdEplGz-MZh4Ko',
    appId: '1:215540613:ios:b74c38eeb7f1dbd8a5d5de',
    messagingSenderId: '215540613',
    projectId: 'khalfan-center',
    storageBucket: 'khalfan-center.appspot.com',
    iosClientId: '215540613-cc5a8h6b7oqgq7mqg9ejsq4cvr5v1lh5.apps.googleusercontent.com',
    iosBundleId: 'com.khalfancenter.app',
  );
}