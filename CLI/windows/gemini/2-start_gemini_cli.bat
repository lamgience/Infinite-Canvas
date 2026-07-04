@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0..\..\.."

where gemini >nul 2>nul
if errorlevel 1 (
    echo Gemini CLI was not found in PATH.
    echo Please run CLI\windows\gemini\1-install_gemini_cli.bat first, then open a new terminal.
    echo.
    pause
    exit /b 1
)

gemini
