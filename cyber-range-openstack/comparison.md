# Comparison of Security Environments for OpenStack Deployment

**Objective:**
Evaluate open-source security environments (VMs, cyber ranges, or containers) that can be deployed in a private OpenStack cloud. The goal is to select tools that are:

* Open-source
* Replicable and editable
* Scalable with diverse scenarios
* Monitorable

\---

## Evaluation Criteria

|Criteria|Description|
|-|-|
|**Open-Source**|License (e.g., GPL, MIT) and community support.|
|**Replicable**|Ease of cloning or scaling (e.g., via templates, scripts, or APIs).|
|**Editable**|Ability to modify configurations (e.g., scripts, templates, or source code).|
|**Scenario Diversity**|Variety of pre-configured scenarios (e.g., pentesting, forensics, malware analysis).|
|**Monitoring Support**|Integration with monitoring tools (e.g., Prometheus, Grafana, ELK Stack).|
|**OpenStack Compatibility**|Ease of deployment in OpenStack (e.g., cloud-init, Heat templates, or containers).|

\---

## Tools Evaluated

### 1\. OWASP Juice Shop

* **Type:** Web Application / Cyber Range
* **Website:** https://github.com/juice-shop/juice-shop
* **License:** MIT License
* **Open-Source:** ✅ Yes
* **Replicable:** ✅ High
* **Editable:** ✅ High
* **Scenario Diversity:**

  * **Scenario 1: Web Application Vulnerabilities**

    * Incluye vulnerabilidades del OWASP Top 10, como SQL Injection, Cross-Site Scripting (XSS), fallos de autenticación y exposición de información sensible.
  * **Scenario 2: Capture The Flag (CTF)**

    * Ofrece retos de hacking de diferentes niveles de dificultad, un sistema de puntuación (Score Board) y códigos de bandera para organizar competiciones CTF.
* **Monitoring Support:**

  * **Tool 1: Score Board**

    * Registra los desafíos completados y permite consultar el progreso del participante.
  * **Tool 2: WebHook, API y Metrics**

    * Facilita la integración con plataformas externas de entrenamiento, la consulta de información sobre los desafíos y la supervisión de métricas.
* **OpenStack Compatibility:**

  * **Deployment Method:** Docker, Node.js o cloud-init dentro de una instancia virtual de OpenStack.
  * **Notes:**

    * No requiere una integración nativa con OpenStack.
    * Puede instalarse en una máquina virtual Linux y ejecutarse mediante Docker.
    * El puerto predeterminado de la aplicación es `3000`.
    * Se pueden crear varias instancias para ofrecer laboratorios independientes a diferentes participantes.
    * Se recomienda configurar grupos de seguridad y limitar el acceso a la aplicación, ya que contiene vulnerabilidades intencionales.
* **Pros:**

  * Código abierto y gratuito bajo la licencia MIT.
  * Instalación sencilla mediante Docker.
  * Amplia variedad de retos basados en vulnerabilidades reales.
  * Incluye un sistema de puntuación y funcionalidades para competiciones CTF.
  * Permite personalizar la aplicación y crear desafíos propios.
  * Compatible con entornos virtualizados y proveedores de nube.
* **Cons:**

  * Está enfocado principalmente en vulnerabilidades de aplicaciones web.
  * No simula una infraestructura de red empresarial completa.
  * Requiere conocimientos básicos de Docker o Node.js para su instalación y mantenimiento.
  * No proporciona por sí solo una solución completa de monitorización de redes o sistemas.
* **Final Score:** ⭐⭐⭐⭐⭐ 5/5

**Justification:** OWASP Juice Shop es una excelente opción para proyectos universitarios de ciberseguridad debido a su facilidad de despliegue, variedad de desafíos y compatibilidad práctica con máquinas virtuales de OpenStack mediante Docker.

\---

### 2\. Orion Range

* **Type:** Cyber Range / Cyber Range Orchestrator
* **Website:** https://github.com/eniokrauss/Orion-range
* **License:** Apache License 2.0
* **Open-Source:** ✅ Yes
* **Replicable:** ⚠️ Medium
* **Editable:** ✅ High
* **Scenario Diversity:**

  * **Scenario 1: Red Team vs. Blue Team**

    * Diseñado para ejercicios de ataque y defensa en entornos controlados. El Red Team puede realizar pruebas de explotación, movimiento lateral, escalamiento de privilegios y simulación de exfiltración de datos. El Blue Team puede supervisar los eventos y responder a los ataques.
  * **Scenario 2: Enterprise Network Simulation**

    * Permite definir entornos empresariales con redes internas, servidores, hosts, segmentos DMZ, vulnerabilidades y componentes defensivos. Los escenarios pueden modelarse mediante planos de laboratorio (*Lab Blueprints*) y asociarse con técnicas de MITRE ATT\&CK.
* **Monitoring Support:**

  * **Tool 1: SIEM / EDR / XDR**

    * El README describe la posibilidad de desplegar infraestructura defensiva como SIEM, EDR/XDR, IDS/IPS y sistemas de registro de eventos. La integración y disponibilidad efectiva de estas herramientas dependen de la configuración y de los componentes desplegados.
  * **Tool 2: Network Monitoring and Logging**

    * Contempla supervisión de red, telemetría de firewall y registros de endpoints para apoyar las actividades de defensa. No debe interpretarse como evidencia de que todas estas herramientas vengan instaladas por defecto.
* **OpenStack Compatibility:**

  * **Deployment Method:** Integración potencial mediante adaptación del proveedor de hipervisor, máquinas virtuales de OpenStack y automatización de infraestructura.
  * **Notes:**

    * El repositorio documenta una arquitectura de aprovisionamiento de máquinas virtuales orientada principalmente a Proxmox.
    * No se encontró evidencia suficiente de un adaptador nativo para OpenStack.
    * Su uso en OpenStack podría requerir desarrollar o adaptar un proveedor de hipervisor y probar el aprovisionamiento, las redes y el restablecimiento de las máquinas virtuales.
    * El proyecto se encuentra en desarrollo activo; algunas funcionalidades descritas están planificadas y no deben asumirse como completamente implementadas.
* **Pros:**

  * Código abierto bajo la licencia Apache 2.0.
  * Diseñado para escenarios completos de Red Team y Blue Team.
  * Permite definir laboratorios mediante archivos JSON/YAML.
  * Busca facilitar la reproducción y el restablecimiento de entornos mediante snapshots.
  * Integra el modelado de técnicas de MITRE ATT\&CK.
  * Arquitectura modular que permite ampliar componentes y escenarios.
* **Cons:**

  * Se encuentra en una fase activa de desarrollo.
  * Su arquitectura está orientada principalmente a Proxmox, por lo que la compatibilidad con OpenStack no está confirmada.
  * Puede requerir conocimientos de virtualización, redes y configuración de servicios.
  * Algunas funcionalidades avanzadas, como el motor completo de escenarios y la generación asistida por IA, aparecen como futuras mejoras.
  * La integración de SIEM, EDR/XDR y otras herramientas defensivas puede requerir configuración adicional.
* **Final Score:** ⭐⭐⭐⭐☆ 4/5

  **Justification:** Orion Range es prometedor para un proyecto universitario que busque simular entornos empresariales completos, ejercicios Red Team vs. Blue Team y escenarios basados en MITRE ATT\&CK. Sin embargo, su estado de desarrollo y la falta de compatibilidad nativa confirmada con OpenStack reducen su puntuación para un despliegue inmediato.

\---`

### 3\. pwnthemall

* **Type:** CTF Platform / Container-Based Cyber Range
* **Website:** https://github.com/pwnthemall/pwnthemall
* **License:** Apache License 2.0 with Commons Clause restriction
* **Open-Source:** ⚠️ Source-available; Commons Clause restricts commercial sale
* **Replicable:** ✅ High
* **Editable:** ✅ High
* **Scenario Diversity:**

  * **Scenario 1: Docker-Based Hacking Challenges**

    * Permite crear desafíos de ciberseguridad en contenedores Docker independientes. Cada reto puede incluir una aplicación, archivos, instrucciones, puertos de acceso y una bandera (flag) que los participantes deben encontrar.
  * **Scenario 2: GeoINT Challenges**

    * Permite crear retos de inteligencia geoespacial en los que los participantes deben identificar una ubicación en un mapa utilizando pistas y una descripción.
  * **Additional Scenario: Multi-Container Challenges**

    * Contempla retos que utilizan varios contenedores mediante Docker Compose. La documentación señala que este tipo de desafío está en desarrollo (WIP), por lo que su disponibilidad debe verificarse antes de implementarlo.
* **Monitoring Support:**

  * **Tool 1: CTF Scoreboard**

    * La plataforma gestiona desafíos, puntuaciones y participación de equipos, permitiendo seguir el progreso de una competición.
  * **Tool 2: Challenge Metadata Synchronization**

    * Sincroniza los metadatos de los desafíos desde archivos YAML hacia el almacenamiento de la plataforma. Esto ayuda a mantener los retos organizados, pero no equivale a monitorización de red o detección de intrusiones.
* **OpenStack Compatibility:**

  * **Deployment Method:** Docker Compose dentro de una máquina virtual de OpenStack.
  * **Notes:**

    * La documentación oficial indica que Docker Compose es actualmente el método de instalación del proyecto.
    * Puede desplegarse en una instancia Linux de OpenStack que tenga Docker y Docker Compose instalados.
    * La documentación requiere también un cliente SSH y Bash.
    * No se encontró evidencia de integración nativa con OpenStack ni de plantillas Heat oficiales.
    * Para ejecutar desafíos Docker dentro de la plataforma, será necesario comprobar los requisitos de permisos, conectividad y acceso al motor Docker.
    * Los retos que necesiten varios contenedores deben validarse por separado debido a su estado de desarrollo.
* **Pros:**

  * Código fuente disponible públicamente en GitHub.
  * Instalación documentada mediante Docker Compose.
  * Permite desplegar desafíos basados en Dockerfile.
  * Soporta retos CTF estándar, Docker y GeoINT.
  * Permite personalizar el frontend y backend.
  * Incluye gestión de equipos, insignias y recompensas.
  * Los desafíos pueden definirse mediante archivos YAML.
  * Permite organizar retos con dependencias para establecer rutas de aprendizaje progresivas.
* **Cons:**

  * No está diseñado para simular por sí solo una infraestructura empresarial completa de Red Team vs. Blue Team.
  * No ofrece integración nativa con OpenStack documentada.
  * El soporte para desafíos multi-contenedor aparece como una funcionalidad en desarrollo.
  * La instalación requiere conocimientos básicos de Linux, Docker Compose y configuración de servicios.
  * La documentación del repositorio indica que el desarrollo está pausado temporalmente.
  * La licencia incorpora Commons Clause, que restringe la venta comercial del software; debe revisarse antes de usarlo en un servicio comercial.
* **Final Score:** ⭐⭐⭐⭐☆ 4/5

  **Justification:** pwnthemall es una opción interesante para desplegar una plataforma CTF propia en una máquina virtual de OpenStack. Facilita la creación y administración de retos personalizados mediante Docker y YAML. Sin embargo, no sustituye un cyber range empresarial completo, no dispone de integración nativa confirmada con OpenStack y su licencia y estado de desarrollo deben considerarse antes de adoptarlo.

\---

### 4\. VulnHub

* **Type:** Virtual Machine (VM) / Vulnerable Lab
* **Website:** https://www.vulnhub.com/
* **License:** Varies by machine and original author
* **Open-Source:** ⚠️ Varies by machine
* **Replicable:** ✅ High
* **Editable:** ⚠️ Medium
* **Scenario Diversity:**

  * **Scenario 1: Boot-to-Root Challenges**

    * Máquinas virtuales vulnerables diseñadas para practicar reconocimiento, explotación de servicios, escalamiento de privilegios y obtención de acceso root. Algunas máquinas incluyen archivos de bandera (flags) que el participante debe encontrar.
  * **Scenario 2: Vulnerable Services and Web Applications**

    * Laboratorios que contienen servicios de red, servidores web, aplicaciones vulnerables y configuraciones inseguras. Los participantes pueden investigar las vulnerabilidades y practicar su explotación en un entorno controlado.
* **Monitoring Support:**

  * **Tool 1: Virtual Machine Logs**

    * Los registros del sistema operativo invitado pueden utilizarse para analizar eventos y actividades, dependiendo de la máquina descargada y de las herramientas instaladas.
  * **Tool 2: External Monitoring Tools**

    * Se pueden instalar herramientas externas de monitorización, IDS o SIEM en una infraestructura de laboratorio para observar el tráfico y los eventos. VulnHub no proporciona una plataforma centralizada de monitorización propia.
* **OpenStack Compatibility:**

  * **Deployment Method:** Importación o conversión de imágenes de máquinas virtuales, cuando el formato y la licencia lo permitan.
  * **Notes:**

    * VulnHub ofrece máquinas virtuales en formatos como OVA, OVF, VMDK e ISO, según el laboratorio.
    * OpenStack puede ejecutar máquinas virtuales a partir de imágenes compatibles con sus servicios de cómputo, pero algunas imágenes requieren conversión y ajustes.
    * Las imágenes OVA/OVF no siempre se pueden importar directamente como una imagen lista para ejecutar; puede ser necesario extraer y convertir el disco.
    * Se deben revisar el formato, los requisitos de arranque, la configuración de red y la licencia de cada máquina.
    * No existe una integración nativa general de VulnHub con OpenStack.
* **Pros:**

  * Gran catálogo de máquinas virtuales vulnerables creadas por diferentes autores.
  * Diversos niveles de dificultad, desde principiante hasta avanzado.
  * Permite practicar ataques de red, explotación de servicios y escalamiento de privilegios.
  * Las máquinas pueden descargarse y ejecutarse en entornos virtualizados compatibles.
  * Algunas máquinas incluyen objetivos concretos, como encontrar flags o conseguir acceso root.
  * Útil para laboratorios prácticos de ciberseguridad y aprendizaje individual.
* **Cons:**

  * No es una plataforma centralizada para orquestar cyber ranges.
  * La licencia y las posibilidades de modificación dependen de cada máquina y de su autor.
  * No todas las imágenes están preparadas para ejecutarse directamente en OpenStack.
  * La calidad de la documentación, los objetivos y las instrucciones varía entre laboratorios.
  * No incluye un sistema centralizado de puntuación, gestión de equipos o monitorización.
  * Algunas máquinas pueden depender de versiones antiguas de sistemas operativos o software.
* **Final Score:** ⭐⭐⭐⭐☆ 4/5

  **Justification:** VulnHub es una buena fuente de máquinas virtuales vulnerables para crear laboratorios de ciberseguridad y practicar técnicas de explotación. Es útil para desplegar escenarios individuales en una infraestructura propia, aunque requiere trabajo adicional para integrarlos en OpenStack y no ofrece por sí solo la administración centralizada de un cyber range.

\---

### 5\. Vikings: 1

* **Type:** Virtual Machine (VM) / CTF Challenge
* **Website:** https://www.vulnhub.com/entry/vikings-1,741/
* **License:** Not specified on the VulnHub entry; check the author's terms.
* **Open-Source:** ⚠️ Not confirmed
* **Replicable:** ✅ High
* **Editable:** ⚠️ Medium
* **Scenario Diversity:**

  * **Scenario 1: Boot-to-Root Challenge**

    * Máquina Linux vulnerable diseñada para practicar reconocimiento de servicios, enumeración, explotación y escalamiento de privilegios hasta obtener acceso root.
  * **Scenario 2: Web Enumeration and Digital Forensics**

    * Incluye desafíos de enumeración web y análisis de archivos, con pistas que requieren identificar contenido codificado, extraer archivos y recuperar credenciales.
* **Monitoring Support:**

  * **Tool 1: Linux System Logs**

    * Es posible revisar los registros del sistema Linux para analizar determinados eventos, dependiendo de la configuración de la máquina.
  * **Tool 2: External Monitoring Tools**

    * Se pueden añadir herramientas externas, como Wireshark, Zeek o un SIEM, para observar el tráfico y los eventos del laboratorio. Estas herramientas no vienen incluidas como parte de Vikings: 1.
* **OpenStack Compatibility:**

  * **Deployment Method:** Importación o conversión de la imagen de máquina virtual OVA a un formato compatible con OpenStack.
  * **Notes:**

    * La descarga oficial es `Vikings.ova`, de aproximadamente 1.7 GB.
    * La máquina utiliza Linux y tiene DHCP habilitado para asignar automáticamente una dirección IP.
    * El autor indica que funciona mejor con VirtualBox que con VMware.
    * Para usarla en OpenStack, será necesario extraer o convertir el disco virtual y comprobar el formato, el controlador de almacenamiento, el arranque y la configuración de red.
    * No existe una integración nativa con OpenStack documentada en la página de Vikings: 1.
* **Pros:**

  * Descarga disponible desde VulnHub.
  * Incluye varios retos de hacking en una sola máquina.
  * Permite practicar enumeración, explotación y escalamiento de privilegios.
  * Es útil para ejercicios CTF individuales.
  * Permite desarrollar habilidades de análisis de servicios y archivos.
  * Puede utilizarse como base para un laboratorio aislado de ciberseguridad.
* **Cons:**

  * Está diseñado como una máquina individual, no como una plataforma de cyber range.
  * No proporciona un sistema centralizado de puntuación ni gestión de equipos.
  * No incluye herramientas de monitorización defensiva.
  * La compatibilidad con OpenStack requiere adaptación y pruebas, ya que no incluye una guia.
  * La licencia y las posibilidades de modificación no están confirmadas en la ficha del laboratorio.
  * La página recomienda VirtualBox, por lo que podrían ser necesarios ajustes para otros hipervisores.
* **Final Score:** ⭐⭐⭐☆☆ 3/5

  **Justification:** Vikings: 1 es una buena máquina para practicar técnicas de hacking y retos CTF en Linux. Sin embargo, para un proyecto que necesita desplegar y administrar múltiples escenarios en OpenStack, requiere trabajo adicional de conversión, configuración y monitorización.

\---

### 6\. StratoCyberLab

* **Type:** Cyber Range / Docker Containers
* **Website:** https://github.com/stratosphereips/stratocyberlab
* **License:** GNU General Public License v2.0 (GPL-2.0)
* **Open-Source:** ✅ Yes
* **Replicable:** ✅ High
* **Editable:** ✅ High
* **Scenario Diversity:**

  * **Scenario 1: Capture The Flag (CTF) Challenges**

    * Ofrece retos locales de ciberseguridad que permiten practicar técnicas de reconocimiento, explotación y resolución de desafíos. Incluye una interfaz web para gestionar los retos y enviar flags.
  * **Scenario 2: Network and Service Environments**

    * Proporciona entornos de red y servicios predefinidos para actividades educativas de seguridad informática. Los contenedores comparten redes virtuales para permitir la interacción entre los servicios y la máquina de ataque.
* **Monitoring Support:**

  * **Tool 1: Web Dashboard**

    * Permite gestionar los desafíos, iniciar o detenerlos y enviar flags. También ofrece acceso a una terminal WebSSH integrada.
  * **Tool 2: Observability Plugin**

    * El repositorio incluye un directorio `plugins/observability` para ampliar las capacidades de observación del laboratorio. Las funciones concretas disponibles dependen de la implementación del plugin; no debe asumirse que incluye un SIEM o IDS completo.
* **OpenStack Compatibility:**

  * **Deployment Method:** Docker Compose inside an OpenStack virtual machine.
  * **Notes:**

    * El README indica que StratoCyberLab está diseñado para ejecutarse localmente mediante Docker y que no ofrece despliegue cloud nativo.
    * Puede probarse dentro de una instancia Linux de OpenStack instalando Docker y Git.
    * La documentación estima como requisitos mínimos 3 GB de espacio en disco y 2 GB de RAM libre.
    * El despliegue inicial se realiza mediante `docker compose up`.
    * Se requiere acceso al motor Docker y configuración adecuada de las redes de contenedores.
    * No se encontró evidencia de integración nativa con OpenStack, plantillas Heat oficiales ni un proveedor de aprovisionamiento específico.
    * El README advierte que el dashboard necesita acceso al socket de Docker, lo que le otorga un elevado nivel de control sobre el host. Se recomienda ejecutarlo dentro de una VM aislada.
* **Pros:**

  * Código abierto bajo licencia GPL-2.0.
  * Instalación sencilla mediante Docker Compose.
  * Incluye desafíos CTF y entornos de red predefinidos.
  * Dispone de interfaz web para administrar los retos.
  * Incorpora una máquina de ataque en contenedor, separada del sistema anfitrión.
  * Permite añadir plugins de terceros.
  * El código fuente y los escenarios pueden estudiarse y modificarse.
* **Cons:**

  * Está diseñado principalmente para ejecutarse de manera local, no como servicio cloud nativo.
  * No ofrece integración nativa confirmada con OpenStack.
  * La ejecución simultánea de muchos desafíos puede consumir recursos importantes.
  * El acceso al socket de Docker representa un riesgo de seguridad si el entorno no está aislado.
  * No debe considerarse una plataforma SIEM o IDS completa sin integrar herramientas adicionales.
* **Final Score:** ⭐⭐⭐⭐☆ 4/5

  **Justification:** StratoCyberLab es una buena opción para un proyecto universitario que requiera retos CTF y escenarios de red reproducibles. Su despliegue mediante Docker Compose facilita la instalación dentro de una VM de OpenStack, aunque la plataforma no dispone de integración nativa con OpenStack y requiere aislamiento y configuración adicional para su uso en la nube.

\---

### 7\. Atomic Red Team

* **Nombre de la herramienta:** Atomic Red Team
* **Página web:** https://github.com/redcanaryco/atomic-red-team
* **Licencia:** MIT
* **Código abierto:** ✅ yes
* **Replicable:** ✅ High
* **Editable:** ✅ High
* **Diversidad de escenarios:**

  * **Escenario 1:** Pruebas de descubrimiento de redes para evaluar si las herramientas defensivas detectan actividades sospechosas de reconocimiento.
  * **Escenario 2:** Pruebas de ejecución de procesos para evaluar si las herramientas defensivas detectan actividades sospechosas en el sistema.
* **Soporte de monitoreo:**

  * **Herramienta 1:** Wazuh — recopilación de registros y generación de alertas de seguridad.
  * **Herramienta 2:** Splunk — análisis de eventos y monitoreo de seguridad.
  * *Nota: Estas herramientas de monitoreo no están incluidas en Atomic Red Team.*
* **Compatibilidad con OpenStack:**

  * **Método de despliegue:** Instalar y ejecutar Atomic Red Team dentro de una máquina virtual compatible desplegada en OpenStack.
  * **Observaciones:** No cuenta con integración nativa documentada con OpenStack. La compatibilidad depende del sistema operativo de la máquina virtual, los permisos, las dependencias y los requisitos de cada prueba.
* **Ventajas:**

  * Pruebas basadas en técnicas de MITRE ATT\&CK.
  * Permite realizar pruebas de seguridad repetibles.
  * Facilita la modificación de pruebas existentes y la creación de nuevas.
  * Ayuda a evaluar antivirus, EDR y otros mecanismos defensivos.
  * Puede utilizarse en máquinas virtuales alojadas en OpenStack.
* **Desventajas:**

  * No es una plataforma CTF tradicional.
  * No proporciona un entorno completo de Red Team vs. Blue Team.
  * No incluye un SIEM ni un panel completo de monitoreo propio.
  * Algunas pruebas requieren permisos elevados o configuraciones adicionales.
* **Puntuación final:** ⭐⭐⭐⭐☆ 4/5

  **Justificación:** Obtiene 4 de 5 estrellas porque ofrece pruebas reproducibles, modificables y basadas en técnicas reconocidas. Sin embargo, necesita herramientas externas para el monitoreo y una infraestructura adicional para construir un laboratorio completo de ciberseguridad.

\---

### 8\. CTFd

* **Tool Name:** CTFd
* **Type:** Plataforma de administración de competencias CTF (Capture The Flag).
* **Website:** https://github.com/CTFd/CTFd
* **License:** Apache-2.0
* **Open-Source:** ✅ Yes
* **Replicable:** ✅ High
* **Editable:** ✅ High
* **Scenario Diversity:**

  * **Scenario 1:** Retos de explotación web en los que los participantes deben encontrar vulnerabilidades y obtener una bandera.
* **Scenario 2:** Retos de criptografía o análisis forense digital en los que los participantes deben resolver un problema y presentar la bandera correspondiente.
* **Monitoring Support:**

  * **Tool 1:** Wazuh — recopilación de registros y generación de alertas de seguridad.
  * **Tool 2:** Prometheus — recopilación de métricas de infraestructura y servicios.
  * **Note:** Estas herramientas son complementarias y requieren una instalación independiente.
* **OpenStack Compatibility:**

  * **Deployment Method:** Deploy CTFd inside a Linux virtual machine on OpenStack using Docker or Docker Compose.
  * **Notes:** No cuenta con integración nativa documentada con OpenStack. Los servidores, contenedores o máquinas vulnerables necesarios para los retos pueden requerir infraestructura adicional.
* **Pros:**

  * Facilita la organización de competencias CTF individuales o por equipos.
  * Permite crear retos, pistas y banderas personalizadas.
  * Incluye un marcador automático y estadísticas de progreso.
  * Admite plugins y temas personalizados.
  * Puede desplegarse en una máquina virtual alojada en OpenStack.
* **Cons:**

  * No proporciona por sí solo todas las máquinas vulnerables necesarias para los retos.
  * No es una plataforma completa de simulación Red Team vs. Blue Team.
  * No incluye un sistema propio de detección de intrusiones ni monitoreo completo de red.
  * Los retos que requieren servicios o contenedores independientes necesitan configuración adicional.
  * La integración con OpenStack requiere preparar la infraestructura.
* **Final Score:** ⭐⭐⭐⭐☆ (4/5)

  **Justification:** CTFd obtiene una puntuación de 4/5 porque es una plataforma de código abierto que permite administrar competencias CTF, personalizar retos y automatizar la puntuación de los participantes. Su despliegue mediante Docker facilita su instalación en una máquina virtual de OpenStack. Sin embargo, no proporciona por sí solo toda la infraestructura vulnerable ni herramientas completas de monitoreo, por lo que necesita componentes adicionales para construir un laboratorio de ciberseguridad más completo.

\---

# 

# Summary Table

|Tool Name|Type|Open-Source|Replicable|Editable|Scenario Diversity|Monitoring Support|OpenStack Compatibility|
|-|-|-|-|-|-|-|-|
|Tool 1|VM/Container|✅ Yes|⚠️ Medium|✅ High|High|✅ Yes|✅ High|
|Tool 2|Cyber Range|✅ Yes|✅ High|⚠️ Medium|Medium|❌ No|⚠️ Medium|
|Tool 3|Container|✅ Yes|✅ High|✅ High|Low|✅ Yes|✅ High|

\---

## Recommendation

Based on the evaluation, the recommended tool for deployment in OpenStack is:
**\[OWASP juice shop]
Reasoning:**

* \[Es fácil de descargar y incluye como hacerlo]
* \[Tiene una gran cantidad de ejercicio de CTF y vulnerabilidades]
* \[Se pueden crear niveles propios]
* \[Tiene una facilidad para practicas con maquinas virtuales a través de Docker]
* \[No tiene integración nativa sino que es necesario mediante maquina virtual y Docker]

\---

**\[StratoCyberLab]**

* \[Proporciona un laboratorio practico para CTF]
* \[tiene una web que gestiona tus logros y banderas capturados a través de webSSH]
* \[Los códigos fuentes se pueden estudiar y modificarse]
* \[una desventaja seria que no esta hecho para cloud nativo sino que esta hecho para la red local y necesita de maquina virtual y docker]

\---

**\[Atomic Red Team]**

* \[Es diferente a los demás porque prueba si las defensas se activan con ataques]
* \[Es un complemento para probar defensas de las otras plataformas]
* \[Se puede combinar con otros como Cyber Range para crear escenarios]

\---

**\[CTFd]**

* \[Administra banderas, equipos, puntuaciones, y lo que hace el jugador]
* \[Puedes alojar CTFd a otros programas para que el programa tenga los beneficios de CFTd]
* \[Permite crear banderas, pistas y retos]
* \[Esta limitado en herramientas ya que no los trae consigo como lo son Wazuh, y Prometheus]

\---

## References

* [Link 1: GitHub Repository juice-shop](https://github.com/juice-shop/juice-shop)
* [link 2: Official Documentation Juice-shop](https://pwning.owasp-juice.shop/)
* [link 3: OWASP Project Page, Juice-shop](https://owasp.org/projects/juice-shop)
* [link 4: Official GitHub Repository Orion-range](https://github.com/eniokrauss/Orion-range)
* [link 5: README Orion-range](https://github.com/eniokrauss/Orion-range/blob/main/README.md)
* [link 6: License Orion-range](https://github.com/eniokrauss/Orion-range/blob/main/LICENSE)
* [link 7: Roadmap Orion-range](https://github.com/eniokrauss/Orion-range/blob/main/ROADMAP.md)
* [link 8: GitHub Repository pwnthemall](https://github.com/pwnthemall/pwnthemall)
* [link 9: Installation Guide pwnthemall](https://docs-pwnthemall.gitbook.io/pta/1-installation)
* [link 10: Usage Guide pwnthemall](https://docs-pwnthemall.gitbook.io/pta/3-usage)
* [link 11: License pwnthemall](https://github.com/pwnthemall/pwnthemall/blob/main/LICENSE)
* [link 12: Official Website vulnhub](https://www.vulnhub.com/)
* [link 13: About VulnHub](https://www.vulnhub.com/about/)
* [link 14: Frequently Asked Questions vulnhub](https://www.vulnhub.com/faq/)
* [link 15: Official VulnHub Entry — Vikings: 1](https://www.vulnhub.com/entry/vikings-1,741/)
* [link 16: Vikings.ova vulnhub](https://download.vulnhub.com/vikings/Vikings.ova)
* [link 17: Vikings: 1 Walkthrough — NepCodeX](https://nepcodex.com/2021/09/vikings-writeup-vulnhub-walkthrough/)
* [link 18: Official GitHub Repository — StratoCyberLab](https://github.com/stratosphereips/stratocyberlab)
* [link 19: StratoCyberLab README](https://github.com/stratosphereips/stratocyberlab/blob/main/README.md)
* [link 20: StratoCyberLab Development Documentation](https://github.com/stratosphereips/stratocyberlab/blob/main/docs/development.md)
* [link 21: StratoCyberLab Plugins Documentation](https://github.com/stratosphereips/stratocyberlab/blob/main/docs/plugins.md)
* [link 22: StratoCyberLab Docker Compose Configuration](https://github.com/stratosphereips/stratocyberlab/blob/main/docker-compose.yml)
* [link 22: Repositorio oficial de Atomic Red Team](https://github.com/redcanaryco/atomic-red-team)
* [link 23: Documentación oficial — Introducción Atomic Red Team](https://www.atomicredteam.io/docs/atomic-red-team)
* [link 24: Documentación oficial — Diseño de pruebas Atomic Red Team](https://www.atomicredteam.io/docs/atomic-red-team/designing-atomic-tests)
* [link 25: Preguntas frecuentes oficiales Atomic Red Team](https://www.atomicredteam.io/docs/atomic-red-team/faq)
* [link 26: Licencia del proyecto Atomic Red Team](https://github.com/redcanaryco/atomic-red-team/blob/master/LICENSE.txt)
* [link 27: Official CTFd GitHub Repository](https://github.com/CTFd/CTFd)
* [link 28: Official CTFd README](https://github.com/CTFd/CTFd/blob/master/README.md)
* [link 29: Official CTFd Getting Started Guide](https://github.com/CTFd/CTFd/wiki/Getting-Started)
* [link 30: Official CTFd Docker Image](https://hub.docker.com/r/ctfd/ctfd)
* [link 31: Official CTFd License](https://github.com/CTFd/CTFd/blob/master/LICENSE)

