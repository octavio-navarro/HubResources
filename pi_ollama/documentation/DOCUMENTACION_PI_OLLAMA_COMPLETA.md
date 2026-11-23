# 🤖 DOCUMENTACIÓN COMPLETA: PI + OLLAMA Y AGENTES MULTIAGENTES

## 📚 ÍNDICE DE CONTENIDOS

1. [Visión General del Sistema](#1-visión-general-del-sistema)
2. [Instalación de PI y Ollama](#2-instalación-de-pi-y-ollama)
   - [2.1 Requisitos del Sistema](#21-requisitos-del-sistema)
   - [2.2 Instalación de PI Framework](#22-instalación-de-pi-framework)
   - [2.3 Instalación y Configuración de Ollama](#23-instalación-y-configuración-de-ollama)
   - [2.4 Configuración Global del Sistema](#24-configuración-global-del-sistema)
3. [Arquitectura Multiagente](#3-arquitectura-multiagente)
   - [3.1 Conceptos Básicos](#31-conceptos-básicos)
   - [3.2 Agentes Preestablecidos (Built-in)](#32-agentes-preestablecidos-built-in)
   - [3.3 Agentes Generados por Usuario](#33-agentes-generados-por-usuario)
   - [3.4 Orquestación Automática del Manager](#34-orquestación-automática-del-manager)
4. [Habilidades (Skills) y Extensiones](#4-habilidades-skills-y-extensiones)
   - [4.1 Skills Core Instaladas](#41 skills-core-instaladas)
   - [4.2 Skills Especializadas](#42-skills-especializadas)
   - [4.3 Extensiones y Plugins](#43-extensiones-y-plugins)
5. [Gestión de Agentes](#5-gestión-de-agentes)
   - [5.1 Estructura de Directorios](#51-estructura-de-directorios)
   - [5.2 Configuración de Agentes](#52-configuración-de-agentes)
   - [5.3 Creación de Nuevos Agentes](#53-creación-de-nuevos-agentes)
6. [Prompts del Manager](#6-prompts-del-manager)
7. [Operación y Uso Diario](#7-operación-y-uso-diario)
   - [7.1 Inicio del Sistema](#71-inicio-del-sistema)
   - [7.2 Ejecución de Tareas](#72-ejecución-de-tareas)
   - [7.3 Monitoreo y Diagnóstico](#73-monitoreo-y-diagnóstico)
8. [Seguridad y Restricciones](#8-seguridad-y-restricciones)
9. [Troubleshooting](#9-troubleshooting)
10. [Referencias y Recursos](#10-referencias-y-recursos)

---

## 1. VISIÓN GENERAL DEL SISTEMA

### ¿Qué es este Sistema?

Este sistema de **PI + Ollama** es una infraestructura local de inteligencia artificial que permite:

- ✅ **Ejecutar modelos de lenguaje (LLMs)** localmente mediante Ollama
- ✅ **Gestionar múltiples agentes especializados** mediante el framework PI
- ✅ **Delegar tareas automáticamente** entre agentes según su especialización
- ✅ **Generar reportes técnicos** y documentar hallazgos
- ✅ **Auditar seguridad** con subagentes especializados
- ✅ **Escalar operaciones** mediante arquitectura multiagente

### Componentes Principales

| Componente | Función | Ubicación |
|------------|---------|-----------|
| **PI Framework** | Orquestación de agentes y gestión de skills | `~/.pi/agent/` |
| **Ollama Server** | Inferencia local de LLMs | `/usr/lib/ollama` |
| **Manager Agent** | Orquestador central de todas las tareas | `~/agents/manager/` |
| **Subagentes** | Especialistas en tareas específicas | `~/.pi/agent/sessions/` |
| **Skills** | Habilidades especializadas del sistema | NPM Packages |

### Hardware Actual

```markdown
- Sistema Operativo: Fedora Linux
- Usuario: hub
- GPU Principal: NVIDIA RTX A4500 (19.6 GiB VRAM)
- GPU Integrada: Intel Graphics RPL-S
- Modelo LLM: Qwen3.5:4b
- Framework PI: 0.89.1
- API Ollama: localhost:11434
```

---

## 2. INSTALACIÓN DE PI Y OLLAMA

### 2.1 Requisitos del Sistema

#### Software Mínimo Requerido

| Componente | Versión Mínima | Notas |
|------------|---------------|-------|
| Python | 3.12+ | Revisar `~/.pi/agent/packages.json` |
| Node.js/npm | 18+ | Para NPM y skills |
| curl | - | Para instalaciones automáticas |
| pip | Latest | Para dependencias de PI |
| ffmpeg | Optional | Para procesamiento multimodal |
| Chrome/Chromium | Latest | Requerido por agent_browser |
| jq | Latest | Utilidad JSON para gestión |

#### Hardware Recomendado

- **RAM**: 16 GB mínimo, 32 GB recomendado
- **GPU**: NVIDIA CUDA compatible (RTX serie A o T)
- **Almacenamiento**: NVMe con al menos 100GB libres

### 2.2 Instalación de PI Framework

#### Método 1: Instalar desde PyPI (Recomendado)

```bash
# Verificar entorno
python3 --version
nodejs --version
curl --version

# Instalar PI desde pip
pip install pi-subagents

# Verificar instalación exitosa
pi --version
```

#### Método 2: Instalación Manual del Framework

```bash
# Crear directorio .pi si no existe
mkdir -p ~/.pi/agent

# Clonar repositorio oficial (opcional)
git clone https://github.com/joemccann/pi-subagents.git ~/.pi/agent/repo

# Instalar dependencias NPM
cd ~/.pi/agent/
npm install pi-subagents @joemccann/pi-pdf pi-web-access pi-agent-browser-native
```

#### Configuración Pos-instalación

Después de instalar PI, configurar los archivos importantes:

```bash
# Crear credenciales de autenticación (primera vez)
touch ~/.pi/agent/auth.json

# Configurar modelos por defecto
touch ~/.pi/agent/models.json

# Crear directorio de agentes
mkdir -p ~/.pi/agent/agents
echo "{}" > ~/.pi/agent/agents/.gitkeep

# Establecer permisos adecuados
chmod 600 ~/.pi/agent/auth.json
chown $USER:~/.pi/agent/auth.json
```

### 2.3 Instalación y Configuración de Ollama

#### Paso A: Script Automático de Instalación

```bash
# Ejecutar script oficial (requiere sudo)
curl -fsSL https://ollama.com/install.sh | sh

# Verificar instalación exitosa
which ollama
ollama --version

# Iniciar servicio systemd
sudo systemctl start ollama
sudo systemctl enable ollama
```

#### Paso B: Configuración del Servidor Ollama

Configuración opcional en `/etc/systemd/system/ollama.service`:

```ini
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
Environment="OLLAMA_CONTEXT_LENGTH=16384"
Environment="OLLAMA_NUM_PARALLEL=4"
Environment="OLLAMA_KEEP_ALIVE=24h"
Environment="PATH=/home/hub/.local/bin:/home/hub/bin:/usr/local/bin:/usr/bin:/usr/local/cuda-*/bin"
```

#### Paso C: Descarga de Modelos

Comandos básicos y modelado:

```bash
# Listar modelos disponibles
ollama list || ollama list --latest-only

# Descargar modelo por defecto
ollama pull qwen2.5:32b

# Modelos recomendados para diferentes tareas
ollama pull llama3.3:70b    # General prop
ollama pull gemma2:9b       # Español nativo
ollama pull phi4:14k        # Código y lógica razonamiento
ollama pull mistral-small   # Análisis de text

# Verificar modelo en GPU
ollama run qwen2.5:32b "Hola, prueba de GPU"

# Eliminar modelo (si es necesario)
ollama rm <modelo-nombre>

# Estado de inferencia
ollama ps

# Inspección completa del modelo
ollama show --parameters qwen2.5:32b
```

### 2.4 Configuración Global del Sistema

#### Estructura de Archivos de Configuración

```
~/.pi/agent/                    # Root del framework PI
├── auth.json                   # Credenciales y autenticación
├── models.json                 # Modelos LLM configurados
├── settings.json               # Configuración global
├── agents/                     # Definiiones de agentes
│   ├── security-auditor.md     # Agente de auditoría
│   ├── report-writer.md        # Generador de informes
│   └── [otros-agentes].md      # Agentes personalizados
├── npm/                        # NPM packages instalados
│   └── pi-subagents/           # Framework principal
└── sessions/                   # Instancias subagent en curso

~/agents/                       # Directorio raíz de agentes
├── manager/                    # Orquestador central
│   ├── AGENTS.md              # Lista completa de todos los agentes
│   ├── .AGENTSPAST.md         # Histórico de configuraciones
│   ├── .AGENTSTEMP.md         # Plantilla para nuevos subagentes
│   └── reportes/              # Directorio de reportes generados

/home/hub/hola                 # PROMPTS DEL MANAGER (CRÍTICO)
└── [prompts-manager].md       # Pormpts y instrucciones del manager agent

~/agents/manager/AGENTS.md     # Registro central de agentes activos
```

#### Script de Configuración Rápida

Añadido para facilitar la puesta en marcha:

```bash
#!/bin/bash
# setup_pi_ollama.sh - Script de instalación rápida

set -e  # Terminar en error

echo "=== Configuración de PI + Ollama ==="

# Verificar Python
if ! python3 --version | grep -q "Python 3.12"; then
    echo "Error: Se requiere Python 3.12+"
    exit 1
fi

# Instalar pip si no está
if ! command -v pip3 &> /dev/null; then
    python3 -m ensurepip --upgrade
fi

# Instalar PI Framework
echo "Instalando PI Framework..."
pip install pi-subagents @joemccann/pi-pdf

# Instalar Ollama (requiere sudo)
if ! command -v ollama &> /dev/null; then
    echo "Instalando Ollama..."
    sudo curl -fsSL https://ollama.com/install.sh | sh
fi

# Descargar modelo
echo "Descargando modelo predeterminado..."
ollama pull qwen2.5:32b

# Configurar directorios
mkdir -p ~/.pi/agent/agents ~/.pi/agent/npm
touch ~/.pi/agent/auth.json ~/.pi/agent/models.json ~/.pi/agent/settings.json

echo "=== Instalación completada ==="
echo "Modelos disponibles:"
ollama list

echo "Comando PI ejecutable:"
which pi || echo "Nota: Verificar que .pi está en PATH"
```

---

## 3. ARQUITECTURA MULTIAGENTE

### 3.1 Conceptos Básicos

#### ¿Qué son los Agentes?

Los **agentes** son entidades de procesamiento autónomo dentro del framework PI, especializados en tareas específicas. Cada agente:

- Tiene una identidad única (nombre)
- Posee capacidades especializadas (tools y skills)
- Opera bajo un rol definido
- Puede ser invocado automáticamente u manualmente

#### Tipos de Agentes

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **Manager** | Orquestador central, asigna tareas a subagentes específicos | `/home/hub/agents/manager` |
| **Subagent** | Agentes especializados para tareas específicas | `security-auditor`, `report-writer` |
| **Built-in** | Agentes preinstalados por el framework | scout, researcher, worker |
| **Custom** | Agentes creados manualmente por usuarios | `mi-super-analista.md` |

#### Flujo de Orquestación

1. **Recepción de tarea**: El usuario envía una solicitud al Manager
2. **Análisis de delegación**: El Manager evalúa si requiere subagent especializada
3. **Selección automática**: Se elige el subagente adecuado según la categoría de tarea
4. **Ejecución**: Subagente realiza la obra y devuelve resultados
5. **Redacción**: report-writer consolida e informa del resultado final

### 3.2 Agentes Preestablecidos (Built-in)

Estos agentes vienen preconfigurados en el sistema y son esenciales para operaciones estándar:

#### 🔐 security-auditor

**Descripción:**
Subagente especializado en auditoría de seguridad, escaneo de vulnerabilidades y cumplimiento de compliance OWASP Top 10.

**Configuración JSON:**
```json
{
  "name": "security-auditor",
  "model": "op-sonnet-35",
  "description": "Security auditor: vulnerability scanning, dependency audits, OWASP Top 10 compliance, secrets detection, remediation.",
  "role": "senior-security-engineer",
  "permissions": ["read"],
  "tools": ["cli", "search", "shell"],
  "skills": [
    "security-scanning", 
    "dependency-analysis", 
    "compliance-check"
  ],
  "max_turns": 10,
  "prompt_cache_ttl": "5m"
}
```

**Funciones Principales:**
- ✅ Escaneo de vulnerabilidades en código y dependencias
- ✅ Detección de secrets expuestos (API keys, credenciales)
- ✅ Verificación de compliance OWASP Top 10
- ✅ Análisis de gestión de claves y RBAC
- ✅ Auditoría de infraestructura Cloud/Kubernetes
- ✅ Identificación de vulnerabilidades en dependencias

**Contexto de Uso:**
- Acceso: SOLO LECTURA (read-only) para seguridad máxima
- Trigger: Automático tras cambios de autenticación/autorización
- Se despliega siempre en contextos aislados por seguridad

**Invocación Típica:**
```python
subagent(
    agent="security-auditor",
    task="Auditar directorio ~/proyecto/web/frontend buscando vulnerabilidades SQL injection, XSS y secretos expuestos.",
    cwd="/ruta/a/proyecto"
)
```

**Output:**
Markdown con hallazgos de seguridad:

- Resumen ejecutivo de riesgos encontrados
- Lista detallada de cada vulnerabilidad
- Nivel de criticidad (Critical/High/Medium/Low)
- Evidencia técnica verificable
- Recomendaciones específicas por hallazgo

---

#### 📝 report-writer

**Descripción:**
Subagente especializado en generación de informes estructurados y presentaciones de resultados técnicos.

**Configuración JSON:**
```json
{
  "name": "report-writer",
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

**Funciones Principales:**
- ✅ Síntesis de resultados técnicos en reportes estructurados
- ✅ Formateo Markdown y PDF para stakeholders
- ✅ Compilación de hallazgos con recomendaciones
- ✅ Auditoría completa a datos verificada
- ✅ Generación de documentos finales validados

**Contexto de Uso:**
- Se invoca después de la verificación de datos (Stage 10)
- Opera sobre reportes completos y validados
- Genera el documento final firmado por calidad

**Invocación Típica:**
```python
subagent(
    agent="report-writer",
    task="Generar informe técnico completo basado en los resultados de security-auditor: [resultados_del_auditor]",
    evidencia="[resultados_de_audit]"
)
```

**Output:**
Documento Markdown profesional con:

- Resumen ejecutivo ejecutivo
- Alcance y metodología
- Hallazgos detallados categorizados
- Evidencias verificables por hallazgo
- Clasificación de criticidad (CRITICAL/SEVERE/MEDIUM/LOW/INFORMATIONAL)
- Impacto técnico y empresarial
- Recomendaciones específicas y ordenadas
- Limitaciones de la auditoría/reporte
- Conclusiones y acciones inmediatas

---

#### 🔍 scout (Pre-instalado)

**Descripción:**
Agente especializado en reconocimiento inicial, análisis estructural y mapeo del entorno.

**Funciones:**
- Reconocimiento de contenido/directorio
- Análisis estructural inicial
- Mapeo de archivos y permisos
- Identificación de tecnologías detectables

---

#### 📚 researcher (Pre-instalado)

**Descripción:**
Agente especializado en investigación técnica, documentación y búsqueda de información.

**Funciones:**
- Investigación técnica profunda
- Documentación de código y proyectos
- Búsqueda de mejores prácticas
- Análisis contextual de problemas

---

#### 🔨 worker (Pre-instalado)

**Descripción:**
Agente especializado en implementación y ejecución de tareas técnicas.

**Funciones:**
- Creación de archivos desde cero
- Modificación de código existente
- Ejecución de scripts y comandos
- Implementación de funcionalidades

---

#### ✨ reviewer (Pre-instalado)

**Descripción:**
Agente especializado en revisión independiente, evaluación de calidad y verificación de resultados.

**Funciones:**
- Revisión de código antes del commit
- Evaluación de calidad técnica
- Verificación de seguridad básica
- Validación de outputs

---

#### 🎯 oracle (Pre-instalado)

**Descripción:**
Agente especializado en evaluación decisoria y toma de decisiones complejas.

**Funciones:**
- Toma de decisiones multicriterio
- Evaluación de trade-offs técnicos
- Análisis de viabilidad
- Recomendación de arquitecturas

---

### 3.3 Agentes Generados por Usuario

Los usuarios pueden crear sus propios agentes personalizados para tareas específicas:

#### Estructura de Archivos de Agentes Personalizados

```markdown
~/.pi/agent/agents/
├── mi-analista.py                     # Agente personalizado Python
├── my-super-architect.md              # Agente arquitectura personalizado
└── data-science-expert.md             # Agente ciencia de datos
```

#### Plantilla Base para Nuevo Agente

```markdown
--- name: nombre-del-agente
description: Descripción detallada completa del rol y responsabilidades
model: "sonnet" | "opus" | "op-sonnet-35"  # Opcional, si usa default omitir
permissions: ["read"] | ["default"] | ["write"] | ["edit"]

tools:
  - read                    # Leer archivos
  - write                   # Escribir archivos
  - edit                    # Editar archivos (merge operations)
  - bash                    # Comandos de shell
  - glob                    # Encontrar archivos por patrón
  - grep                    # Búsqueda en archivo con expresiones regulares

skills:
  - skill-name_1            # Nombre de habilidad específica
  - skill_name_2
  - skill_name_3

prompt_cache_ttl: "5m"     # Cache de prompt (recomendado 5 minutos)
```

#### Ejemplo de Agente Creado por Usuario - Data Analyst

```markdown
--- name: data-analyst-custom
description: Analista de datos especializado en procesamiento ETL, análisis estadístico y visualización de datos. Capacidades para trabajar con CSVs, JSON, tablas SQL bases y generar gráficos y dashboards interactivos usando herramientas como matplotlib, seaborn o librerías similares.

model: "op-sonnet-35"
permissions: ["default"]

tools:
  - read
  - write
  - bash
  - edit
  - glob
  - grep

skills:
  - data-transform
  - statistical-analysis
  - csv-parsing
  - json-processing
  - visualizations
  - dashboarding

prompt_cache_ttl: "10m"
```

#### Guardar y Activar Agente Personalizado

Después de crear el archivo `.md` en `~/.pi/agent/agents/`:

```bash
# Verificar que los agentes están disponibles
ls ~/.pi/agent/agents/*.md

# Reiniciar PI para cargarn nuevos agentes
fi restart pi-daemon || echo "Nota: Verificar daemon actual"

# Testear funcionamiento del nuevo agente
subagent(agent="nombre-del-agente", task="<tarea de test>")
```

---

### 3.4 Orquestación Automática del Manager

#### Principio Fundamental de Orquestación Automática

El **Manager** es responsable de coordinar el sistema multiagente mediante orquestación automática, garantizando que todas las operaciones respeten las instrucciones del usuario y deleguen correctamente a los subagentes especializados.

#### Antes de Ejecutar Cualquier Solicitud, el Manager Evalúa AUTOMÁTICAMENTE:

1. El tipo de tarea solicitada por el usuario
2. Las capacidades especializadas apropiadas para la categoría de tarea
3. Si delegación automática es necesaria (SI, siempre se requiere delegación)

#### Directrices Fundamentales del Manager

- **LA AUSENCIA DE RESTRICCIONES EXPLÍCITAS NUNCA DEBE INTERPRETARSE COMO AUTORIZACIÓN** explícita para explorar, modificar o acceder libremente al sistema
- El **Manager debe trabajar bajo el principio de mínimo privilegio** y alcance limitado
- 🚨 **LA SELECCIÓN DE AGENTES ES RESPONSABILIDAD EXCLUSIVA Y AUTOMÁTICA DEL MANAGER** (no depende del usuario)
- Si no se encuentra un agente adecuado, el manager debe ejecutar la tarea automáticamente

#### Principios Fundamentales de Orquestación

1. **Mínimo Privilegio**: Solo acceder lo necesario para completar la tarea
2. **Delegación Obligatoria**: Cualquier tarea que requiera capacidades especializadas DEBE delegar a subagente
3. **Escop Limitado**: Trabajar dentro del alcance autorizado por el usuario
4. **No Simulación**: Reportar si una herramienta o agente no está disponible; NO simular ejecuciones

#### Matriz de Capacidades para Orquestación Automática

| **TASK SOLICITAD POR EL USUARIO** | **AGENTE AUTOMÁTICO A SELECCIONAR** | **CAPACIDAD REQUERIDA**          |
|------------------------------------|--------------------------------------|----------------------------------|
| Analizar estructura                | `scout`                              | Reconocimiento estructural       |
| Investigar contenido               | `researcher`                         | Documentación técnica            |
| Implementar funcionalidades        | `worker`                             | Ejecución de tareas              |
| Revisar código                     | `reviewer`                           | Evaluación de calidad            |
| Evaluar opciones                   | `oracle`                             | Toma de decisiones               |
| Auditar seguridad                  | `security-auditor`                  | Auditoría y vulnerabilidades     |

#### Procedimiento Obligatoria de Delegación Automática

```python
# El manager DEBE usar esta estructura para cualquier tarea especializad

subagent(
    agent="<nombre-del-agente>",
    task="<descripción precisa>",
    cwd="/ruta/apropiada",
    evidence="<evidencias si aplica>"
)

# No se permite pasarle al usuario la decisión de seleccionar el agente
# El manager es SOLO ORQUESTADOR, no ejecutor personal de tareas especializadas
```

#### Consecuencias de Desviarse de las Políticas de Orquestación:

- ⚠️ Si simula ejecuciones: El resultado será incorrecto y poco útil
- ⚠️ Si realiza manualment tareas delegadas: Pierde utilidad del multiagente
- ⚠️ Si ignora subagentes especializados: Pierde calidad y seguridad
- ❌ **NO AFIRMAR** haber delegado si no existe invocación real

---

## 4. HABILIDADES (SKILLS) Y EXTENSIONES

### 4.1 Skills Core Instaladas

Las habilidades nucleares de PI para operaciones estándar:

#### Catálogo Completo de Skills Registradas

```python
skills_registeradas = [
    # === SKILLS CORE ===
    "llm-basic",                    # LLM básico y razonamiento general
    "web-navigation",               # Navegación web básica
    "search-engine",                # Búsqueda en motores
    
    # === PDF OPERATION ===
    "pdf-extract",                  # Extracción de texto PDF
    "pdf-to-image",                 # Conversión a imágenes PNG/JPG
    "pdf-fill-form",                # Llenado de formularios PDF
    "pdf-merge",                    # Combinación de PDFs
    
    # === SHELL/CLI OPERATIONS ===
    "cli-execute",                  # Ejecución de comandos CLI
    "file-manipulation",            # Manipulación básica de archivos
    "process-monitoring",           # Monitoreo de procesos
    "system-query",                 # Consulta de sistema operativo
    
    # === ANALYSIS ===
    "grep-search",                  # Búsqueda por patrón en archivos
    "git-basics",                   # Operaciones básicas Git (list/clone)
    "code-review",                  # Evaluación básica de código
    
    # === SECURITY ===
    "secrets-detection",            # Detección de secretos expuestos
    "vulnerability-scanning",       # Escaneo básico de vulnerabilidades
    
    # === REPORTING ===
    "markdown-formatter",           # Formateo Markdown estructural
    "report-builder",               # Generador básico de reportes
    "json-parsing"                  # Parsing y extracción JSON
    
]
```

### 4.2 Skills Especializadas

Skills avanzadas que se pueden instalar mediante el plugin marketplace:

#### Instalación de Skills Individual:

```bash
# Establecer un nuevo skill específico
pi subagents install <skill-name> --plugin=<repo-url>

# Ejemplos comunes de skills instalables:
pi subagents install security-scanning --plugin=npm:security-audit-tools
pi subagents install code-analysis --plugin=github:npm-code-analyzer
pi subagents install data-visualization --plugin=npm:data-viz-skill
```

#### Catálogo Ollama Integration Skills:

| Skill Name | Descripción | Repositorio NPM | Estado |
|------------|-------------|-----------------|--------|
| `ollama-model-management` | Gestión de modelos LLM, descarga y selección | `npm:ollama-manager` | ✅ Instalado |
| `ollama-inference-pipeline` | Pipeline de inferencia con Ollama API local | `npm:ollama-inference` | ✅ Instalado |
| `ollama-prompt-engineering` | Inyección de prompts y optimización | `npm:ollama-prompts` | ✅ Instalado |

### 4.3 Extensiones y Plugins

#### Catálogo Completo de Extensiones Instaladas

Archivos NPM en ubicación del sistema:

```bash
# Ubicación raíz de extensiones PI
ls -la ~/.pi/agent/npm/node_modules/pi-subagents/node_modules/*.npm/package.json
```

#### Extensiones Principales Registradas

| Extensión | Función | Ubicación | Estado |
|-----------|---------|-----------|--------|
| `ollama-python-integration` | Integración con servidor Ollama local | `@joemccann/pi-pdf/skills/` | ✅ Activo |
| `security-audit-tools` | Herramientas para auditoría de seguridad | `npm:security-audit-tools` | ✅ Instalado |
| `data-reporting-skills` | Habilidades para generación de reportes y análisis | `npm:data-skill-package` | ✅ Instalado |

#### Catálogo Específico de Skills Registrados por JSON:

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

#### Instalación de Extensiones desde NPM/CLI:

```bash
# Instalar skills individuales (modo manual)
pi subagents install security-scanning --plugin <repository-url>
pi subagents install report-formatter --plugin <repository-url>

# Instalar plugin completo (modo automático recommended)
pi plugins add atrawog/bazzite-ai-plugins ollama-python-integration

# Verificar paquetes NPM instalados
npm list --depth=0 ~/.pi/agent/npm/node_modules/pi-subagents

# Listar todos los skills registrados
pi subagents skill-list
```

#### Script para Inspección de Extensiones y Skills:

```bash
#!/bin/bash
# script_list_extensions.sh - Lista todas las extensiones y skills instaladas

echo "=== EXTENSIONES NPM EN PI ==="
ls -la ~/.pi/agent/npm/node_modules/*.npm/ 2>/dev/null || echo "Extensiones no encontradas en npm:"

echo ""
echo "=== DIRECTORIO DE SKILLS ==="
if [ -d '~/.pi/agent/skills' ]; then
    find ~/.pi/agent/skills -name "*.json" -o -name "*.md" | head -20
else
    echo "~/.pi/agent/skills no encontrado. Checking npm modules..."
    ls ~/.pi/agent/npm/node_modules/*.pkg/ 2>/dev/null || echo "Sin packages de skills."
fi

echo ""
echo "=== STATUS DE SKILLS OLLAMA ==="
if [ -f '~/.pi/agent/settings.json' ]; then
    grep -A2 '"skills"' ~/.pi/agent/settings.json 2>/dev/null || echo "No hay configuración de skills en settings.json."
fi

echo ""
echo "=== EXTENSIONES @joemccann ==="
ls -la ~/.pi/agent/npm/node_modules/@joemccann/ 2>/dev/null || echo "@joemccann not found in pi packages."
```

---

## 5. GESTIÓN DE AGENTES

### 5.1 Estructura de Directorios

Arbolos de directorio completos del sistema:

```
/home/hub/.pi/agent/                 # Framework PI principal
├── auth.json                       # Credenciales y autenticación
├── models.json                     # Modelos LLM configurados  
├── settings.json                   # Configuración global PI
│
├── agents/                         # Agentes definidos (manual + installed)
│   ├── security-auditor.md         # Agente de seguridad preconfigurado
│   ├── report-writer.md            # Generador de informes preconfigurado
│   └── [agent-custom].md          # Agentes personalizados por usuarios
│
├── npm/                            # NPM packages y módulos instalados
│   └── pi-subagents/               # Framework PI principal (0.89.1)
│       └── node_modules/
│           ├── @joemccann/pi-pdf/  # Skills PDF especializado
│           ├── pi-web-access/      # Herramientas de acceso web
│           ├── pi-agent-browser-native/  # Agent browser nativo
│           └── [otros-modules]/    # Otros módulos instalados
│
└── sessions/                       # Instancias ejecutadas en curso
    └── --home-hub-agents-manager--/subagent-artifacts/outputs/*/*/*_output.md

~/agents/                           # Directorio raíz de agentes
│   ├── manager/                    # Orquestador central (CRÍTICO)
│   │   ├── AGENTS.md              # Lista completa de todos los agentes activos
│   │   ├── .AGENTSPAST.md         # Historial de configuraciones previas
│   │   ├── .AGENTSTEMP.md         # Plantilla para crear nuevos subagentes
│   │   ├── reportes/              # Directorio para informes generados
│   │   └── [reportes-varios].md   # Documentos PDF y MD por auditoría
│   │
│   ├── DOCUMENTACION.md           # Documentación técnica global
│   ├── diagnostic_report.md       # Reporte de diagnóstico del sistema
│   └── FINAL_REPORT*.md           # Reportes finales consolidados

/home/hub/hola                     # PROMPTS DEL MANAGER AGENT (ES CRÍTICO)
│   └── [prompts-manager].md       # Pormpts, instrucciones y reglas del manager agent


~/hola                             # Archivo central con prompts manager (referencia anterior)
└── [prompts].md                    # Prompts para auditoría de seguridad y otras tareas
```

### 5.2 Configuración de Agentes

#### Formato YAML/JSON para Definición de Agente

Los archivos `.md` que definen agentes deben seguir esta estructura:

```markdown
# [NOMBRE-AGENTE].md
--- name: <nombre-del-agente>
model: "<llm-default>" | "sonnet" | "opus" | "op-sonnet-35"
description: |
  Descripción completa del rol, responsabilidades y contexto operativo.
  
  Incluye:
  - Objetivo principal de la agencia
  - Área de especialización
  - Límites operativos
  
permissions: ["read"] | ["default"] | ["write"] | ["edit"]

tools:
  - read                  # Acceso a lectura de archivos
  - write                 # Escribir archivo nuevo o sobrescribiendo
  - edit                  # Edición con merge operations (no reemplazo total)
  - bash                  # Ejecución de comandos shell y CLI scripts
  - glob                  # Patrones para buscar archivos por path/glob
  - grep                  # Búsqueda en contenido con expresiones regexp
  
skills:
  - skill-name_1          # Habilidad específica (ejm: "security-scanning")
  - skill_name_2
  - [skill_name_n]        # Listar todas las skills aplicables

prompt_cache_ttl: "5m"    # Tiempo de caché del prompt en minutos (recomendado)
```

#### Agentes Específicos de Seguridad

Para `security-auditor.md` ya configurado:

```markdown
--- name: security-auditor
model: "opus"             # Opus para tareas de seguridad complejas y análisis profundo  
description: |
  Auditor de seguridad senior con autoridad para escaneo continuo, detección de 
  vulnerabilidades OWASP Top 10, gestión de secretos expuestos/creenciales rotas.
  
  Contexto: Operaciones SOLO-LECTURA sin modificaciones del sistema objetivo.
  Desplegado en contextos aislados tras cambios detectados en autenticación/autorización.

permissions: ["read"]     # MODO OBLIGATORIO DE SEGURIDAD (read-only)

tools:
  - read
  - bash                  # Solo lectura, inspección de código/salidas
  - cli                   # Acceso a herramientas CLI para pruebas no intrusivas
  - search                # Consulta de documentación técnica y CVE
  
skills:
  - security-scanning     # Escaneo completo de vulnerabilidades
  - dependency-analysis   # Análisis de dependencias comprometidas
  - compliance-check      # Verificación OWASP Top 10, NIST, ISO standards
  - secret-detection      # Detectar .env keys no sanitizadas o secrets expuestos
  
prompt_cache_ttl: "5m"

---
name: report-writer
model: "sonnet"          # Sonnet para redactación de informes técnicos
description: |
  Redactor técnico con capacidad de transformar resultados brutos en documentos 
  profesionales, validados y presentables para stakeholders.

tools:
  - read
  - write                 # Generar nuevos archivos por análisis del auditor
  - edit                  # Corregir secciones específicas sin reemplazo total
  - bash                  # Scripting automatizado de conversiones PDF
  - glob                  # Búsqueda y organización de outputs
  
skills:
  - data-science-reports
  - markdown-formatters   # Formateo Markdown estructurado con encabezados, tablas
  - latex-publisher       # Preparación para LaTeX/Pandoc
  - pdf-generation        # Generación final con Pandoc + XeLaTeX

permissions: ["default"]

prompt_cache_ttl: "10m"

---
```

### 5.3 Creación de Nuevos Agentes

#### Procedimiento Estándar de Creación

**Paso A**: Definir el propósito del nuevo agente

Antes de escribir, responder:
- ¿Qué dominio especializado es? (análisis de código, ciencia de datos, frontend dev)
- ¿Qué herramientas necesita para su función?
- ¿Qué permissions y risks asociados opera?

**Paso B**: Crear archivo `.md` en `~/.pi/agent/agents/` o `~/agents/new-agents/`

Ejemplo para nuevo agente de Ciencia de Datos:

```markdown
--- name: data-science-expert
model: "op-sonnet-35"
description: |
  Experto en análisis científico de datos, ETL pipelines, experimentación ML y 
  visualización avanzada. Capacitado para trabajar con bases SQL, pandas/numpy, 
  scikit-learn, pytorch/tensorflow, generar gráficos matplotlib/seaborn/plotly, 
  y realizar tests estadísticos rigurosos sobre conjuntos de datos complejos.
  
  Contexto: Análisis exploratorio, construcción de modelos predictivos, evaluación 
  experimental, reportes técnicos con métricas validables.

permissions: ["default"]

tools:
  - read                  # Leer datasets, notebooks, código análisis
  - write                 # Crear nuevos notebooks, scripts Python, informes MD
  - bash                  # Ejecutar scripts de análisis, pip instalaciones locales
  - edit                  # Refacturar código, mejoras en pipelines existentes  
  - glob                  # Encontrar datasets por patrón (csv/*.csv, data/)
  - grep                  # Búsqueda en logs de entrenamiento/experimentos
  
skills:
  - data-transform        # ETL y limpieza de datos complejos
  - statistical-analysis   # Pruebas A/B, regresiones, ANOVA, correlaciones  
  - csv-processing        # Pandas/Excel para múltiples hojas/tablas concatenadas 
  - json-parsing          # Extracción profunda y transformación de JSON anidados
  - ml-modeling           # Construcción, entrenamiento y validación modelos ML/DL
  - visualization         # Gráficos, dashboards básicos interactivos
  - statistical-significance  # Validar significancia p-values, intervalos confianza

prompt_cache_ttl: "15m"

# Prompt inicial específico
initial_prompt: |
  Eres Data Science Expert especializado en análisis profundo y experimentación ML.
  Tu workflow estándar es:
  1. Explorar datos: cargar datasets, EDA básico visualizando distribuciones clave.
  2. Limpiar datos: manejo de valores faltantes, normalización escalado.
  3. Modelar: construcción modelos según objetivo (clasificación/regresión/clustering).
  4. Evaluar: métricas relevantes (accuracy, precision/recall, F1, MSE, R²), 
     pruebas de sobreajuste/cross-validation, análisis feature importance.
  5. Reportar: generación notebook Markdown con código explicativo, gráficos, 
     tablas resumen y conclusiones ejecutivas para stakeholders no técnicos.
```

**Paso C**: Definir inicial prompt para comportamiento específico desde creación

Inclusion de `initial_prompt` ayuda a establecer el "personality" del agente desde su primera invocación.

**Paso D**: Verificar que los nuevos agentes se cargaron correctamente

```bash
# Reiniciar daemon del framework (si existe)
sudo systemctl restart pi-daemon || echo "//daemon no encontrado por systemctl"

# Listar todos los agentes disponibles
find ~/.pi/agent/agents -name "*.md" -exec basename {} \;

# Verificar carga de nuevos paquetes NPM si fueron instalados
npm list ~.pi/agent/npm/node_modules/pi-subagents --depth=0

# Ejecutar test rápido con el nuevo agente para verificar funcionalidad
subagent(agent="nombre-del-agente", task="<pequeña tarea de prueba>")
```

---

## 6. PROMPTS DEL MANAGER

📁 **Ubicación Crítica**: Los prompts utilizados por el Manager Agent se encuentran en:

```bash
~/hola  # Archivo principal con prompts manager (CRÍTICO)
```

### Contenido Específico del Directorio ~/hola

Los prompts almacenados en `~/hola` incluyen instrucciones detalladas para:

1. **Auditoría de seguridad de El Buen Fin**: Prompt optimizado para escaneo pasivo no intrusivo de https://www.elbuenfin.org usando obligatoriamente security-auditor con agent_browser y posterior report-writer para generación de informes Markdown validados.

2. **Delegación Obligatoria de Tareas**: Instrucciones para que el Manager no realice nunca tareas personalmente, sino delegue inmediatamente a subagent especializados (security-auditor, report-writer, etc.).

3. **Secuencia Operativa Estricta**: Prompts con reglas de ejecución ordenadas garantizando uso obligatorio de herramientas especializadas en cada etapa del workflow:
   - Primero invocar a `security-auditor` 
   - Luego usar `agent_browser` directamente gestionado por el auditor 
   - Después delegar a `report-writer` para creación de Markdown
   - Finalmente convertir a PDF usando Pandoc+XeLaTeX

4. **Prohibiciones Claras**: Prompts con restricciones explícitas:
   - NO invocar manualmente `agent_browser` antes del auditor
   - NO omitir delegación alguna
   - NO simular ejecuciones de herramientas no disponibles
   - NO modificar resultados ya validados por agentes anteriores

5. **Formato de Salida Esperado**: Prompts definen estrictamente qué debe incluir:
   - Resumen ejecutivo conciso
   - Alcance y metodología explicada
   - Hallazgos detallados con evidencias verificables
   - Clasificación CRITICAL/SEVERE/MEDIUM/LOW/INFO
   - Recomendaciones priorizadas para remediación

### Acceso a Prompts del Directorio ~/hola

```bash
# Ver todos los prompts guardados
cat /home/hub/hola

# Buscar por sección específica: grep -A10 "PROMPT DE AUDITORÍA" /home/hub/hola | head -50

# Exportar prompts manager para análisis separado
cp ~/hola /tmp/prompts-manager-backup.md 2>/dev/null || echo "//no se puede escribir en directorio root."
```

**IMPORTANTE**: Estos prompts representan el "golden standard" de instrucciones que define cómo debe comportarse correctamente el Manager agent en cada situación. Son la referencia para mantener consistencia operativa del sistema multiagente.

---

## 7. OPERACIÓN Y USO DIARIO

### 7.1 Inicio del Sistema

#### Comandos de Arranque

```bash
# Paso A: Verificar estado Ollama
systemctl status ollama
ollama ps          # Modelos cargados en memoria GPU

# Paso B: Verificar PI Framework
pi --version
python3 --version

# Paso C: Iniciar sesión y cargar agentes
pi agent-manager activate  # Si existe daemon de gestión

# Paso D: Confirmar conexión Ollama API
curl -s http://localhost:11434/api/tags | jq .
```

#### Comandos Diagnósticos Rápidos

```bash
diagnostic_quickcheck() {
    echo "=== SISTEMA PI + OLLAMA ==="
    
    # Estado de GPU
    ollama list | grep -q qwen && echo "✅ Modelo Qwen activo" || echo "❌ Verificar modelos"
    systemctl is-active ollama && echo "✅ Servicio Ollama activo" || echo "⚠️ Iniciar: sudo systemctl start ollama"
    
    # Estado de PI
    pip show pi-subagents &>/dev/null && echo "✅ NPM pi-subagents instalado" || echo "❌ Instalar: pip install pi-subagents"
    
    # Directorios clave
    [ -d ~/.pi/agent ] && echo "✅ Framework PI en $HOME/.pi/agent/"
    [ -f /home/hub/hola ] && echo "✅ Prompts Manager disponibles en ~/hola"
    [ -d ~/agents/manager ] && echo "✅ Directorio de agentes y manager activo"
}

diagnostic_quickcheck
```

### 7.2 Ejecución de Tareas

#### Invocación Manual a Subagentes

Ejemplo con Python para tareas complejas:

```python
"""
Invocar subagent específico con delegación automática al Manager
"""

from pi_subagents import subagent

def invocar_seguridad(ruta_a_probar="/ruta/a/proyecto/frontend"):
    """Invocar auditor de seguridad en directorio proporcionado"""
    
    subagent(
        agent="security-auditor",                    # Nombre del agente especializado  
        task=f"Escaneo de vulnerabilidades en {ruta_a_probar}. " + 
              f"Incluir OWASP Top 10, XSS, SQL Injection, CSRF, secrets expuestos. " +
              f"Usar agent_browser para inspeccionando HTML real y responses HTTP. ",
        cwd=ruta_a_probar,                          # Directorio de trabajo del subagente  
        evidence="[resultados_directos_de_agent_browser]"  # No inventar evidencias
    )
    
# Ejemplo de invocación manual al report-writer:
def generar_reporte(final_results):
    """Transformar resultados crudos en informe estructurado Markdown"""
    
    subagent(
        agent="report-writer",
        task=f"Crear reporte técnico profesional con: resumen ejecutivo, metodología, " + 
              f"hallaazgos detallados clasificados, evidencias verificables, recomendaciones. ",
        evidence=final_results  # Entradas exactas recibidas del auditor
    )

# Ejemplo de invocación multi-agente para flujo completo de auditoría:
def auditoria_secuencia_completa(
    dominio_url="https://www.elbuenfin.org",
    archivo_reporte="/home/hub/agents/manager/reportes/auditoria.md"
):
    """Flujo completo: browser → security-auditor → report-writer → PDF"""
    
    print("=== INICIANDO AUDITORÍA COMPLETA ===")
    
    # Fase 1: Navegar e inspeccionar sitio (hace agent_browser)
    # Esto se debería invocar vía: subagent(agent="security-auditor", task=...)
    # security-auditor utiliza automáticamente agent_browser para navegación e inspección
    
    print("Fase 2: Invocar security-auditor...")
    subagent(
        agent="security-auditor",
        task=f"Audit complete {dominio_url}: escanear toda la app, formularios, APIs públicas, " + 
              f"scripts con eval/injectible. Evidencias reales desde navegador."
    )
    
    # Esperar resultados del auditor
    audit_results = subagent(
        agent="security-auditor", 
        task=f"Ejecutar escaneo de {dominio_url}",
        cwd="/"  # Opcional, puede operar en contexto remotos vía browser
    ).output.md
    
    print("Fase 3: Invocar report-writer para síntesis final...")
    subagent(
        agent="report-writer", 
        task=f"Generar informe {archivo_reporte} basado en hallazgos del auditor:" + audit_results,
    )
    
    # Fase 4: Generar conversión a PDF automático (si tools disponibles)
    print("Fase 4: Conversión PDF con Pandoc+XeLaTeX...")
    bash(f"pandoc {archivo_reporte}.md -o {archivo_reporte}.pdf -s --latex-documentclass=article \\" +
         f"--variable=metadata:'title:Auditoría de Seguridad'""; echo 'PDF generado')

```

#### Invocación Simplificada vía CLI

Para usuarios sin Python que prefieren usar shell nativo:

```bash
# Ejecutar comando manual de subagent a través de NPM/Python
python3 -c "from pi_subagents import subagent; print(subagent(agent='scout',task='Analizar estructura en ~/proyecto').output.md)"

# Alternativa sin Python (shell puro):
# Usar directamente herramientas que el framework instala por pip:
subagent-cli agent scout task 'Analiza estructura del directorio dado' --cwd /home/hub/proyecto
```

### 7.3 Monitoreo y Diagnóstico

#### Comandos de Verificación del Sistema Operativo

```bash
# Monitorización continua Ollama

monitor_ollama() {
    echo "=== ESTADO DEL MOTOR DE INFERENCIA ==="
    
    # Procesos GPU/GPU utilización
    ollama ps || ollama list --processes
    
    # Métricas de inferencia si exponen endpoints /api/metrics
    curl -s http://localhost:11434/api/ps | jq . 2>/dev/null || echo "Verificando manualmente..."
}

monitor_ollama

# Monitoring continuo PI sessions en curso

check_pi_sessions() {
    if [ -d ~/.pi/agent/sessions ]; then 
        echo "=== INSTANCIAS PI EN CURSO ==="
        ls -la ~/.pi/agent/sessions/* 2>/dev/null | grep "\.md$ || echo "Sin sessions activas actualmente."
        
        # Estadísticas recientes de subagent ejecuciones
        find ~/.pi/agent/sessions -name "*_output.md" -type f
    else 
        echo "No sessions detectadas en directorios predeterminados."
    fi
}

check_pi_sessions

# Reporte general del sistema multiagente

report_multiagent_system() {
    echo "=== ESTADO COMPLETO DEL SISTEMA MULTIAGENTE ==="
    
    echo "1. Motor Inference (Ollama):"
    ollama list -q | head -3 || ollama ps --short || true
    
    echo "2. Agentes activos:"
    ls ~/.pi/agent/agents/*.md 2>/dev/null | xargs basename || echo "Sin agentes definidos en ~/.pi/agent/agents/"
    
    echo "3. Prompts Manager (CRÍTICO):"
    if [ -f /home/hub/hola ]; then
        echo "   - Archivo prompts manager: /home/hub/hola"
    else
        echo "   - ERROR: ~/hola no encontrado! Referencia de prompts CRÍTICA para Manager."
    fi
    
    echo "4. Reportes generados últimos:"
    ls ~/.pi/agent/sessions/*/outputs/*_output.md 2>/dev/null | head -20 || true

    echo "5. Status servicio systemd:"
    systemctl is-active ollama && echo "   ✅ Activo" || echo "   ⚠️ Inactivo, reiniciar: sudo systemctl start ollama"
}

report_multiagent_system
```

---

## 8. SEGURIDAD Y RESTRICCIONES

### Principios Fundamentales de Seguridad PI + Ollama

1. **Least Privilege**: Cada agente opera con mínimo privilegio necesario para su tarea. Los subagentes especializados como `security-auditor` funcionan en modo SOLO-LECTURA por defecto y nunca deben realizar operaciones destructivas o modificativas sobre el sistema objetivo.

2. **Autorización Explícita**: Ningún directorio fuera del autorizado por el usuario puede ser explorado automáticamente. Si no se especifica ruta explícitamente, SOLICITAR Y AGUARDAR la ruta antes de proceder.

3. **Prohibición de Simulación**: No simular ejecuciones de herramientas cuando NO EXISTEN invocaciones reales. Informar si agent_browser/security-auditor/report-writer están o no disponibles y reportar problemas técnicos auténticos.

4. **No Solución de Vulnerabilidades Encontradas**: El auditor debe documentar hallazgos pero NO corregir automáticamente vulnerabilidades ni eliminar archivos comprometidos sin autorización expresa del usuario. Su función es informar, no remediar (la corrección corresponde a operaciones administrativas humanas o a otros agentes autorizados para ello).

5. **No Creación de Agentes**: El sistema actual ya define su lista fija de subagentes especializados. NO CREAR NUEVOS AGENTES si la documentación indica que los existentes cubren las necesidades requeridas. Usar el catálogo predefinido:

   - `scout` (reconocimiento)
   - `researcher` (investigación/documentación)
   - `worker` (implementación técnica)
   - `reviewer` (evaluación de calidad)  
   - `oracle` (toma decisiones)
   - `security-auditor` (auditoría seguridad)
   - `report-writer` (generación reportes validados)

### Configuraciones Recomendadas de Seguridad Ollama

Para evitar accesos no autorizados a la API local:

```bash
# Habilitar autenticación básica para API (Opcional, recomendado en exposición externa)
echo "OLLAMA_ORIGINS=\"http://localhost http://127.0.0.1:8080\"" >> ~/.ollama/config
echo "{\"auth\": {\"type\":\"basic\", \"users\":{\"admin\":\"password-securo\"}}"  # Verificar formato correcto

# Configurar firewall para API HTTP
sudo ufw allow from 192.168./any to any port 11434 proto tcp  # Solo red interna confiable  
```

---

## 9. TROUBLESHOOTING

### Problemas de Instalación Comunes y Soluciones Rápidas

#### Ollama no inicia correctamente

```bash
# Verificar logs del servicio systemd
sudo journalctl -u ollama -n 50 --no-pager || \
cat /var/log/ollama.log 2>/dev/null 

# Reiniciar con más verbosidad si falla
sudo systemctl restart ollama
sudo systemctl status ollama

# Inicialización manual alternativa si systemd falla
curl -fsSL https://ollama.com/install.sh | sh
which ollama && ollama --version
```

#### Skills fallan al instalars desde NPM/PI

```bash
cache_npm() {
    echo "Limpiando caché de instalación..."
    npm cache clean --force 2>/dev/null || true
}

cache_npm && pip install pi-subagents "@joemccann/pi-pdf"

# Verificar manualmente packages instalados
python3 -c "from pi_subagents import subagent; print('✅ PI Framework funcional')" 2>&1 | head -5
```

#### Agentes no se despliegan automáticamente en su contexto aislado

```bash
# Inspección de estructura de directorios
ls ~/.pi/agent/agents/*.md
ls ~/.pi/agent/sessions/* 2>/dev/null || echo "No sessions detectadas por defecto."

# Reinicio daemon o procesos de PI (si existe)
killall -USR1 pi-daemon || sudo systemctl restart pi-daemon 2>/dev/null || echo "//daemon no detectado como servicio independiente."
```

#### Agent_browser/Chromium no se inicia para auditorías de sitios web

```bash
# Instalar/update chromium si falta
sudo dnf install chromium --yes # Fedora/RHEL
sudo dnf install google-chrome -y # Ubuntu/Debian alternativas

# Verificar configuración PATH del servicio systemd en override.conf
cat /etc/systemd/system/ollama.service.d/override.conf  # Ver que path incluye herramientas web necesarias: ~/.local/bin ~/.fzf/bin etcétera."
```

### Diagnóstico de Estado Global del Sistema

Script completo de diagnóstico:

```bash
#!/bin/bash

# Diagnostic script para PI + Ollama System Health Check
diagnos() {
    echo "=============================================="  
    echo "  DIAGNÓSTICO COMPLETO DEL SISTEMA MULTIAGENTE"  
    echo "==============================================" 
  
if [ ! -x python3 ]; then 
   printf "\n❌ Python 3.12 no encontrado o no ejecutable!\n"; exit 401
fi

printf "\n[1] Verificando Ollama Motor Inferencia:\n"
if command -v ollama &>/dev/null; then 
   version=$(ollama --version | head -1) && printf "   ✅ Versión: %s\n" "$version"; 

   ps aux | grep "[o]llama serve" 2>/dev/null || true

else
    printf "⚠️ Ollama binario no encontrado en PATH local.\n" 
fi

printf "\n[2] Estado del Servidor systemd:\n"
sudo systemctl status ollama --no-pager -l 2>/dev/null || \
 sudo journalctl -u ollama -n 5 --no-pager 2>/dev/null || printf "   ⚠️ No logs visibles. Verificar 'systemctl status ollama'\n"

printf "\n[3] Modelos cargados en memoria GPU (ollama ps):\n"
ollama ps 2>/dev/null || ollama list 2>/dev/null || printf "   ❌ Comando ollama ps no disponible.\n"

printf "\n[4] Estado Framework PI:\n"
if pip show pi-subagents &>/dev/null; then 
   version=$(pip show pi-subagents | grep Version | cut -d = -f 2) && \
   printf "   ✅ Instalado: %s\n" "$version"; 
else
   printf "⚠️ PI Framework no instalado. Instalar:\n     pip install pi-subagents\n"
fi

printf "\n[5] Skills NPM instaladas en PI:\n"
npm list --depth=0 ~/.pi/agent/npm/node_modules/pi-subagents 2>/dev/null | grep -o '@[^@]*' || \
echo "No se pueden listar. Intentando fallback genérico..." && \
find ~/.pi/agent/npm/node_modules/@joemccann -name "package.json" -exec sh -c 'echo "   ✅ @joemccann/$1";' _ {} \; 2>/dev/null || echo "No detectados."

printf "\n[6] Agentes definidos en ~/.pi/agent/agents:\n"
if [ -d ~/.pi/agent/agents ]; then 
   ls -la ~/.pi/agent/agents/*.md 2>/dev/null | sed 's/^\./    \//' || echo "No agentes .md encontrados."
else
   printf "   ⚠️ Directorio %s no encontrado.\n" ~/.pi/agent/agents
fi

printf "\n[7] Archivo Prompts Manager (CRÍTICO para delegación):\n"
if [ -f /home/hub/hola ]; then 
    echo "   ✅ PROMPTS DEL MANAGER disponibles en:" 
    echo "     ~/hola" 
else 
    printf "   ❌ ERROR CRÍTICO:~/hola no encontrado!\n\n" \
           "Los prompts del manager contienen instrucciones obligatorias para auditoría de seguridad,\n" \
           "delegación automática y flujo operativo correcto. Verificar ruta exacta y contenido."
fi

printf "\n[8] Directorios activos:\n"
dirs=(
    "~/.pi/agent/"
    "~/agents/manager/" 
    "~/agents/manager/reportes/") 
  
for dir in "${dirs[@]}"; do 
   if [ -e "$dir" ]; then printf "   ✅ %s\n" "$dir"; else printf "❌ %s no existente.\n" "$dir"; fi; 
done

printf "\n[9] Estado de procesos GPU (si detectable):\n"
sudo nvidia-smi 2>/dev/null || printf "   ⚠️ driver NVIDIA/sudo nvidia-smi no disponible para consulta directa.\n\n"

printf "\n=== RESUMEN DEL DIAGNÓSTICO ===\n"
echo "Este check verifica Ollama, PI Framework, NPM skills, Agentes y Prompts Manager (CRÍTICOS)."
printf "\nRecomendación:\n"
printf "  - Si algunos módulos no funcionales: revisa logs de systemd con 'journalctl -u ollama'-\n" \
       "- Verifica que Python/NPM/PIP tienen versión actualizada.\n" \
       "- Confirma que ~/hola existe y contiene prompts manager para auditoría segura."
}

# Ejecutar diagnóstico  
diagnos || echo "Diagnóstico realizado. Revisar resultados arriba."
```

---

## 10. REFERENCIAS Y RECURSOS

### Repositorios Oficiales

- **PI Framework GitHub**: https://github.com/joemccann/pi-subagents
- **Ollama Oficial**: https://ollama.com/download/linux
- **Documentación de Ollama API**: https://github.com/ollama/ollama/blob/main/docs/api.md
- **Skills NPM Marketplace (si existen)**: <https://npmjs.org/search?q=pi+skill+plugin>

### Recursos Adicionales y Documentación Interna del Sistema

Documentación técnica principal para instalación completa de PI+Ollama y configuración local:

```bash
# Ubicaciones internas principales:

/home/hub/DOCUMENTACION_COMPLETA_PI_OLLAMA.md      # Versión antigua, referencia  
/home/hub/agents/DOCUMENTACION.md                  # Documentación técnica actualizada
/home/hub/DOCUMENTACION_PI_OLLAMA_SUBAGENTES.md    # Documentación de subagentes específica
```

### Comandos de Administración Útiles (Resumen)

Comando rápido para gestión de subagentes y reportes:

```bash
# Listar todos los agentes configurados
subagent --list | jq -r '.[] | select(.role!="unknown") | .name' 2>/dev/null || \
 find ~/.pi/agent/agents -name "*.md" -exec basename {} \;

# Generar un archivo de reporte rápido para auditoría inmediata  
subagent(agent="security-auditor", task="Generar lista rápida de activos encontrados en ~/proyectos") > ~/reportes/audit-rapido.md

# Ejecutar report-writer sobre salida anterior
subagent(agent="report-writer", task="Reescribir resultado anterior para formato estándar Markdown+PDF")
```

---

## 📄 CONCLUSIÓN

Esta documentación completa proporciona:

- ✅ **Guía de instalación paso a paso** de PI (Agent Framework) y Ollama  
- ✅ **Configuración inicial correcta** incluyendo prompts del manager en ~~hola
- ✅ **Descripción detallada** de agentes preestablecidos: security-auditor, report-writer, scout, researcher, worker, reviewer, oracle
- ✅ **Estructura clara para creación manual** de subagentes personalizados por usuarios
- ✅ **Catalogo completo de skills y extensiones** tanto core como especializadas  
- ✅ **Guías de operación diaria** con comandos diagnósticos y troubleshooting
- ✅ **Referencias a archivos clave,** directorios configurados y estructura de archivos

📁 **NOTA IMPORTANTE**: Los prompts utilizados por el Manager Agent para orquestación automática, delegación obligatoria y secuencias operativas críticas están almacenados específicamente en:

```
/home/hub/hola  # Archivo CRÍTICO que contiene todos los prompts del manager
```

**Esta ruta debe preservarse como referencia definitiva.**

---

*Documento generado: Actualización completa con todo contenido existente de `DOCUMENTACION_COMPLETA_PI_OLLAMA.md`, `DOCUMENTACION_PI_OLLAMA_SUBAGENTES.md`, `agents/manager/AGENTS.md` y `agents/DOCUMENTACION.md`, unificados con secciones nuevas sobre instalación, implementación y uso.*

*Fecha: 19-Nov-2026 (o fecha actual del sistema)*