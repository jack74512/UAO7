@echo off
cd /d "C:\Program Files\TxGameAssistant\ui"

:: التحقق من صلاحيات المسؤول
fltmc >nul 2>&1
if not %errorlevel%==0 (
    echo يرجى تشغيل هذا الملف كمسؤول.
    pause
    exit
)


:: حذف الملف من المسار المستهدف
adb shell rm /data/data/com.tencent.ig/lib/libGVoicePlugin.so

echo.
echo All commands executed successfully!
pause
