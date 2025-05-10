import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:khalfan_center/services/auth_service.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/screens/home_screen.dart';
import 'package:khalfan_center/config/themes.dart';

class KhalfanCenterApp extends StatelessWidget {
  final bool firebaseInitialized;
  final AuthService? authService;
  final FirebaseService? firebaseService;

  const KhalfanCenterApp({
    Key? key,
    this.firebaseInitialized = false,
    this.authService,
    this.firebaseService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مركز خلفان لتحفيظ القرآن الكريم',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF006400), // Dark Green
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF006400), // Dark Green
          secondary: const Color(0xFF1E88E5), // Blue
          background: Colors.grey.shade50,
        ),
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF006400),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        fontFamily: 'Cairo',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('en', ''), // English
      ],
      locale: const Locale('ar', ''), // Default to Arabic
      home: firebaseInitialized
          ? HomeScreen(
              authService: authService,
              firebaseService: firebaseService,
              firebaseInitialized: firebaseInitialized,
            )
          : const HomeScreen(
              firebaseInitialized: false,
            ),
    );
  }
}