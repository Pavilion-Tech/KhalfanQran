#!/bin/bash

# ملف للتحقق من وجود الملفات الضرورية قبل فتح المشروع في Android Studio

echo "التحقق من إعدادات تكوين التطبيق..."

# التحقق من وجود ملفات التكوين الأساسية
if [ -f "android/local.properties" ]; then
  echo "✓ تم العثور على ملف android/local.properties"
else
  echo "✗ لم يتم العثور على ملف android/local.properties"
fi

if [ -d ".idea/runConfigurations" ]; then
  echo "✓ تم العثور على مجلد تكوينات التشغيل"
  
  if [ -f ".idea/runConfigurations/main_dart.xml" ]; then
    echo "  ✓ تم العثور على تكوين main.dart"
  else
    echo "  ✗ لم يتم العثور على تكوين main.dart"
  fi
  
  if [ -f ".idea/runConfigurations/simple_main_dart.xml" ]; then
    echo "  ✓ تم العثور على تكوين simple_main.dart"
  else
    echo "  ✗ لم يتم العثور على تكوين simple_main.dart"
  fi
else
  echo "✗ لم يتم العثور على مجلد تكوينات التشغيل"
fi

# التحقق من وجود ملفات المشروع الأساسية
if [ -f "lib/main.dart" ]; then
  echo "✓ تم العثور على ملف main.dart"
else
  echo "✗ لم يتم العثور على ملف main.dart"
fi

if [ -f "lib/simple_main.dart" ]; then
  echo "✓ تم العثور على ملف simple_main.dart"
else
  echo "✗ لم يتم العثور على ملف simple_main.dart"
fi

echo -e "\nإرشادات فتح المشروع في Android Studio:"
echo "1. افتح Android Studio وحدد 'Open an existing project'"
echo "2. حدد مجلد flutter_app"
echo "3. افتح ملف simple_main.dart وقم بتشغيله أولاً للتحقق من المشروع"

echo -e "\nاكتمل التحقق."