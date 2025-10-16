@echo off
setlocal enabledelayedexpansion
title Java Version Switcher
color 0A
cls

echo ============================================
echo           JAVA VERSION SWITCHER
echo ============================================
echo.

set "JAVA_DIR=C:\Program Files\Java"

if not exist "%JAVA_DIR%" (
    color 0C
    echo [X] Java installation directory not found:
    echo     %JAVA_DIR%
    echo.
    pause
    exit /b
)

echo [*] Scanning for installed Java versions...
echo.

set COUNT=0
for /d %%G in ("%JAVA_DIR%\*") do (
    for %%H in (%%G) do set "FOLDER_NAME=%%~nxH"
    echo !FOLDER_NAME! | find /I "jre" >nul
    if errorlevel 1 (
        set /a COUNT+=1
        set "JAVA_PATH[!COUNT!]=%%G"
        echo    [!COUNT!] %%G
    )
)

if %COUNT%==0 (
    color 0C
    echo [X] No JDK installations found in:
    echo     %JAVA_DIR%
    echo.
    echo Please install JDK first or check installation paths.
    pause
    exit /b
)

echo.
echo [*] Found %COUNT% JDK installation^(s^).
echo.

:SELECT_VERSION
set /p "CHOICE=>> Enter the number of the Java version to switch to (1-%COUNT%): "

rem -- Validate choice
if "%CHOICE%"=="" goto :invalid
if %CHOICE% lss 1 goto :invalid
if %CHOICE% gtr %COUNT% goto :invalid

set "SELECTED_JAVA=!JAVA_PATH[%CHOICE%]!"
set "NEW_PATH=%SELECTED_JAVA%\bin"

echo.
echo Set Environment variables JAVA_HOME and PATH...
echo.


powershell -Command "[System.Environment]::SetEnvironmentVariable('JAVA_HOME', '%SELECTED_JAVA%', 'Machine')"
powershell -Command ^
    "$path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine');" ^
    "$path = $path -replace ';?C:\\Program Files\\Java\\jdk[^;]*\\bin;?', '';" ^
    "$path = $path -replace ';?C:\\Program Files \(x86\)\\Java\\jdk[^;]*\\bin;?', '';" ^
    "$path = $path -replace ';?C:\\Program Files\\Common Files\\Oracle\\Java\\javapath;?', '';" ^
    "$path = $path -replace ';?C:\\Program Files \(x86\)\\Common Files\\Oracle\\Java\\javapath;?', '';" ^
    "$newPath = '%NEW_PATH%;' + $path;" ^
    "[System.Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')"

color 0A
echo [OK] Successfully switched Java version
echo.
echo JAVA_HOME  = %SELECTED_JAVA%
echo PATH       = %NEW_PATH%

echo.
echo Open a new terminal to apply changes.
pause
exit /b

:invalid
color 0C
echo [X] Invalid choice. Please run the script again.
pause
exit /b
