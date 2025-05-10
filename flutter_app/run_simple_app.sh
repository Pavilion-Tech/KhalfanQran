#!/bin/bash

# هذا الملف يستخدم لتشغيل النسخة البسيطة من التطبيق

echo "بدء تشغيل النسخة البسيطة من تطبيق مركز خلفان"
echo "بدء خادم Flutter على منفذ 5000"

flutter run -d web-server --web-port 5000 --web-hostname 0.0.0.0 lib/simple_main.dart