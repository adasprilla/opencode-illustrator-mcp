# Illustrator MCP for OpenCode

[Node](https://img.shields.io/badge/Node-%3E%3D20-brightgreen)
[Illustrator](https://img.shields.io/badge/Illustrator-2020--2025-blue)
[OpenCode](https://img.shields.io/badge/OpenCode-v2%2B-black)
[Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS-lightgrey)
[License](https://img.shields.io/badge/License-MIT-yellow)
[Tools](https://img.shields.io/badge/Tools-66-orange)

> One-click installer to connect **Adobe Illustrator 2020-2025 (stable, not Beta)** to **OpenCode** via MCP. Coexists with Rhino/Grasshopper. Auto-migrates old configs.

**Gist installer:** https://gist.github.com/adasprilla/6c8ea94f9bd6b46f2523615429002e97

---

### 🚀 Install in 30 seconds

**Option A — Fast (1 command)**

Open PowerShell (`Windows + R` > `powershell`) and paste:

```powershell
irm https://gist.githubusercontent.com/adasprilla/6c8ea94f9bd6b46f2523615429002e97/raw/install.ps1 | iex
```

**Option B — Safe (file)**

Download `install.ps1` from this repo and run: Right-click > Run with PowerShell.

### ✅ Verify

1. Open Illustrator 2020+ with a blank document
2. Run: `opencode`
3. Type: `/mcps`
4. You should see:
```
✓ illustrator  connected
✓ rhino        connected (if you use Rhino)
```

### 🎨 First test

Inside OpenCode:

```
Get current document info and create a 100x100 rectangle in the center filled with #FF5733
```

```
Dame la info del documento actual y crea un rectángulo de 100x100 en el centro con relleno #FF5733
```

### 🧠 What the installer does

- [x] Auto-detects language (ES/EN)
- [x] Fixes `npm.ps1 cannot be loaded` (ExecutionPolicy)
- [x] Checks Node.js 20+ (installs via winget if missing)
- [x] Checks Illustrator installation & running process
- [x] Installs `illustrator-mcp-server` (66 tools)
- [x] Backups `opencode.json` → `opencode.backup.json`
- [x] **Migrates** old MCP configs (`mcp.rhino`, `mcp.blender`, etc.) to new format `mcp.servers.*` instead of deleting
- [x] Preserves Rhino-Grasshopper coexistence
- [x] Verifies connection with `opencode mcp list`

### 📦 What you get: 66 tools

- **Read:** structure, layers, colors, fonts, artboard
- **Create:** rectangles, ellipses, paths, text, gradients
- **Edit:** move, scale, rotate, boolean ops
- **Export:** SVG, PNG, PDF
- **Pro:** preflight, design tokens, WCAG

### ⚠️ Notes

- **Illustrator 2020-2023** shows `unverified version v24` warning. It's NORMAL, works 100% via ExtendScript.
- Do NOT upgrade to npm 12 if you use Node 24 (unstable). Stay on 11.x
- Coexists with Rhino MCP (`rhino-mcp-router.exe`)

### 📂 Files

- `install.ps1` / `install-v2-universal.ps1` — Universal installer (recommended)
- `illustrator.md` — Skill definition for OpenCode skills folder
- `notion-page-final.md` — Ready-to-paste Notion documentation

### 🔗 Credits

- MCP Server: [ie3jp/illustrator-mcp-server](https://github.com/ie3jp/illustrator-mcp-server) (MIT, 164 stars)
- Built on Adobe Illustrator ExtendScript API
- Skill + Universal Migrator: [@adasprilla](https://github.com/adasprilla)

### 📄 License

MIT — Feel free to modify, translate and redistribute.

---

### 🌍 Notion

Full tutorial in Notion: Paste the content from `notion-page-final.md`

**Tags:** `opencode` `mcp` `illustrator` `adobe` `rhino` `grasshopper` `automation` `design`
