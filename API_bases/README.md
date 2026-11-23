Pagina de ollama introduction API: https://docs.ollama.com/api/introduction

Uses in javaScript: https://github.com/ollama/ollama-js 

# API Flask + Ollama

API desarrollada con Flask que permite enviar mensajes a un servidor remoto de Ollama y obtener respuestas de un modelo de inteligencia artificial.

## Arquitectura

La API Flask se ejecuta en una computadora y se conecta a Ollama en otra computadora de la misma red.

```text
Computadora 1
┌─────────────────────────────┐
│ Flask API                   │
│ Puerto: 5000                │
│                             │
│ POST /chat                  │
│ GET  /health                │
└──────────────┬──────────────┘
               │
               │ HTTP
               ▼
Computadora 2
┌─────────────────────────────┐
│ Ollama                      │
│ IP: 10.49.12.56              │
│ Puerto: 11434               │
│                             │
│ gemma3:latest               │
└─────────────────────────────┘
```

---

# 1. Requisitos

Se necesita tener instalado:

* Python 3
* pip
* Python venv
* Flask
* Librería Python de Ollama
* Ollama en la computadora remota
* Modelo `gemma3:latest`

---

# 2. Verificar Python

```bash
python3 --version
```

También se puede verificar pip:

```bash
python3 -m pip --version
```

---

# 3. Instalar herramientas para Python

En Ubuntu/Debian:

```bash
sudo apt update
sudo apt install python3-full python3-venv
```

---

# 4. Entrar al proyecto

```bash
cd ~/HubResources/API_bases
```

Verificar los archivos:

```bash
ls
```

El proyecto debe contener al menos:

```text
API_bases/
└── API.py
```

---

# 5. Crear un entorno virtual

Debido a que Ubuntu utiliza PEP 668 y bloquea la instalación global mediante `pip`, se recomienda utilizar un entorno virtual.

Crear el entorno:

```bash
python3 -m venv venv
```

---

# 6. Activar el entorno virtual

```bash
source venv/bin/activate
```

La terminal debe mostrar algo similar a:

```text
(venv) yayo@DESKTOP-GTRIGJV:~/HubResources/API_bases$
```

---

# 7. Instalar las dependencias

Con el entorno virtual activado:

```bash
pip install flask ollama
```

También se puede actualizar pip:

```bash
pip install --upgrade pip
```

Verificar las instalaciones:

```bash
pip list
```

---

# 8. Verificar la conexión con Ollama

Ollama se encuentra en otra computadora con la siguiente dirección:

```text
http://10.49.12.56:11434
```

Probar la conexión:

```bash
curl http://10.49.12.56:11434
```

También se pueden consultar los modelos disponibles:

```bash
curl http://10.49.12.56:11434/api/tags
```

La respuesta debe mostrar los modelos disponibles.

Por ejemplo:

```json
{
  "models": [
    {
      "name": "gemma3:latest"
    }
  ]
}
```

---

# 9. Verificar que Gemma3 esté disponible

Buscar específicamente el modelo:

```bash
curl http://10.49.12.56:11434/api/tags
```

Debe aparecer:

```text
gemma3:latest
```

En caso de que no exista, instalarlo directamente en la computadora donde está Ollama:

```bash
ollama pull gemma3
```

Verificar:

```bash
ollama list
```

---

# 10. Ejecutar la API Flask

Con el entorno virtual activado:

```bash
python API.py
```

La API Flask se ejecutará en el puerto:

```text
5000
```

Mientras que Ollama continuará utilizando:

```text
11434
```

Por lo tanto:

```text
Flask  →  puerto 5000
Ollama →  puerto 11434
```

No se debe utilizar el puerto `11434` para Flask, ya que ese puerto pertenece al servidor de Ollama.

---

# 11. Probar Flask

Abrir otra terminal y entrar al proyecto:

```bash
cd ~/HubResources/API_bases
```

Activar el entorno virtual:

```bash
source venv/bin/activate
```

Probar el endpoint principal:

```bash
curl http://localhost:5000/
```

Respuesta esperada:

```json
{
  "message": "API funcionando correctamente"
}
```

---

# 12. Probar el endpoint Health

Ejecutar:

```bash
curl http://localhost:5000/health
```

Respuesta esperada:

```json
{
  "status": "up"
}
```

Esto indica que la API Flask está funcionando y que el cliente de Ollama pudo inicializarse correctamente.

---

# 13. Probar el endpoint Chat

El endpoint `/chat` utiliza el método `POST`.

Ejecutar:

```bash
curl -X POST http://localhost:5000/chat \
-H "Content-Type: application/json" \
-d '{"message":"Hola, ¿cómo estás?"}'
```

Respuesta esperada:

```json
{
  "response": "..."
}
```

El contenido de `response` será generado por `gemma3:latest`.

---

# 14. Probar con otro mensaje

Por ejemplo:

```bash
curl -X POST http://localhost:5000/chat \
-H "Content-Type: application/json" \
-d '{"message":"Explica qué es inteligencia artificial en una oración."}'
```

---

# 15. Probar desde otra computadora

Si otra computadora necesita consumir la API Flask, primero obtener la IP de la computadora donde Flask está ejecutándose:

```bash
hostname -I
```

Por ejemplo:

```text
10.49.12.40
```

Entonces la API estará disponible en:

```text
http://10.49.12.40:5000
```

Health:

```bash
curl http://10.49.12.40:5000/health
```

Chat:

```bash
curl -X POST http://10.49.12.40:5000/chat \
-H "Content-Type: application/json" \
-d '{"message":"Hola"}'
```

---

# 16. Detener la API

Para detener Flask:

```text
Ctrl + C
```

---

# 17. Desactivar el entorno virtual

Cuando se termine de trabajar:

```bash
deactivate
```

---

# 18. Volver a ejecutar el proyecto

En una nueva sesión:

```bash
cd ~/HubResources/API_bases
source venv/bin/activate
python API.py
```

---

# 19. Solución de problemas

## Error: `ModuleNotFoundError: No module named 'ollama'`

Activar el entorno virtual:

```bash
source venv/bin/activate
```

Instalar Ollama:

```bash
pip install ollama
```

Comprobar:

```bash
python -c "import ollama; print('Ollama instalado correctamente')"
```

---

## Error: `externally-managed-environment`

No instalar paquetes directamente en el Python del sistema.

Crear un entorno virtual:

```bash
python3 -m venv venv
```

Activarlo:

```bash
source venv/bin/activate
```

Instalar las dependencias:

```bash
pip install flask ollama
```

---

## Error `404 NOT FOUND`

Verificar que se esté utilizando una ruta existente.

La API cuenta con:

```text
GET  /
GET  /health
POST /chat
```

Por ejemplo:

```bash
curl http://localhost:5000/health
```

Para `/chat` se debe utilizar `POST`, no abrirlo directamente desde el navegador.

---

## Error de conexión con Ollama

Probar directamente:

```bash
curl http://10.49.12.56:11434
```

Después:

```bash
curl http://10.49.12.56:11434/api/tags
```

Si estos comandos funcionan, la comunicación entre las dos computadoras está funcionando.

---

# 20. Resumen de comandos

Instalación inicial:

```bash
sudo apt update
sudo apt install python3-full python3-venv

cd ~/HubResources/API_bases

python3 -m venv venv
source venv/bin/activate

pip install flask ollama
```

Verificar Ollama:

```bash
curl http://10.49.12.56:11434
curl http://10.49.12.56:11434/api/tags
```

Ejecutar API:

```bash
source venv/bin/activate
python API.py
```

Probar Flask:

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
```

Probar IA:

```bash
curl -X POST http://localhost:5000/chat \
-H "Content-Type: application/json" \
-d '{"message":"Hola, ¿cómo estás?"}'
```

Detener:

```text
Ctrl + C
```

Salir del entorno virtual:

```bash
deactivate
```
