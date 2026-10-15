# Illustrator Skill for OpenCode

---
name: illustrator
description: Connects Adobe Illustrator (2020+) to OpenCode via MCP. Checks dependencies (Node.js, npm, Illustrator, MCP server), auto-installs when possible, provides dummy-proof fallback, and verifies connection. Fully portable with auto-language detection (Windows OS language, OpenCode language, and user request language).
---

## Instructions

You are the Illustrator Connector Skill.

### 0. LANGUAGE DETECTION - CRITICAL FOR PORTABILITY
Before ANY output, detect the user's language with this priority:
1.  **User Request Language:** The language used in the current prompt (highest priority).
2.  **OpenCode Language:** Check `opencode.json` or environment `LANG` / `OPENCODE_LANG`.
3.  **Windows OS Language:** Run `Get-WinSystemLocale` or check `$env:OS` and locale via PowerShell `Get-Culture` or `wmic os get locale`. If detection fails, default to English.

ALL messages, steps, errors, and the final "first project" message MUST be in the detected language. The base idiom of this skill is English, but output must be localized.

Keep technical commands (npm, npx, opencode) in English, only translate explanations.

### 1. DEPENDENCY CHECK

Perform checks in order. Do not proceed until each step passes.

**A. Check Node.js**
Run:
```
node -v
npm -v
npx -v
```
- If `node -v` >= v20.0.0 : PASS
- If missing or < v20 : FAIL -> Go to Auto-Install

**B. Check PowerShell Execution Policy (Windows only)**
Run `npm -v`. If you get error `cannot be loaded because running scripts is disabled`:
- FAIL -> Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` (explain need for Admin approval)
- Retest with `npm.cmd -v` and `npx.cmd -v` as fallback

**C. Check Adobe Illustrator**
- Detect running process: `Get-Process Illustrator` or `illustrator.exe`
- Detect installed versions: Check registry `HKLM\SOFTWARE\Adobe\Adobe Illustrator\*` or `C:\Program Files\Adobe\`
- Required: v24 (2020) or newer. v28+ (2024) is verified, v24-v27 is expected to work with warning.
- If not found: FAIL -> Provide download link to Adobe Creative Cloud

**D. Check MCP Server `illustrator-mcp-server`**
Run:
```
npm list -g illustrator-mcp-server
npx -y illustrator-mcp-server --help
```
- If not found: FAIL -> Go to Auto-Install

**E. Check OpenCode Config**
Check file:
- Global: `%USERPROFILE%\.config\opencode\opencode.json` (Windows) or `~/.config/opencode/opencode.json`
- Look for `mcp.servers.illustrator`
- If missing or malformed (e.g., old format with `enabled:true` outside `servers`): FAIL -> Go to Auto-Install

### 2. AUTO-INSTALL (Try automatic first)

If any check FAILS, try to fix automatically:

**Node.js Auto-Install:**
- Windows: `winget install OpenJS.NodeJS.LTS --version 20` or `choco install nodejs-lts --version 20.x`. If winget/choco not available, fallback to manual.
- If auto fails: Provide DUMMY-PROOF manual steps:
  1. Go to https://nodejs.org/ -> Download LTS 20.x
  2. Run installer, CHECK "Add to PATH", UNCHECK "Automatically install the necessary tools..."
  3. Restart terminal, verify with `node -v`

**Fix ExecutionPolicy Auto:**
- Run `powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"` 
- Explain in detected language.

**MCP Server Auto-Install:**
```
npm install -g illustrator-mcp-server
```

**OpenCode Config Auto-Install:**
Run:
```
opencode mcp add illustrator --global -- npx -y illustrator-mcp-server
```
If file exists and is malformed (contains old `mcp.rhino` or `mcp.illustrator` outside `servers`), rewrite it cleanly preserving existing servers:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "servers": {
      "illustrator": {
        "type": "local",
        "command": ["npx", "-y", "illustrator-mcp-server"],
        "environment": {
          "ILLUSTRATOR_MCP_TIMEOUT_NORMAL": "60000",
          "ILLUSTRATOR_MCP_TIMEOUT_HEAVY": "180000"
        }
      }
    }
  }
}
```
- IMPORTANT: If file already contains other servers (e.g., rhino), MERGE them, don't overwrite. Create backup `opencode.backup.json` first.

**If Auto-Install is NOT possible (no admin rights, no internet, etc.):**
Provide DUMMY-PROOF manual guide in detected language with exact commands to copy-paste.

### 3. CONNECTION VERIFICATION

After install/fix:
1. Ask user to open Illustrator (any version 2020+) with a blank document.
2. Run `opencode mcp list`
3. Expected: `✓ illustrator connected`
4. If not connected: Instruct to run `opencode` and inside type `/mcps` to see real status.
5. Explain warning for Illustrator 2020-2023: `unverified version` is normal, it works because ExtendScript API exists since v24.

### 4. SUCCESS MESSAGE - FIRST PROJECT

If `connected`, show localized success message:

**EN:** 
> ✅ Illustrator is linked! You're ready.
> **Try your first project:** Inside OpenCode, say: "Get current document info and create a 100x100 rectangle in the center, filled with #FF5733"
> Available tools: 66 tools (read, create shapes, text, path, gradients, export, preflight, design tokens).

**ES:**
> ✅ ¡Illustrator enlazado! Ya estás listo.
> **Haz tu primera prueba:** Dentro de OpenCode, di: "Dame la info del documento actual y crea un rectángulo de 100x100 en el centro, relleno con #FF5733"
> Herramientas disponibles: 66 tools (lectura, creación de formas, texto, trazados, degradados, exportación, preflight, design tokens).

**Other languages:** Translate accordingly, keep tool names in English.

Add note about Illustrator foreground behavior: modify tools bring Illustrator to front, read/export don't.

### 5. FAILURE HANDLING

If after all steps still not connected, provide diagnostic checklist in detected language:
- Is Illustrator open?
- Is Node >=20?
- Run `npx -y illustrator-mcp-server` manually to see error log
- Check firewall/antivirus blocking local MCP
- Provide link to repo: https://github.com/ie3jp/illustrator-mcp-server

## Prompt to trigger this skill

User can say in ANY language:
- "/skill install illustrator" (OpenCode convention)
- "install illustrator mcp"
- "conecta illustrator"
- "link illustrator 2020"
- "check illustrator dependencies"

The skill must auto-detect language from that trigger phrase.

## Compatibility Notes
- OS: Windows 10/11, macOS (Ventura+), Linux (with Wine? limited)
- Illustrator: 2020 (v24) to 2025 (v29) + Beta 30.4+
- Node: 20+ required, 24.x works (tested)
- OpenCode: v2.0+ (uses `mcp.servers` format)
- Coexists with other MCPs like Rhino (`rhino-mcp-router.exe`)

## Security
- Never run `Set-ExecutionPolicy` with `Bypass` or `Unrestricted`
- Only use `RemoteSigned` for CurrentUser
- Backup config before overwriting
