@echo off
setlocal enabledelayedexpansion
title Reiseki — Windows Installer

echo === Reiseki — Windows Installer ===
echo.

:: ── 1. Check Python ──────────────────────────────────────────────────────────
where python >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not on PATH.
    echo Download it from: https://www.python.org/downloads/
    echo Be sure to check "Add Python to PATH" during install.
    pause
    exit /b 1
)
for /f "tokens=2 delims= " %%v in ('python --version 2^>^&1') do set PY_VER=%%v
echo Found Python %PY_VER%

:: ── 2. Check Ollama ───────────────────────────────────────────────────────────
where ollama >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Ollama is not installed or not on PATH.
    echo Download and install it from: https://ollama.com/download
    echo After installing Ollama, re-run this script.
    pause
    exit /b 1
)
echo Found Ollama

:: ── 3. Start Ollama ───────────────────────────────────────────────────────────
echo Starting Ollama service...
start /b ollama serve
timeout /t 3 /nobreak >nul
echo Ollama is running

:: ── 4. Pull model ─────────────────────────────────────────────────────────────
if "%AGENT_MODEL%"=="" set AGENT_MODEL=qwen2.5-coder:7b
echo.
echo Pulling model: %AGENT_MODEL%
echo This may take several minutes on first run...
ollama pull %AGENT_MODEL%
if errorlevel 1 (
    echo ERROR: Failed to pull model %AGENT_MODEL%.
    pause
    exit /b 1
)
echo Model ready: %AGENT_MODEL%

:: ── 5. Create virtual environment ─────────────────────────────────────────────
set SCRIPT_DIR=%~dp0
set VENV_DIR=%SCRIPT_DIR%venv

if not exist "%VENV_DIR%" (
    echo Creating Python virtual environment...
    python -m venv "%VENV_DIR%"
)
echo Virtual environment ready

:: ── 6. Install Python dependencies ───────────────────────────────────────────
echo Installing Python dependencies...
"%VENV_DIR%\Scripts\pip.exe" install --quiet --upgrade pip
"%VENV_DIR%\Scripts\pip.exe" install --quiet -r "%SCRIPT_DIR%requirements.txt"
if errorlevel 1 (
    echo ERROR: Dependency installation failed.
    pause
    exit /b 1
)
echo Dependencies installed

:: ── 7. Create launcher ────────────────────────────────────────────────────────
set LAUNCHER=%SCRIPT_DIR%launch.bat
(
echo @echo off
echo title Reiseki
echo set SCRIPT_DIR=%%~dp0
echo start /b ollama serve
echo timeout /t 2 /nobreak ^>nul
echo "%%SCRIPT_DIR%%venv\Scripts\python.exe" "%%SCRIPT_DIR%%launcher.py"
) > "%LAUNCHER%"
echo Launcher created: launch.bat

echo.
echo === Installation Complete ===
echo.
echo To start the app, double-click launch.bat
echo Browser fallback: http://localhost:8000
echo.
echo To use a different model, set before running:
echo   set AGENT_MODEL=qwen2.5-coder:14b
echo.
pause
