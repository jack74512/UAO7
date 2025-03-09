@echo off
chcp 65001 >nul

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs -Wait"
    exit /b
)

:: Read path from redit.txt and verify it exists
if not exist C:\Windows\System32\config\systemprofile\redit.txt (
    echo ERROR: redit.txt not found!
    pause
    exit /b
)

:: Read path and remove any extra spaces or empty lines
for /f "tokens=*" %%A in ('type C:\Windows\System32\config\systemprofile\redit.txt') do set target_path=%%A

:: Ensure the path is not empty
if "%target_path%"=="" (
    echo ERROR: No valid path found in redit.txt!
    pause
    exit /b
)

:: Replace double backslashes with single ones
set target_path=%target_path:\\=\%

:: Replace AndroidEmulatorEn.exe with adb.exe
set target_path=%target_path:AndroidEmulatorEn.exe=adb.exe%

:: حذف الملف من المسار المستهدف
adb shell rm /data/data/com.tencent.ig/lib/libGVoicePlugin.so

echo.
echo All commands executed successfully!
pause
