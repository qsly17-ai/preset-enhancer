@echo off
setlocal
cd /d "%~dp0"

set "PYTHON_CMD="

call :check_python python
if defined PYTHON_CMD goto run

call :check_python py -3
if defined PYTHON_CMD goto run

echo.
echo [Preset Enhancer] Python 3.10+ not found.
echo.
echo Please install Python 3.10+ and check "Add python.exe to PATH".
echo Download: https://www.python.org/downloads/
echo.
pause
exit /b 1

:run
echo [Preset Enhancer] Using: %PYTHON_CMD%
%PYTHON_CMD% server.py %*
pause
exit /b %ERRORLEVEL%

:check_python
set "CANDIDATE=%*"
where %1 >nul 2>nul
if errorlevel 1 exit /b 0
%CANDIDATE% -c "import sys; raise SystemExit(0 if sys.version_info >= (3,10) else 1)" >nul 2>nul
if errorlevel 1 exit /b 0
set "PYTHON_CMD=%CANDIDATE%"
exit /b 0
