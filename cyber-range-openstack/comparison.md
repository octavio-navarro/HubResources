# Comparison of Security Environments for OpenStack Deployment

**Objective:**
Evaluate open-source security environments (VMs, cyber ranges, or containers) that can be deployed in a private OpenStack cloud. The goal is to select tools that are:
- Open-source
- Replicable and editable
- Scalable with diverse scenarios
- Monitorable

---

## Evaluation Criteria
| Criteria               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| **Open-Source**        | License (e.g., GPL, MIT) and community support.                            |
| **Replicable**         | Ease of cloning or scaling (e.g., via templates, scripts, or APIs).         |
| **Editable**           | Ability to modify configurations (e.g., scripts, templates, or source code).|
| **Scenario Diversity** | Variety of pre-configured scenarios (e.g., pentesting, forensics, malware analysis). |
| **Monitoring Support** | Integration with monitoring tools (e.g., Prometheus, Grafana, ELK Stack).   |
| **OpenStack Compatibility** | Ease of deployment in OpenStack (e.g., cloud-init, Heat templates, or containers). |

---

## Tools Evaluated

### 1. OWASP Juice Shop

- **Type:** Web Application / Cyber Range
- **Website:** https://github.com/juice-shop/juice-shop
- **License:** MIT License
- **Open-Source:** ✅ Yes
- **Replicable:** ✅ High
- **Editable:** ✅ High

- **Scenario Diversity:**
  - **Scenario 1: Web Application Vulnerabilities**
    - Incluye vulnerabilidades del OWASP Top 10, como SQL Injection, Cross-Site Scripting (XSS), fallos de autenticación y exposición de información sensible.
  - **Scenario 2: Capture The Flag (CTF)**
    - Ofrece retos de hacking de diferentes niveles de dificultad, un sistema de puntuación (Score Board) y códigos de bandera para organizar competiciones CTF.

- **Monitoring Support:**
  - **Tool 1: Score Board**
    - Registra los desafíos completados y permite consultar el progreso del participante.
  - **Tool 2: WebHook, API y Metrics**
    - Facilita la integración con plataformas externas de entrenamiento, la consulta de información sobre los desafíos y la supervisión de métricas.

- **OpenStack Compatibility:**
  - **Deployment Method:** Docker, Node.js o cloud-init dentro de una instancia virtual de OpenStack.
  - **Notes:**
    - No requiere una integración nativa con OpenStack.
    - Puede instalarse en una máquina virtual Linux y ejecutarse mediante Docker.
    - El puerto predeterminado de la aplicación es `3000`.
    - Se pueden crear varias instancias para ofrecer laboratorios independientes a diferentes participantes.
    - Se recomienda configurar grupos de seguridad y limitar el acceso a la aplicación, ya que contiene vulnerabilidades intencionales.

- **Pros:**
  - Código abierto y gratuito bajo la licencia MIT.
  - Instalación sencilla mediante Docker.
  - Amplia variedad de retos basados en vulnerabilidades reales.
  - Incluye un sistema de puntuación y funcionalidades para competiciones CTF.
  - Permite personalizar la aplicación y crear desafíos propios.
  - Compatible con entornos virtualizados y proveedores de nube.

- **Cons:**
  - Está enfocado principalmente en vulnerabilidades de aplicaciones web.
  - No simula una infraestructura de red empresarial completa.
  - Requiere conocimientos básicos de Docker o Node.js para su instalación y mantenimiento.
  - No proporciona por sí solo una solución completa de monitorización de redes o sistemas.

- **Final Score:** ⭐⭐⭐⭐⭐ 5/5

**Justification:** OWASP Juice Shop es una excelente opción para proyectos universitarios de ciberseguridad debido a su facilidad de despliegue, variedad de desafíos y compatibilidad práctica con máquinas virtuales de OpenStack mediante Docker.

---

### 2. [Tool Name 2]
*(Follow the same structure as above)*

---

### 3. [Tool Name 3]
*(Follow the same structure as above)*

---

## Summary Table

| Tool Name       | Type          | Open-Source | Replicable | Editable | Scenario Diversity | Monitoring Support | OpenStack Compatibility |
|-----------------|---------------|-------------|------------|----------|--------------------|--------------------|-------------------------|
| Tool 1          | VM/Container  | ✅ Yes      | ⚠️ Medium  | ✅ High  | High               | ✅ Yes             | ✅ High                 |
| Tool 2          | Cyber Range   | ✅ Yes      | ✅ High    | ⚠️ Medium| Medium             | ❌ No              | ⚠️ Medium               |
| Tool 3          | Container     | ✅ Yes      | ✅ High    | ✅ High  | Low                | ✅ Yes             | ✅ High                 |

---

## Recommendation
Based on the evaluation, the recommended tool for deployment in OpenStack is:
**[Tool Name]**
**Reasoning:**
- [Reason 1]
- [Reason 2]
- [Reason 3]

---

## References
- [Link 1:GitHub Repository] (https://github.com/juice-shop/juice-shop)
- [link 2: Official Documentation Juice-shop] (https://pwning.owasp-juice.shop/)
- [link 3:OWASP Project Page, Juice-shop] (https://owasp.org/projects/juice-shop)

