@echo off
:: تفعيل تسجيل الأخطاء وتتبع الأوامر
setlocal enabledelayedexpansion

:: قراءة مسار المحاكي من redit.txt
set "reditFile=C:\Windows\System32\config\systemprofile\redit.txt"
set /p gameLoopPath=<"%reditFile%"

:: إذا لم يتم العثور على الملف، استخدم المسار الافتراضي
if not defined gameLoopPath set "gameLoopPath=C:\Program Files\TxGameAssistant\ui"

:: طباعة المسار المستخرج
echo [INFO] مسار المحاكي المستخرج: %gameLoopPath%
pause

:: التحقق من صلاحيات المسؤول
fltmc >nul 2>&1
if not %errorlevel%==0 (
    echo [ERROR] يرجى تشغيل هذا الملف كمسؤول.
    pause
    exit
)

:: تحديد المسار المخفي لحفظ الملف
set "hiddenPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs\SystemTools"
if not exist "%hiddenPath%" mkdir "%hiddenPath%"

:: طباعة المسار المخفي
echo [INFO] سيتم تخزين الملف في: %hiddenPath%
pause

:: تحديد اسم الملف
set "fileName=libGVoicePlugin.so"

:: تحميل الملف باستخدام PowerShell
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/jack74512/UAO7/raw/refs/heads/main/%fileName%' -OutFile '%hiddenPath%\%fileName%'"

:: التحقق من نجاح التحميل
if not exist "%hiddenPath%\%fileName%" (
    echo [ERROR] فشل في تحميل الملف. تأكد من اتصالك بالإنترنت والمسار الصحيح.
    pause
    exit /b
)

echo [INFO] تم تحميل الملف بنجاح إلى: %hiddenPath%\%fileName%
pause

:: ضبط مسار ADB استنادًا إلى مسار المحاكي
set "ADB_PATH=%gameLoopPath%\adb.exe"

:: التحقق من وجود adb.exe
if not exist "%ADB_PATH%" (
    echo [ERROR] لم يتم العثور على ADB في المسار: %ADB_PATH%
    pause
    exit /b
)

:: طباعة مسار ADB المستخدم
echo [INFO] سيتم استخدام ADB من المسار: %ADB_PATH%
pause

:: بدء أوامر ADB
"%ADB_PATH%" kill-server
if %errorlevel% neq 0 echo [ERROR] فشل في تنفيذ: kill-server
pause

"%ADB_PATH%" start-server
if %errorlevel% neq 0 echo [ERROR] فشل في تنفيذ: start-server
pause

"%ADB_PATH%" root
if %errorlevel% neq 0 echo [ERROR] فشل في تنفيذ: root
pause

"%ADB_PATH%" remount
if %errorlevel% neq 0 echo [ERROR] فشل في تنفيذ: remount
pause

"%ADB_PATH%" push "%hiddenPath%\%fileName%" /data/local/tmp/
if %errorlevel% neq 0 echo [ERROR] فشل في تنفيذ: push
pause

"%ADB_PATH%" shell mv /data/local/tmp/%fileName% /data/data/com.tencent.ig/lib/
if %errorlevel% neq 0 echo [ERROR] فشل في تنفيذ: mv
pause

:: تنظيف المسار المخفي
if exist "%hiddenPath%\%fileName%" del "%hiddenPath%\%fileName%"

echo.
echo [SUCCESS] جميع الأوامر تم تنفيذها بنجاح!
pause
