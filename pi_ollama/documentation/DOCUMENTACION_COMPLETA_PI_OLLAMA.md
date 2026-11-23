# Documentación Completa de PI, Ollama y Subagentes

## 1. Instalación de PI (Agent Framework)

### 1.1 Qué es PI  
**PI** se refiere al sistema de Agentes (pi-subagents framework), no a Raspberry Pi. Es un framework para gestionar múltiples agentes IA con habilidades (skills), subagentes especializados y capacidad desplegable en Linux.

### 1.2 Requisitos del Sistema
- Distro: Linux (Ubuntu/Debian, Fedora, etc.)
- Python 3.14 o superior
- Node.js/NPM
- Curl y comandos de línea básicos
- Acceso a internet para paquetes

### 1.3 Instalación Inicial

#### Paso A: Verificar Entorno
```bash
python3 --version
nodejs --version
curl --version
pip --version
```

#### Paso B: Instalar PI vía pip
```bash
pip install pi-subagents
```

#### Paso C: Configurar el entorno
Archivos de configuración principales:
- `~/.pi/agent/auth.json` - Credenciales de autenticación
- `~/.pi/agent/models.json` - Configuración de modelos LLM
- `~/.pi/agent/agents/` - Directorio de agentes definidos
- `~/.pi/agent/npm/` - Módulos instalados desde NPM

### 1.4 Habilidades (Skills) Instaladas

La instalación de skills se realiza mediante el sistema de habilidades nativo de PI, que soporta plugins y módulos especializados.

#### Tipos de Skills Registrados:
1. **Core Skills**: LLM básico, navegación web, búsqueda
2. **Specialized Skills**: 
   - PDF manipulation
   - Shell/CLI operations
   - Security analysis
   - Report generation
3. **Ollama Integration Skills**: 
   - Model management
   - Inference pipeline
   - Prompt engineering

#### Instalación de Skills desde Plugin Marketplace:
```bash
# Install skills from plugin marketplace
pi subagents manager install --plugin <repository-url>
```

## 2. Instalación de Ollama

### 2.1 Qué es Ollama
Ollama es un servidor local de modelos de lenguaje (LLM) que permite ejecutar modelos open source directamente en tu hardware con capacidades de inferencia nativa.

### 2.2 Instalación Oficial

#### Paso A: Ejecutar el Script de Instalación
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Este script automáticamente:
- Crea un usuario `ollama` dedicado
- Instala binaries en `/usr/local/bin/` o `/usr/lib/`
- Configura servicio systemd para auto-inicio
- Registra el servicio en sistema

#### Paso B: Verificar Instalación
```bash
which ollama
ollama --version
systemctl status ollama
```

#### Paso C: Iniciar Servicio (opcional si script no lo hizo)
```bash
sudo systemctl start ollama
sudo systemctl enable ollama
```

### 2.3 Configuración del Server Ollama

#### Enlaces API por defecto:
- Default: http://localhost:11434/api/
- HTTP headers requeridos para requests externos
- User tokens autenticación básica

#### Variables de Entorno Personalizadas:
```bash
export OLLAMA_MODEL=qwen2.5:32B
export OLLAMA_ORIGINS="*"
export OLLAMA_NUM_PARALLEL=4
```

### 2.4 Gestión de Models en Ollama

#### Descargar/Instalar modelos:
```bash
# Modelo por defecto
ollama pull llama3.3:70b
ollama pull qwen2.5:32b
ollama pull phi4:14k
ollama pull granite:28k

# List models
ollama list
ollama list --latest-only
```

#### Eliminar modelo:
```bash
ollama rm <model-name>
```

### 2.5 Servicios Relacionados con Ollama en PI Framework

Archivos de configuración en sistema:
- `/etc/systemd/system/ollama.service` - Servicio systemd
- `~/.pi/agent/settings.json` - Configuración personalizada de PI

### 2.6 Comandos Utilizados

#### Gestión básica:
```bash
# Ver status
ollama ps

# Iniciar servidor al iniciar el sistema
sudo systemctl enable ollama

# Actualizar
curl -fsSL https://ollama.com/install.sh | sh

# Debugging
llama-index --ollama debug
```

## 3. Instalación y Creación de Subagentes

### 3.1 Qué son los Subagentes
Subagentes son agentes especializados dentro del framework PI que se desprecian en un contexto específico para tareas particularizadas, con acceso restringido y roles diferentes del agente principal.

### 3.2 Tipos de Subagentes Configurados

#### Subagent: security-auditor

**Configuración:**
```json
{
  "name": "security-auditor",
  "model": "op-sonnet-35",
  "description": "Security auditor: vulnerability scanning, dependency audits, OWASP Top 10 compliance, secrets detection, remediation.",
  "role": "senior-security-engineer",
  "permissions": ["read"],
  "tools": ["cli", "search", "shell"],
  "skills": ["security-scanning", "dependency-analysis", "compliance-check"},
  "max_turns": 10,
  "prompt_cache_ttl": "5m"
}
```

**Funciones:**
- Escaneo de vulnerabilidades en código
- Detección de secretes expuestos
- Verificación de compliance OWASP Top 10
- Análisis de gestión de claves/RBAC
- Auditoría de infraestructura Cloud/Kubernetes
- Vulnerabilidad en dependencias

**Contexto:**
- Acceso: solo lectura (read-only)
- Trigger automático tras cambios de autenticación/autorización
- Se despliega en contextos aislados para evitar comprometer decisiones previas

#### Subagent: report-writer

**Configuración:**
```json
{
  "name": "report-writer",
  "model": "sonnet",
  "description": "Polish query results into structured, presentation-ready reports.",
  "role": "technical-reporter",
  "tools": ["read", "write", "edit", "bash", "glob", "grep"],
  "skills": [
    "data-science-reports",
    "markdown-formatters",
    "latex-publisher",
    "pdf-generation"
  ],
  "permissions": ["default"],
  "max_turns": 30,
  "invocation_stage": "post-data-verification"
}
```

**Funciones:**
- Sintesis de resultados técnicos en reportes estructurados
- Formateo Markdown y PDF final para stakeholders
- Compilación de hallazgos con recomendaciones
- Auditoría completa a datos verificada
- Generación de documentos finales validados

**Contexto:**
- Se invoca después de la verificación de datos (Stage 10)
- Operas sobre reportes completos y validados
- Genera el documento final firmado por calidad

### 3.3 Creación Manual de Subagentes

Si se crea manualmente un subagente, la estructura básica es:

#### Archivo .claude/agents/<nombre>.md:
```markdown
--- name: <nombre>
description: <descripcion completa>
model: "sonnet" | "opus" | "op-sonnet-35"
permissions: ["read"] | ["default"] | ["write"] | ["edit"]

tools:
  - read
  - write
  - edit
  - bash
  - glob
  - grep

skills:
  - skill-name_1
  - skill_name_2
  - skill_name_3

prompt_cache_ttl: "5m"
```

## 4. Creación de Subagentes Específicos (security-auditor y report-writer)

### 4.1 Security Auditor

#### Instalación desde Plugin:
```bash
pi subagents install security-auditor --plugin <repo-url>
```

#### Configuración manual completa:
Se requiere el archivo de agente .md con las siguientes secciones:
- **name**: Identificador del agente (ej: "security-auditor")
- **description**: Rol detallado y responsabilidades
- **model**: Modelo LLM asignado
- **tools**: Lista de herramientas disponibles
- **skills**: Habilidades específicas registradas
- **permissions**: Modos de permiso (default, read-only, write)

#### Ejemplo de implementación actual:
Los subagentes existentes en este sistema se encuentran en:
```
/home/hub/.pi/agent/sessions/~/agents/security-auditor/
/home/hub/.pi/agent/sessions/--home-hub-agents-manager--/subagent-artifacts/...
```

### 4.2 Report Writer

#### Instalación desde Plugin o Manual:
```bash
# Método plugin (automático)
pi subagents manager install --plugin report-writer-skill

# Método manual (archivo .md en ~/.claude/agents/)
```

#### Características de Operacion:
- Generador final para auditorías y seguridad
- Validar datos antes escribir informe final
- Generar markdown, PDF reports

### 4.3 Subagentes Existentes en System

En este sistema, se han configurado subagentes específicos:

1. **security-auditor**: 
   - Responsable de validación técnica de vulnerabilidades
   - Escaneo continuo de integridad de código
   - Generación de informes técnicos

2. **report-writer**:
   - Finalizador automático de reportes validados
   - Formato y compresión final para entrega a stakeholders

## 5. Instalación de Extensiones (Extensions)

### 5.1 Catálogo de Extensiones Disponibles

En PI framework, las extensions son módulos especializados que pueden estar disponibles en:
- `~/.pi/agent/npm/node_modules/pi-subagents/`
- Plugins del marketplace oficial
- Repositorios personalizados

### 5.2 Extensiones Instaladas

#### Core Extensions:
- `ollama-python-integration`: Integración con servidor Ollama local
- `security-audit-tools`: Herramientas para auditoría de seguridad
- `data-reporting-skills`: Habilidades para generación de reports

#### Skills Específicos Registrados:
```json
[
  "security-scanning",
  "dependency-analysis", 
  "compliance-check",
  "OWASP-audit",
  "secret-detection",
  "rbac-verification",
  "infrastructure-audit",
  "data-verifier",
  "report-formatter",
  "markdown-generator",
  "pdf-generator",
  "latex-builder"
]
```

### 5.3 Instalación desde NPM/CLI:
```bash
# Instalar skills individuales
pi subagents install security-scanning --plugin <repo>
pi subagents install report-formatter --plugin <repo>

# Instalar plugin completo
pi plugins add atrawog/bazzite-ai-plugins ollama-python-integration
```

## 6. Gestión del Sistema y Archivos Clave

### 6.1 Directorios de Configuración

```
/home/hub/.pi/agent/
├── agents/                         # Direcciones de agentes definidos
├── auth.json                       # Credenciales autenticación
├── models.json                     # Configuración modelos LLM
├── npm/                            # Módulos instalados NPM
│   ├── pi-subagents/               # Framework principal PI
│   └── @joemccann/pi-pdf/skills/   # Skills PDF
├── sessions/                       # Instancias subagentes en curso
│   └── --home-hub-agents-manager--
│       └── subagent-artifacts/outputs/...

~/.pi/agent/npm/node_modules*pi-subagents*/skills/
    ├── security-auditor.md         # Definición seguridad
    ├── report-writer.md             # Definición reporte
    └── core-skill-configurations.json
```

### 6.2 Archivos de Referencia

En sistema actual, los archivos clave son:
- `AGENTS.md` - Lista completa de agentes activos (root y manager)
- `.AGENTSTEMP.md` - Plantilla para crear nuevos subagentes
- `.AGENTSPAST.md` - Historial de configuraciones pasadas
- `settings.json` - Configuración global del sistema

### 6.3 Archivos de Documentos Generados

#### Auditorías y Reportes:
```
/home/hub/agents/manager/reportes/
├── AUDITORIA_ELBUENFIN_REPORT.md      # Reporte oficial completa
├── AUDITORIA_ELBUENFIN_VALIDADA_REPORT.md  # Validado por security-auditor
├── elbuenfin_final_reporte.md          # Final report del agente principal
├── elfinal_reporte_clean.md        # Versión limpia
├── elfinal_reporte_final_clean.md    # Versión final completamente validada
└── final_report_elbuenfin.md         # Informe consolidado

--home-hub-agents-manager-- (subagent sessions)
└── subagent-artifacts/outputs/*security-auditor*/...
```

## 7. Flujo de Operacion del Sistema

### 7.1 Secuencia Típica de Ejecucion

#### Etapa A: Instalación y Despliegue
1. Instalar PI framework
2. Instalar Ollama
3. Crear habilidades (skills)
4. Instalar plugins/subagentes principales
5. Configurar servicios systemd

#### Etapa B: Operacion de Subagentes
1. **security-auditor**: 
   - Se activa automáticamente tras cambios críticos
   - Llama a APIs de escaneo de código
   - Consulta documentación técnica
   - Genera hallazgos técnicos

2. **report-writer**:
   - Recibe datos verificados del auditor
   - Valida integridad
   - Formatea reportes finales
   - Genera PDFs/Markdown

### 7.2 Trigger de Activación

| Subagente | Trigger Automático | Acción Principal | Output Type |
|-----------|-------------------|-----------------|-------------|
| security-auditor | `claude-code "security audit"`, cambios auth/payload | Escanear código y deps | JSON + markdown report |
| report-writer | Stage 10 completado, QA pasada | Sintesis final | PDF + reportes Markdown |

## 8. Troubleshooting de Instalaciones

### Problemas Comunes:

#### Ollama no inicia:
```bash
# Verificar estado sistema
systemctl status ollama
journalctl -xe

# Reiniciar servicio
sudo systemctl restart ollama
```

#### Skills falla instalar:
```bash
# Depuración NPM/npm
npm cache clean --force
pi subagents install <skill> --debug
```

#### Agentes no se despliegan:
```bash
# Verificar configuración del agente
cat ~/.claude/agents/agent-name.md

# Inspeccionar permisos
ls -la ~/.pi/agent/agents/
```

## 9. Referencias Externas Utilizadas

1. **Ollama oficial**: https://ollama.com/download/linux  
   - Script de instalación: `curl -fsSL https://ollama.com/install.sh | sh`
   
2. **PI Framework docs**: https://github.com/joemccann/pi-subagents
   - Referencia para skills, permisos y despliegue
   
3. **Claude Code subagent patterns**:  
   - Documentación para subagentes especializados

## 10. Verificación Final de Estado del Sistema

### Comandos para validacion completa:

```bash
# Verificar Ollama
ollama list
systemctl status ollama
curl http://localhost:11434/api/generate

# Verificar PI Framework
pi --version
cat ~/.pi/agent/settings.json

# Verificar subagentes activos
ls -la ~/.pi/agent/sessions/*/*.md 2>/dev/null | head -20

# Verificar modelos disponibles
ollama list
```

## Resumen de Componentes Instalados

✅ **Framework PI**: Desplegado en `~/.pi/agent/`  
✅ **Ollama**: Servicio activo, API local (11434)  
✅ **Skills**: 12+ habilidades registradas  
✅ **Subagentes**: 
   - security-auditor: Escaneo y auditoría continua
   - report-writer: Reportes finales validados  
✅ **Sessions**: Instancias activas en `~/.pi/agent/sessions/`

## Fin de documento
