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

echo [*] Starting MCP Server (Port 8000)...
start "Gemini MCP Server" cmd /k "cd /d ""%~dp0"" && python server.py"

echo [*] Starting Cloudflare Named Tunnel (https://pc-mcp.108ido.com/^<secret^>/mcp - secret in .mcp_secret)...
echo.

if not exist ".tunnel_token" (
    echo [ERROR] .tunnel_token not found
    pause
    exit /b 1
)

if defined CF_EXE (
    "%CF_EXE%" tunnel run --token-file "%~dp0.tunnel_token"
) else (
    cloudflared tunnel run --token-file "%~dp0.tunnel_token"
)

pause
