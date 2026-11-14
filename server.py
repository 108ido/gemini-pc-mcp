import os
from pathlib import Path
import subprocess

# รองรับทั้ง mcp เวอร์ชัน 1.x และ 2.x
try:
    from mcp.server.fastmcp import FastMCP
except ImportError:
    try:
        from fastmcp import FastMCP
    except ImportError:
        from mcp.server import MCPServer
        class FastMCP(MCPServer):
            def __init__(self, name: str, host: str = "127.0.0.1", port: int = 8000, **kwargs):
                super().__init__(name=name)
                self._default_host = host
                self._default_port = port

            def run(self, transport: str = "stdio", **kwargs):
                if transport == "streamable-http":
                    kwargs.setdefault("host", self._default_host)
                    kwargs.setdefault("port", self._default_port)
                    try:
                        from mcp.server.transport_security import TransportSecuritySettings
                        kwargs.setdefault(
                            "transport_security",
                            TransportSecuritySettings(enable_dns_rebinding_protection=False),
                        )
                    except Exception:
                        pass
                return super().run(transport=transport, **kwargs)

# สร้างอินสแตนซ์ FastMCP
mcp = FastMCP("PC-Workspace", host="127.0.0.1", port=8000)

# กำหนดโฟลเดอร์ทำงาน (Sandbox)
# ค่าเริ่มต้น: โฟลเดอร์ workspace/ ภายในโปรเจกต์ หรือกำหนดพาธที่ต้องการผ่าน Environment Variable 'MCP_WORKSPACE'
DEFAULT_WORKSPACE = Path(__file__).resolve().parent / "workspace"
WORKSPACE_DIR = Path(os.getenv("MCP_WORKSPACE", DEFAULT_WORKSPACE)).resolve()
WORKSPACE_DIR.mkdir(parents=True, exist_ok=True)

def safe_path(rel_path: str) -> Path:
    """ตรวจสอบความปลอดภัยเพื่อป้องกัน Path Traversal ออกนอกโฟลเดอร์ทำงาน"""
    target = (WORKSPACE_DIR / rel_path).resolve()
    if not target.is_relative_to(WORKSPACE_DIR):
        raise ValueError("ไม่อนุญาตให้เข้าถึงไฟล์นอกโฟลเดอร์ที่กำหนด (Directory Traversal Blocked)")
    return target

@mcp.tool()
def list_files() -> list[str]:
    """แสดงรายชื่อไฟล์ทั้งหมดในโฟลเดอร์ทำงานบน PC"""
    return [str(p.relative_to(WORKSPACE_DIR)) for p in WORKSPACE_DIR.rglob("*") if p.is_file()]

@mcp.tool()
def read_file(filename: str) -> str:
    """อ่านเนื้อหาไฟล์ข้อความในโฟลเดอร์ทำงาน"""
    return safe_path(filename).read_text(encoding="utf-8")

@mcp.tool()
def write_file(filename: str, content: str) -> str:
    """สร้างหรือแก้ไขไฟล์ข้อความในโฟลเดอร์ทำงาน"""
    path = safe_path(filename)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    return f"บันทึกไฟล์ {filename} เรียบร้อยแล้ว (ขนาด {len(content)} ตัวอักษร)"

# กำหนดเฉพาะคำสั่งที่อนุญาตให้รันแบบตายตัวเพื่อป้องกันการแทรกคำสั่งอันตราย
ALLOWED_COMMANDS = {
    "git_status": ["git", "status"],
    "python_version": ["python", "--version"],
    "list_dir": ["cmd", "/c", "dir"],
}

@mcp.tool()
def run_allowed_command(command_key: str) -> str:
    """รันคำสั่งใน PC จากรายการที่อนุญาต (git_status, python_version, list_dir)"""
    if command_key not in ALLOWED_COMMANDS:
        return f"ไม่อนุญาตคำสั่งนี้ คำสั่งที่ใช้ได้คือ: {', '.join(ALLOWED_COMMANDS.keys())}"
    result = subprocess.run(
        ALLOWED_COMMANDS[command_key],
        cwd=WORKSPACE_DIR,
        capture_output=True,
        text=True,
        timeout=15,
    )
    return result.stdout or result.stderr

if __name__ == "__main__":
    print("=" * 60)
    print("🚀 Gemini PC Workspace - MCP Server")
    print(f"📂 Workspace Directory: {WORKSPACE_DIR}")
    print("🌐 Endpoint: http://127.0.0.1:8000/mcp")
    print("=" * 60)
    mcp.run(transport="streamable-http")
