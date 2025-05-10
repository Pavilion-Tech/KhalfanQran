import 'package:flutter/material.dart';

/// نقطة الدخول الرئيسية للتطبيق
/// تستخدم هذه الفئة لتهيئة التطبيق وإعداد الثيم والتوجيه
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مركز خلفان لتحفيظ القرآن الكريم',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF006400), // أخضر داكن
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF006400), // أخضر داكن
          secondary: const Color(0xFF1E88E5), // أزرق
          background: Colors.grey.shade50,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF006400),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006400),
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006400),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006400),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: const Color(0xFF006400).withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF006400),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      home: const HomePagePlaceholder(),
    );
  }
}

class HomePagePlaceholder extends StatelessWidget {
  const HomePagePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز خلفان لتحفيظ القرآن الكريم'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book,
              size: 80,
              color: Color(0xFF006400),
            ),
            const SizedBox(height: 20),
            Text(
              'مركز خلفان لتحفيظ القرآن الكريم',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'النسخة الكاملة للتطبيق',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: const Text('بدء الاستخدام'),
            ),
          ],
        ),
      ),
    );
  }
}