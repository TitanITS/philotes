@echo off
setlocal

cd /d "%~dp0"

echo.
echo ================================================================
echo PHILOTES MASTER PATCH SYSTEM
echo ================================================================
echo.
echo Launcher : philotespatch.cmd
echo Python   : philotespatch.py
echo.
echo This is the ONLY Philotes patch launcher.
echo ================================================================
echo.

set "PYTHON313=C:\Users\techm\AppData\Local\Programs\Python\Python313\python.exe"

if not exist "%PYTHON313%" (
    echo FAIL: Python 3.13 was not found at:
    echo %PYTHON313%
    echo.
    pause
    exit /b 1
)

if not exist "%~dp0philotespatch.py" (
    echo FAIL: Master patch file was not found:
    echo %~dp0philotespatch.py
    echo.
    pause
    exit /b 1
)

"%PYTHON313%" "%~dp0philotespatch.py"

if errorlevel 1 (
    echo.
    echo ================================================================
    echo PHILOTES MASTER PATCH FAILED
    echo ================================================================
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================================
echo PHILOTES MASTER PATCH COMPLETED SUCCESSFULLY
echo ================================================================
echo.

pause
endlocal
