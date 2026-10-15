# 🎨 Illustrator 2020-2025 + OpenCode — En 1 Comando

> Conecta Illustrator estable (no Beta) a OpenCode con IA. Funciona en Illustrator 2020, 2021, 2022, 2023, 2024, 2025.

---

### 🚀 Instalación Rápida (Para Dummies)

**1. Abre PowerShell**

Pulsa `Windows + R`, escribe `powershell`, Enter.

**2. Copia y pega esto:**

```powershell
irm https://raw.githubusercontent.com/TU-USUARIO/opencode-illustrator/main/install.ps1 | iex
```

> Si te pide permiso, escribe `S` y Enter.

**3. Abre Illustrator con un documento en blanco**

**4. Corre:**

```powershell
opencode
```

Y dentro escribe:

```
/mcps
```

Debe salir:

```
✓ illustrator  connected
✓ rhino        connected (si usas Rhino)
```

**5. Tu primera prueba:**

```
Dame la info del documento actual y crea un rectángulo de 100x100 en el centro con relleno #FF5733
```

¡Listo!

---

### 🧠 Qué hace el instalador automáticamente

- [x] Detecta tu idioma (ES/EN) y te habla en tu idioma
- [x] Revisa PowerShell ExecutionPolicy (arregla el error `npm.ps1 cannot be loaded`)
- [x] Revisa Node.js 20+ (si no está, lo instala con winget)
- [x] Revisa si Illustrator está instalado y corriendo
- [x] Instala `illustrator-mcp-server` (66 herramientas)
- [x] Hace backup de tu `opencode.json` → `opencode.backup.json`
- [x] Arregla configuraciones viejas (`mcp.rhino` con `enabled:true`)
- [x] Enlaza Illustrator preservando Rhino-Grasshopper
- [x] Verifica conexión

No necesitas ser programador.

---

### 📦 Qué obtienes: 66 herramientas

- Leer: estructura, capas, colores, tipografías, mesa de trabajo
- Crear: rectángulos, elipses, trazados, texto, degradados
- Editar: mover, escalar, rotar, booleans
- Exportar: SVG, PNG, PDF
- Pro: preflight, tokens de diseño, WCAG

---

### ⚠️ Notas

- **Illustrator 2020-2023:** Verás `unverified version v24`. Es NORMAL. Funciona 100% porque usa ExtendScript desde v24.
- **No actualices a npm 12** si usas Node 24, tiene bugs. Quédate en 11.19.1
- **Coexiste con Rhino:** El instalador no borra tu config de Rhino, la fusiona.

---

### 🔗 Instalación manual (si el comando falla)

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
npm install -g illustrator-mcp-server
opencode mcp add illustrator --global -- npx -y illustrator-mcp-server
opencode mcp list
```

---

### 🛠️ Créditos

- MCP Server: [ie3jp/illustrator-mcp-server](https://github.com/ie3jp/illustrator-mcp-server) (MIT)
- Skill portable + instalador: Tu nombre aquí
- Compatible: OpenCode v2+, Illustrator v24+

---

### 📄 Licencia

MIT

#opencode #illustrator #mcp #adobe #rhino #grasshopper #automation #design
