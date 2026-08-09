@echo off
setlocal

cd /d "%~dp0"

echo.
echo ================================================================
echo PHILOTES DEVELOPMENT PATCH SCRIPT
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

"%PYTHON313%" "%~dp0developerpatchscript.py"

if errorlevel 1 (
    echo.
    echo ================================================================
    echo PATCH FAILED
    echo ================================================================
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================================
echo PATCH COMPLETED SUCCESSFULLY
echo ================================================================
echo.

pause
endlocal