@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
title Gemini PC Workspace Launcher

echo ========================================================
echo        Gemini PC Workspace - MCP Server Launcher        
echo ========================================================
echo.

:: 1. Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python 3.10+
    pause
    exit /b 1
)

:: 2. Find cloudflared
set "CF_EXE="
where cloudflared >nul 2>&1
if not errorlevel 1 (
    set "CF_EXE=cloudflared"
) else (
    if exist "C:\Program Files (x86)\cloudflared\cloudflared.exe" (
        set "CF_EXE=C:\Program Files (x86)\cloudflared\cloudflared.exe"
    ) else if exist "C:\Program Files\cloudflared\cloudflared.exe" (
        set "CF_EXE=C:\Program Files\cloudflared\cloudflared.exe"
    ) else if exist "%LOCALAPPDATA%\Programs\cloudflared\cloudflared.exe" (
        set "CF_EXE=%LOCALAPPDATA%\Programs\cloudflared\cloudflared.exe"
    )
)

if not defined CF_EXE (
    echo [*] Installing Cloudflare Tunnel via winget...
    winget install -e --id Cloudflare.cloudflared --accept-package-agreements --accept-source-agreements
    if exist "C:\Program Files (x86)\cloudflared\cloudflared.exe" (
        set "CF_EXE=C:\Program Files (x86)\cloudflared\cloudflared.exe"
    ) else if exist "C:\Program Files\cloudflared\cloudflared.exe" (
        set "CF_EXE=C:\Program Files\cloudflared\cloudflared.exe"
    )
)

echo [*] Starting MCP Server (Port 8000)...
start "Gemini MCP Server" cmd /k "cd /d ""%~dp0"" && python server.py"

echo [*] Starting Cloudflare Tunnel...
echo [*] Copy the https://...trycloudflare.com/mcp URL to Gemini
echo.

if defined CF_EXE (
    "%CF_EXE%" tunnel --url http://127.0.0.1:8000
) else (
    cloudflared tunnel --url http://127.0.0.1:8000
)

pause
