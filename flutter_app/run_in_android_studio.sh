#!/bin/bash

# هذا الملف يساعد على تشغيل التطبيق في Android Studio

# تأكد من تفعيل تنفيذ الملف
chmod +x "$(dirname "$0")/run_in_android_studio.sh"

# طباعة رسالة ترحيبية
echo "--------------------------------------------"
echo "مرحباً بك في تطبيق مركز خلفان لتحفيظ القرآن الكريم"
echo "--------------------------------------------"

# التحقق من تثبيت Flutter
if ! command -v flutter &> /dev/null; then
    echo "خطأ: Flutter غير مثبت على جهازك."
    echo "يرجى تثبيت Flutter من https://flutter.dev/docs/get-started/install"
    exit 1
fi

# عرض إصدار Flutter
flutter --version

# تحديث التبعيات
echo "--------------------------------------------"
echo "جاري تحديث التبعيات..."
flutter pub get

# عرض نصائح التشغيل
echo "--------------------------------------------"
echo "لتشغيل التطبيق في Android Studio:"
echo "1. افتح مجلد flutter_app في Android Studio"
echo "2. اختر run_my_app.dart أو simple_main.dart كنقطة دخول"
echo "3. اضغط على زر التشغيل (الزر الأخضر)"
echo "--------------------------------------------"

echo "للمزيد من المعلومات، راجع ملف README.md"
echo "--------------------------------------------"