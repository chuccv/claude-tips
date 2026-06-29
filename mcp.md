# MCP Servers

Ghi chú về các MCP server đang dùng trong workspace.

## CodeGraph (Magento)

Index code thành knowledge graph (SQLite) để tra cứu symbol / call chain / file nhanh, thay cho vòng lặp grep + read.

- Repo: https://github.com/chuccv/codegraph-magento
- Index được: PHP, JavaScript, TypeScript, XML, YAML, liquid
- **Không** index: CSS / LESS / SCSS → các file style này vẫn dùng `grep`

### Cài đặt

**macOS / Linux (installer tự động — khuyến nghị):**
```bash
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.ps1 | iex
```

**Qua npm (mọi nền tảng):**
```bash
npm i -g @colbymchenry/codegraph
```

### Cấu hình agent

Tự động dò và wire MCP server vào Claude Code, Cursor, Codex CLI, Gemini CLI, v.v.:
```bash
codegraph install            # interactive
codegraph install --yes      # tự dò, cài global
codegraph install --target=claude --yes
```

### Khởi tạo project

Vào từng project cần index:
```bash
cd your-project
codegraph init -i            # -i: build graph ngay; bỏ -i thì chạy `codegraph index` riêng
```

### Cấu hình MCP thủ công (nếu không dùng installer)

Thêm vào `~/.claude.json`:
```json
{
  "mcpServers": {
    "codegraph": {
      "type": "stdio",
      "command": "codegraph",
      "args": ["serve", "--mcp"]
    }
  }
}
```

Tùy chọn auto-allow permission trong `~/.claude/settings.json`:
```json
{
  "permissions": {
    "allow": [
      "mcp__codegraph__codegraph_search",
      "mcp__codegraph__codegraph_explore",
      "mcp__codegraph__codegraph_callers",
      "mcp__codegraph__codegraph_callees",
      "mcp__codegraph__codegraph_impact",
      "mcp__codegraph__codegraph_node",
      "mcp__codegraph__codegraph_status",
      "mcp__codegraph__codegraph_files"
    ]
  }
}
```

### Kiểm tra & gỡ

```bash
codegraph status      # xem health: files / nodes / edges
codegraph uninstall   # gỡ khỏi tất cả agent
```
