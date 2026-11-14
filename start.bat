@echo off
chcp 65001 >nul
title Gemini PC Workspace Launcher
color 0A

echo ========================================================
echo        Gemini PC Workspace - MCP Server Launcher        
echo ========================================================
echo.

:: 1. ตรวจสอบ Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] ไม่พบ Python ในเครื่อง กรุณาติดตั้ง Python 3.10 ขึ้นไป
    pause
    exit /b
)

:: 2. ติดตั้ง Dependencies
echo [*] กำลังตรวจสอบความพร้อมของไลบรารี...
pip install -r requirements.txt --quiet

:: 3. ตรวจสอบ Cloudflared
set CLOUDFLARED_CMD=cloudflared
cloudflared --version >nul 2>&1
if %errorlevel% neq 0 (
    if exist "C:\Program Files (x86)\cloudflared\cloudflared.exe" (
        set CLOUDFLARED_CMD="C:\Program Files (x86)\cloudflared\cloudflared.exe"
    ) else if exist "C:\Program Files\cloudflared\cloudflared.exe" (
        set CLOUDFLARED_CMD="C:\Program Files\cloudflared\cloudflared.exe"
    ) else (
        echo [*] กำลังติดตั้ง Cloudflare Tunnel ผ่าน winget...
        winget install -e --id Cloudflare.cloudflared --accept-package-agreements --accept-source-agreements
        if exist "C:\Program Files (x86)\cloudflared\cloudflared.exe" (
            set CLOUDFLARED_CMD="C:\Program Files (x86)\cloudflared\cloudflared.exe"
        )
    )
)

echo.
echo ========================================================
echo  ระบบกำลังเริ่มต้นการทำงาน:
echo   1. MCP Server รันที่พอร์ต 8000
echo   2. Cloudflare Tunnel กำลังสร้างลิงก์ HTTPS
echo ========================================================
echo.

:: รัน MCP Server ในหน้าต่างใหม่
start "Gemini MCP Server" cmd /k "python server.py"

:: รัน Cloudflare Tunnel ในหน้าต่างนี้
echo [*] กำลังเชื่อมต่อ Cloudflare Tunnel...
echo [*] เมื่อได้รับลิงก์ https://...trycloudflare.com ให้เติม /mcp ต่อท้าย
echo [*] เช่น: https://xxxx.trycloudflare.com/mcp
echo.
%CLOUDFLARED_CMD% tunnel --url http://127.0.0.1:8000
