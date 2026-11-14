# 🤖 Gemini PC Workspace (Custom MCP Server)

[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MCP Protocol](https://img.shields.io/badge/MCP-Model%20Context%20Protocol-green.svg)](https://modelcontextprotocol.io/)

เชื่อมต่อ **Google Gemini** บนเว็บเข้ากับคอมพิวเตอร์ของคุณโดยตรงผ่าน **Model Context Protocol (MCP)** สั่งให้ AI อ่านไฟล์, สร้างไฟล์, แก้ไขโค้ด และสั่งรันคำสั่งบนเครื่องได้เหมือนมี **JARVIS ประจำตัว!**

---

## ✨ จุดเด่น (Features)

- 📂 **จัดการไฟล์ในเครื่อง:** สั่งให้ Gemini ดูรายชื่อไฟล์, อ่านเนื้อหา, หรือสร้างไฟล์ใหม่ลงในโฟลเดอร์ทำงานบน PC
- ⚡ **One-Click Start:** มีไฟล์ `start.bat` ให้ดับเบิ้ลคลิกเดียว รันทั้งเซิร์ฟเวอร์และเปิด Cloudflare Tunnel อัตโนมัติ
- 🛡️ **ปลอดภัยด้วยระบบ Sandbox:** จำกัดสิทธิ์การเข้าถึงไฟล์เฉพาะในโฟลเดอร์ที่กำหนด ป้องกัน Path Traversal
- 🔒 **Command Whitelist:** ป้องกันการสั่งคำสั่งอันตราย รันได้เฉพาะคำสั่งปลอดภัยที่อนุญาตเท่านั้น
- 🌐 **ไม่ต้องเปิดพอร์ตเราเตอร์:** ใช้งานผ่าน Cloudflare Tunnel (ฟรี 100% ไม่ต้องสมัครสมาชิก ไม่ต้องใช้ IP จริง)
- 🔄 **รองรับ MCP ทุกเวอร์ชัน:** มี Compatibility Layer ในตัว แก้ปัญหา `ModuleNotFoundError` และ DNS Rebinding อัตโนมัติ

---

## 🛠️ เครื่องมือที่ Gemini สั่งงานได้ (Available Tools)

| Tool Name | คำอธิบาย | ตัวอย่างการสั่งในแชท |
| :--- | :--- | :--- |
| `list_files` | แสดงรายชื่อไฟล์ทั้งหมดในโฟลเดอร์ทำงาน | *"ดูรายชื่อไฟล์ทั้งหมดในโฟลเดอร์ทำงานหน่อย"* |
| `read_file` | อ่านเนื้อหาไฟล์ข้อความ | *"อ่านเนื้อหาในไฟล์ notes.txt ให้ฟังหน่อย"* |
| `write_file` | สร้างหรือบันทึกไฟล์ใหม่ลงในเครื่อง | *"ช่วยเขียนสรุปแผนงานลงไฟล์ plan.md"* |
| `run_allowed_command` | รันคำสั่งปลอดภัย (`git_status`, `python_version`, `list_dir`) | *"เช็คสถานะ git status ในเครื่องให้ที"* |

---

## 🚀 เริ่มต้นใช้งานใน 3 ขั้นตอน (Quick Start)

### ขั้นตอนที่ 1: ดาวน์โหลดโปรเจกต์
```bash
git clone https://github.com/108ido/gemini-pc-mcp.git
cd gemini-pc-mcp
```

### ขั้นตอนที่ 2: ตั้งรหัสลับ (ครั้งเดียว)

ทุก request ต้องมีรหัสลับ ถ้าไม่มีหรือรหัสผิด server จะตอบ 404
```bash
python -c "import secrets;open('.mcp_secret','w').write(secrets.token_urlsafe(24))"
```
- `.mcp_secret` = รหัสลับของ MCP
- `.tunnel_token` = token ของ Cloudflare Named Tunnel (คัดลอกจาก Zero Trust > Networks > Tunnels)
- ทั้งสองไฟล์อยู่ใน `.gitignore` **ห้าม commit**

### ขั้นตอนที่ 3: รันระบบ

#### 👉 Windows
ดับเบิลคลิก **`start.bat`** ระบบจะเปิด MCP server (พอร์ต 8000) แล้วต่อ Named Tunnel ด้วย `--token-file .tunnel_token`

#### 👉 รันเองผ่าน Terminal
```bash
pip install -r requirements.txt
python server.py
cloudflared tunnel run --token-file .tunnel_token
```
ถ้าจะทดลองแบบไม่มี Named Tunnel ใช้ `cloudflared tunnel --url http://127.0.0.1:8000` ได้ แต่จะได้ลิงก์สุ่มที่เปลี่ยนทุกครั้งที่เปิดใหม่

---

### ขั้นตอนที่ 4: นำลิงก์ไปใส่ใน Google Gemini

1. URL ที่ใช้ (เอารหัสในไฟล์ `.mcp_secret` มาใส่แทน `<secret>`):
   ```text
   https://pc-mcp.108ido.com/<secret>/mcp
   ```
   ถ้า client ใส่ header ได้ ใช้ `https://pc-mcp.108ido.com/mcp` คู่กับ `Authorization: Bearer <secret>` แทนก็ได้
2. เปิด **Google Gemini** ([gemini.google.com](https://gemini.google.com)) > **เครื่องมือเชื่อมต่อ (Connectors)** > **+ กำหนดเอง (+ Custom)**
3. วาง URL ลงในช่อง **URL ของเซิร์ฟเวอร์ MCP** แล้วกดบันทึก

---

## 📂 โฟลเดอร์ทำงาน (Workspace)

ค่าเริ่มต้นคือโฟลเดอร์ของโปรเจกต์นี้ ถ้าต้องการเปลี่ยน ให้กำหนดผ่าน Environment Variable `MCP_WORKSPACE`:

```powershell
$env:MCP_WORKSPACE = "C:\Your\Custom\Path"
python server.py
```

---

## ⚠️ ความปลอดภัย

- ถ้าไม่มีรหัสลับ server จะตอบ 404 ทุก request ถ้ารหัสหลุดเมื่อไหร่ ให้สร้าง `.mcp_secret` ใหม่แล้วรีสตาร์ท server
- MCP **อ่านหรือแสดงไม่ได้**: `.mcp_secret`, `.tunnel_token`, `.git`, `.env` และทุกอย่างที่อยู่นอกโฟลเดอร์ทำงาน
- MCP **เขียนไม่ได้**: ไฟล์ที่รันได้ (`.py .bat .cmd .ps1 .vbs .js .exe .dll .lnk .reg .scr .msi`) กันไม่ให้มีคนเขียน `server.py`/`start.bat` ใหม่เพื่อสั่งรันโค้ดบน PC
- ถ้า token ของ tunnel หลุด ให้ไปกด Refresh token ใน Cloudflare Zero Trust แล้วอัปเดตไฟล์ `.tunnel_token`

---

## 📄 License

โปรเจกต์นี้เผยแพร่ภายใต้สัญญาอนุญาต [MIT License](LICENSE) สามารถนำไปต่อยอด ดัดแปลง และใช้งานได้ฟรี!
