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

### ขั้นตอนที่ 2: รันระบบ (เลือกวิธีใดวิธีหนึ่ง)

#### 👉 วิธีที่ง่ายที่สุด (Windows)
ดับเบิ้ลคลิกที่ไฟล์ **`start.bat`**
- ระบบจะตรวจสอบ Python, ติดตั้งไลบรารี และเปิดเซิร์ฟเวอร์ + Cloudflare Tunnel ให้อัตโนมัติ

#### 👉 หรือรันแบบ Manual ผ่าน Terminal:
1. ติดตั้ง Dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. รันเซิร์ฟเวอร์ (หน้าต่างที่ 1):
   ```bash
   python server.py
   ```
3. เปิด Tunnel (หน้าต่างที่ 2):
   ```bash
   cloudflared tunnel --url http://127.0.0.1:8000
   ```

---

### ขั้นตอนที่ 3: นำลิงก์ไปใส่ใน Google Gemini

1. ดูที่หน้าต่าง Cloudflare Tunnel จะมีกรอบสี่เหลี่ยมแสดงลิงก์:
   ```text
   https://xxxxxxxxxxxxxx.trycloudflare.com
   ```
2. **นำลิงก์มาเติม `/mcp` ต่อท้าย** เช่น:
   ```text
   https://xxxxxxxxxxxxxx.trycloudflare.com/mcp
   ```
3. เปิดเว็บ **Google Gemini** ([gemini.google.com](https://gemini.google.com))
4. ไปที่เมนู **เครื่องมือเชื่อมต่อ (Connectors / Extensions)** > เลือก **+ กำหนดเอง (+ Custom)**
5. วางลิงก์ลงในช่อง **URL ของเซิร์ฟเวอร์ MCP** *(ช่องอื่นๆ ในการตั้งค่าเพิ่มเติม ปล่อยว่างไว้ได้เลย)*
6. กด **ถัดไป / บันทึก** แล้วเริ่มคุยกับ Gemini สั่งจัดการไฟล์ในเครื่องได้ทันที! 🎉

---

## 📂 โครงสร้างโฟลเดอร์ทำงาน (Workspace)

ค่าเริ่มต้นจะทำงานอยู่ที่โฟลเดอร์ `workspace/` ภายในโปรเจกต์
หากต้องการเปลี่ยนโฟลเดอร์ทำงานไปยังที่อื่น สามารถกำหนดผ่าน Environment Variable `MCP_WORKSPACE`:

```powershell
$env:MCP_WORKSPACE = "C:\Your\Custom\Path"
python server.py
```

---

## ⚠️ คำแนะนำด้านความปลอดภัย (Security Best Practices)

- ลิงก์ `trycloudflare.com` เป็นลิงก์ชั่วคราว ใครที่มีลิงก์จะสามารถเข้าถึง Tools ของคุณได้
- **เมื่อเลิกใช้งานทุกครั้ง:** ให้กด `Ctrl + C` เพื่อปิดหน้าต่าง Terminal ทั้งหมด เพื่อตัดการเชื่อมต่อจากภายนอก
- หากต้องการใช้งานถาวร แนะนำให้ตั้งค่า **Cloudflare Zero Trust** หรือ **Cloudflare Access** เพื่อบังคับให้ล็อกอินก่อนเข้าถึง

---

## 📄 License

โปรเจกต์นี้เผยแพร่ภายใต้สัญญาอนุญาต [MIT License](LICENSE) สามารถนำไปต่อยอด ดัดแปลง และใช้งานได้ฟรี!
