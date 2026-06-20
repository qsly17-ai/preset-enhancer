@echo off
setlocal
cd /d "%~dp0"

set "PYTHON_CMD="
set "PYTHON_VERSION=3.12.10"
set "PYTHON_TAG=312"
set "PYTHON_INSTALLER=%TEMP%\python-%PYTHON_VERSION%-installer.exe"

call :check_python python
if defined PYTHON_CMD goto run

call :check_python py -3
if defined PYTHON_CMD goto run

call :check_python "%LocalAppData%\Programs\Python\Python%PYTHON_TAG%\python.exe"
if defined PYTHON_CMD goto run

echo.
echo [Preset Enhancer] Python 3.10+ not found.
echo This launcher can download and install Python %PYTHON_VERSION% from python.org.
echo.
echo It will install Python for the current user and add Python to PATH.
echo No admin permission is usually required.
echo.
pause

call :install_python
if errorlevel 1 goto install_failed

call :check_python "%LocalAppData%\Programs\Python\Python%PYTHON_TAG%\python.exe"
if defined PYTHON_CMD goto run

call :check_python py -3
if defined PYTHON_CMD goto run

call :check_python python
if defined PYTHON_CMD goto run

echo.
echo [Preset Enhancer] Python installation finished, but Python still cannot be found.
echo Please close this window and run enhancer-web-auto.cmd again.
echo If it still fails, install Python manually: https://www.python.org/downloads/
echo.
pause
exit /b 1

:run
echo [Preset Enhancer] Using: %PYTHON_CMD%
%PYTHON_CMD% server.py %*
pause
exit /b %ERRORLEVEL%

:install_python
set "PYTHON_ARCH=amd64"
if /I "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "PYTHON_ARCH=arm64"
if /I "%PROCESSOR_ARCHITEW6432%"=="ARM64" set "PYTHON_ARCH=arm64"
set "PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%-%PYTHON_ARCH%.exe"

echo.
echo [Preset Enhancer] Downloading Python from:
echo %PYTHON_URL%
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER%' -UseBasicParsing; exit 0 } catch { Write-Host $_.Exception.Message; exit 1 }"
if errorlevel 1 (
    echo.
    echo [Preset Enhancer] Download failed.
    exit /b 1
)

echo.
echo [Preset Enhancer] Installing Python silently...
echo.

"%PYTHON_INSTALLER%" /quiet InstallAllUsers=0 PrependPath=1 Include_launcher=1 Include_pip=1 Include_test=0 Include_doc=0 Shortcuts=0
if errorlevel 1 (
    echo.
    echo [Preset Enhancer] Python installer failed.
    exit /b 1
)

del "%PYTHON_INSTALLER%" >nul 2>nul
exit /b 0

:install_failed
echo.
echo [Preset Enhancer] Auto-install failed.
echo Please install Python manually: https://www.python.org/downloads/
echo.
pause
exit /b 1

:check_python
set "CANDIDATE=%*"
%CANDIDATE% -c "import sys; raise SystemExit(0 if sys.version_info >= (3,10) else 1)" >nul 2>nul
if errorlevel 1 exit /b 0
set "PYTHON_CMD=%CANDIDATE%"
exit /b 0
