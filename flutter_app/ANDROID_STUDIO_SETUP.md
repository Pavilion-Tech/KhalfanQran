# إعداد المشروع في Android Studio

## الخطوات الأساسية

1. **تنزيل المشروع**: قم بتنزيل المجلد `flutter_app` بالكامل إلى جهازك.

2. **تثبيت Flutter SDK**: تأكد من تثبيت Flutter SDK بالإصدار 3.16.0 أو أعلى.
   - يمكنك التحقق من الإصدار الحالي باستخدام الأمر: `flutter --version`
   - يجب تثبيت Flutter وإضافته إلى متغير PATH.

3. **فتح المشروع في Android Studio**:
   - افتح Android Studio.
   - اختر "Open an existing project" (أو File -> Open).
   - قم بتحديد مجلد `flutter_app` الذي قمت بتنزيله.

4. **تشغيل أمر pub get**:
   - عند فتح المشروع للمرة الأولى، قد تظهر رسالة لتنفيذ `pub get`. انقر على "Get dependencies".
   - أو قم بتنفيذ الأمر يدويًا: `flutter pub get` عبر Terminal.

5. **تحديث local.properties** (إذا لزم الأمر):
   - قم بتحرير ملف `android/local.properties` لتحديد مسار SDK الخاص بك:
   ```
   sdk.dir=/path/to/your/android/sdk
   flutter.sdk=/path/to/your/flutter/sdk
   flutter.buildMode=debug
   flutter.versionName=1.0.0
   flutter.versionCode=1
   ```

## إعداد التكوينات (Configurations)

1. **إنشاء تكوين تشغيل**:
   - إذا لم يتم التعرف تلقائيًا على ملفات التكوين الموجودة، يمكنك إنشاء تكوين جديد:
   - انتقل إلى Run -> Edit Configurations.
   - انقر على "+" واختر "Flutter".
   - في حقل "Name"، أدخل "simple_main".
   - في حقل "Dart entrypoint"، حدد ملف `lib/simple_main.dart`.
   - انقر على "Apply" ثم "OK".

2. **تشغيل التطبيق البسيط**:
   - اختر تكوين "simple_main" من القائمة المنسدلة في شريط الأدوات.
   - اختر جهازًا للتشغيل (محاكي أو جهاز حقيقي).
   - انقر على زر التشغيل (الزر الأخضر ▶️).

## المشاكل الشائعة وحلولها

1. **مشكلة "Add Configuration"**:
   - لحل مشكلة "Add Configuration" التي تظهر في الجزء العلوي من Android Studio، اتبع الخطوات المذكورة أعلاه في قسم "إعداد التكوينات".

2. **مشكلات التبعيات (Dependencies)**:
   - إذا ظهرت مشكلات في التبعيات، قم بتنفيذ الأوامر التالية:
     ```
     flutter clean
     flutter pub get
     flutter pub upgrade
     ```

3. **مشكلات مع جهاز Android**:
   - تأكد من تثبيت Android SDK Tools.
   - تأكد من تفعيل وضع المطور على جهازك وتمكين "USB Debugging".
   - استخدم أمر `flutter doctor` للتحقق من إعداد البيئة.

4. **تحديث Gradle**:
   - إذا ظهرت مشكلات تتعلق بـ Gradle، قد تحتاج إلى تحديث إصدار Gradle في ملف `android/gradle/wrapper/gradle-wrapper.properties`.

## ملاحظات هامة

- التطبيق مهيأ حاليًا للعمل بدون تكوين Firebase. إذا كنت ترغب في تفعيل Firebase، ستحتاج إلى إنشاء مشروع Firebase وتحديث ملفات التكوين.
- ملف `simple_main.dart` يوفر واجهة بسيطة للتحقق من أن التطبيق يعمل بشكل صحيح، بينما الملف `main.dart` يحتوي على التطبيق الكامل.
- في Android Studio، قد تحتاج إلى استخدام "Invalidate Caches / Restart" إذا استمرت المشكلات.