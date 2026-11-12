# Guía de instalación e integración de OWASP Juice Shop, StratoCyberLab y CTFd

## 1. Objetivo

Este instructivo explica cómo instalar tres herramientas de ciberseguridad utilizando Docker y cómo integrar los ejercicios de OWASP Juice Shop y StratoCyberLab en CTFd.

Al finalizar, se tendrá:

- OWASP Juice Shop para practicar vulnerabilidades web.
- StratoCyberLab para practicar ciberseguridad en un entorno de laboratorio.
- CTFd para administrar los desafíos, registrar banderas y llevar la puntuación.
- Dos archivos CSV independientes para importar los ejercicios de ambas plataformas.

**Importante:** la integración se realiza mediante la exportación e importación de archivos CSV. No se establece una sincronización automática entre las plataformas.

## 2. Requisitos

### 2.1. Requisitos de hardware

Se recomienda contar con:

- Procesador de al menos 2 núcleos.
- 8 GB de RAM o más para ejecutar simultáneamente los servicios con mayor comodidad.
- Al menos 10 GB de espacio libre para las imágenes y los datos.
- Conexión a Internet para descargar las imágenes y repositorios.

StratoCyberLab estima como requisitos mínimos 3 GB de espacio y 2 GB de RAM disponible, aunque el consumo aumenta al iniciar varios escenarios.

### 2.2. Software necesario

- Windows 10 u 11 compatible con WSL 2.
- Ubuntu instalado mediante WSL 2.
- Docker Desktop.
- Git.
- Python 3.

---

## 3. Instalación de WSL 2 y Docker Desktop

Esta guía utiliza Windows con Ubuntu en WSL 2.

### 3.1. Instalar WSL 2

1. Abrir PowerShell como administrador.
2. Ejecutar:

```powershell
wsl --install
```

3. Reiniciar el equipo si Windows lo solicita.
4. Abrir Ubuntu y crear el usuario y contraseña de Linux.

Para actualizar WSL:

```powershell
wsl --update
```

Para comprobar la versión:

```powershell
wsl --version
```

Y para verificar que Ubuntu utiliza WSL 2:

```powershell
wsl -l -v
```

La columna VERSION debe mostrar `2`.

Si Ubuntu aparece con versión 1, ejecutar desde PowerShell:

```powershell
wsl --set-version Ubuntu 2
```

### 3.2. Descargar e instalar Docker Desktop

1. Abrir la página oficial de Docker:

   https://www.docker.com/products/docker-desktop/

2. Descargar Docker Desktop para Windows.
3. Ejecutar el instalador.
4. Seleccionar el motor basado en WSL 2 cuando aparezca esa opción.
5. Finalizar la instalación y abrir Docker Desktop.

### 3.3. Habilitar la integración con Ubuntu

Dentro de Docker Desktop:

1. Abrir **Settings**.
2. Entrar en **General**.
3. Comprobar que esté habilitado **Use the WSL 2 based engine**.
4. Entrar en **Resources → WSL Integration**.
5. Habilitar la integración con Ubuntu.
6. Seleccionar **Apply**.

### 3.4. Comprobar Docker

Abrir la terminal de Ubuntu y ejecutar:

```bash
docker --version
```

Después:

```bash
docker compose version
```

Finalmente:

```bash
docker run hello-world
```

Si Docker funciona correctamente, aparecerá un mensaje indicando que la instalación se realizó correctamente.

### 3.5. Instalar herramientas auxiliares

En Ubuntu ejecutar:

```bash
sudo apt update
sudo apt install -y git python3
```

Comprobar:

```bash
git --version
python3 --version
```

---

## 4. Instalar OWASP Juice Shop

OWASP Juice Shop es una aplicación web intencionalmente vulnerable que permite practicar diferentes tipos de ataques y resolver desafíos relacionados con la seguridad web.

### 4.1. Descargar la imagen

Ejecutar:

```bash
docker pull bkimminich/juice-shop
```

Este comando descarga la imagen oficial de Juice Shop desde Docker Hub.

### 4.2. Crear y ejecutar el contenedor

```bash
docker run -d --name juice-shop --restart unless-stopped -p 3000:3000 bkimminich/juice-shop
```

Explicación:

- `-d`: ejecuta el contenedor en segundo plano.
- `--name juice-shop`: asigna un nombre al contenedor.
- `--restart unless-stopped`: permite que se reinicie automáticamente.
- `-p 3000:3000`: publica el puerto 3000.

### 4.3. Acceder a Juice Shop

Abrir el navegador y visitar:

http://localhost:3000

Deberá aparecer la tienda web de Juice Shop.

### 4.4. Verificar los desafíos

Ejecutar en Ubuntu:

```bash
curl -s http://localhost:3000/api/Challenges
```

Para obtener solamente el número de desafíos:

```bash
curl -s http://localhost:3000/api/Challenges | python3 -c "import sys,json; print(len(json.load(sys.stdin)['data']))"
```

La instalación está lista cuando la API responde correctamente y devuelve los desafíos.

---

## 5. Instalar StratoCyberLab

StratoCyberLab es un entorno local de simulación de ciberseguridad que permite practicar técnicas ofensivas y defensivas mediante escenarios y desafíos.

### 5.1. Descargar el repositorio

Desde Ubuntu ejecutar:

```bash
git clone https://github.com/stratosphereips/stratocyberlab.git
```

Entrar en la carpeta:

```bash
cd stratocyberlab
```

El repositorio contiene, entre otros elementos:

- `challenges`: desafíos.
- `campaigns`: campañas.
- `classes`: clases y material de aprendizaje.
- `dashboard`: interfaz web.
- `hackerlab`: entorno de terminal para practicar.

### 5.2. Iniciar StratoCyberLab

Ejecutar:

```bash
docker compose up -d
```

Docker descargará o construirá las imágenes necesarias y levantará los servicios.

Para comprobar los contenedores:

```bash
docker ps
```

### 5.3. Acceder al panel

Abrir:

http://localhost/

Desde el panel se podrán consultar los desafíos, iniciar escenarios y utilizar la terminal integrada.

### 5.4. Verificar el funcionamiento

Buscar el desafío **Hello World** y ejecutarlo.

Completar la prueba de envío de bandera para confirmar que el laboratorio funciona.

**Nota:** StratoCyberLab utiliza varios puertos, entre ellos 80, 8080, 2222 y 2223. Si alguno está ocupado, será necesario revisar la configuración de `docker-compose.yml` antes de iniciar el laboratorio.

---

## 6. Instalar CTFd

CTFd es una plataforma para administrar competencias Capture The Flag. Permite registrar desafíos, categorías, banderas, pistas, puntuaciones y participantes.

### 6.1. Descargar el repositorio oficial

Desde Ubuntu, regresar al directorio principal:

```bash
cd ~
```

Clonar el repositorio:

```bash
git clone https://github.com/CTFd/CTFd.git
```

Entrar en la carpeta:

```bash
cd CTFd
```

### 6.2. Configurar la clave secreta

CTFd necesita una clave secreta para su configuración.

Generar una clave aleatoria:

```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```

Copiar el resultado y configurarlo como `SECRET_KEY` en el servicio CTFd del archivo `docker-compose.yml`, siguiendo la documentación oficial.

No compartir esta clave públicamente.

### 6.3. Iniciar CTFd

Desde la carpeta del repositorio:

```bash
docker compose up -d
```

Comprobar que los servicios estén funcionando:

```bash
docker ps
```

### 6.4. Acceder a CTFd

Abrir:

http://localhost:8000

La primera vez aparecerá el asistente de configuración.

Completar los datos solicitados:

- Nombre de la competencia.
- Nombre de usuario administrador.
- Correo electrónico.
- Contraseña.

Al terminar, se podrá acceder al panel de administración.

---

## 7. Exportar los desafíos de OWASP Juice Shop a CTFd

Juice Shop cuenta con una herramienta oficial llamada `juice-shop-ctf-cli`, que permite generar un archivo CSV compatible con CTFd.

Esta herramienta obtiene los desafíos mediante la API de Juice Shop y genera las banderas correspondientes utilizando la clave CTF.

### 7.1. Crear una carpeta de trabajo

En Ubuntu:

```bash
mkdir -p ~/ctf-lab
cd ~/ctf-lab
```

### 7.2. Obtener la clave de Juice Shop

Para garantizar que las banderas generadas coincidan con las que reconoce la instalación local, copiar el archivo `ctf.key` desde el contenedor:

```bash
docker cp juice-shop:/juice-shop/ctf.key ./ctf.key
```

El archivo contiene una clave secreta. No se debe publicar ni compartir.

### 7.3. Crear el archivo de configuración

Crear el archivo de configuración usando Python:

```bash
python3 - <<'PY'
import json

with open("ctf.key", "r", encoding="utf-8") as f:
    key = f.read().strip()

with open("juice-shop-ctf.yml", "w", encoding="utf-8") as f:
    f.write("ctfFramework: CTFd\n")
    f.write("juiceShopUrl: http://host.docker.internal:3000\n")
    f.write("ctfKey: " + json.dumps(key) + "\n")
    f.write("insertHints: none\n")

print("Archivo de configuración creado correctamente.")
PY
```

La dirección `host.docker.internal` permite que el contenedor exportador se comunique con Juice Shop, que está publicado en el puerto 3000 del equipo.

### 7.4. Generar el CSV

Ejecutar:

```bash
docker run --rm -it \
  -v "$PWD:/data" \
  --add-host=host.docker.internal:host-gateway \
  bkimminich/juice-shop-ctf \
  --config /data/juice-shop-ctf.yml \
  --output /data/JuiceShop.CTFd.csv
```

La herramienta consultará Juice Shop y generará el archivo:

`JuiceShop.CTFd.csv`

El archivo contiene los desafíos, categorías, puntuaciones y banderas necesarias para importarlos a CTFd.

### 7.5. Comprobar el archivo

Ejecutar:

```bash
ls -lh JuiceShop.CTFd.csv
```

También se puede revisar el número de registros:

```bash
python3 -c "import csv; print('Desafíos:', sum(1 for _ in csv.DictReader(open('JuiceShop.CTFd.csv', encoding='utf-8-sig'))))"
```

Para la instalación utilizada como referencia se obtuvieron 118 desafíos.

**Importante:** si se cambia la clave CTF de Juice Shop, será necesario volver a generar el CSV para que las banderas coincidan.

---

## 8. Exportar los desafíos de StratoCyberLab a CTFd

StratoCyberLab almacena la información de sus desafíos y tareas en una base de datos SQLite.

Para convertirlos al formato CSV de CTFd se utilizará un script de Python.

### 8.1. Identificar la base de datos

El archivo de base de datos se encuentra dentro del contenedor del dashboard:

`/var/opt/app/data/db.sqlite3`

En la instalación utilizada como referencia, el contenedor se llama `scl-dashboard`.

### 8.2. Crear el script de exportación

Desde Ubuntu, en otra terminal:

```bash
cd ~/ctf-lab
nano export_stratocyberlab_ctfd.py
```

Pegar el siguiente código:

```python
import sqlite3
import csv
import json
from collections import Counter

DB_PATH = "/var/opt/app/data/db.sqlite3"
OUTPUT_PATH = "/tmp/StratoCyberLab.CTFd.csv"

POINTS = {
    "easy": 100,
    "medium": 200,
    "hard": 300
}

connection = sqlite3.connect(
    f"file:{DB_PATH}?mode=ro",
    uri=True
)

connection.row_factory = sqlite3.Row

query = """
SELECT
    t.task_id,
    t.task_name,
    t.task_description,
    t.flag,
    t.task_order,
    c.challenge_name,
    c.challenge_description,
    c.difficulty,
    c.tags
FROM tasks AS t
JOIN challenges AS c
    ON t.challenge_id = c.challenge_id
ORDER BY c.challenge_name, t.task_order
"""

rows = connection.execute(query).fetchall()

if not rows:
    raise RuntimeError("No se encontraron tareas.")

headers = [
    "name",
    "description",
    "category",
    "value",
    "type",
    "state",
    "max_attempts",
    "flags",
    "tags",
    "type_data",
    "hints"
]

difficulty_counts = Counter()
categories = set()

with open(
    OUTPUT_PATH,
    "w",
    newline="",
    encoding="utf-8"
) as file:

    writer = csv.DictWriter(file, fieldnames=headers)
    writer.writeheader()

    for row in rows:
        difficulty = (row["difficulty"] or "").strip().lower()

        if difficulty not in POINTS:
            raise ValueError(
                f"Dificultad no reconocida: {difficulty}"
            )

        if not row["flag"]:
            raise ValueError(
                f"El reto {row['task_name']} no tiene bandera."
            )

        try:
            tags_data = json.loads(row["tags"] or "[]")
            tags = ",".join(tags_data)
        except (json.JSONDecodeError, TypeError):
            tags = row["tags"] or ""

        description = "\n\n".join(
            part for part in [
                row["challenge_description"],
                row["task_description"]
            ] if part
        )

        flag_data = [{
            "type": "static",
            "content": row["flag"],
            "data": None
        }]

        writer.writerow({
            "name": row["task_name"],
            "description": description,
            "category": row["challenge_name"],
            "value": POINTS[difficulty],
            "type": "standard",
            "state": "visible",
            "max_attempts": 0,
            "flags": json.dumps(flag_data),
            "tags": tags,
            "type_data": "",
            "hints": ""
        })

        difficulty_counts[difficulty] += 1
        categories.add(row["challenge_name"])

connection.close()

print("Exportación completada.")
print("Tareas exportadas:", len(rows))
print("Categorías:", len(categories))
print("Dificultades:", dict(difficulty_counts))
print("Archivo:", OUTPUT_PATH)
```

Guardar el archivo y salir del editor.

### 8.3. Copiar el script al contenedor

Ejecutar:

```bash
docker cp export_stratocyberlab_ctfd.py scl-dashboard:/tmp/export_stratocyberlab_ctfd.py
```

### 8.4. Ejecutar el script

```bash
docker exec scl-dashboard python3 /tmp/export_stratocyberlab_ctfd.py
```

El programa consultará la base de datos en modo de solo lectura y generará un CSV.

El resultado mostrará:

- Cantidad de tareas exportadas.
- Cantidad de categorías.
- Distribución de dificultades.
- Ruta del archivo generado.

### 8.5. Copiar el CSV a Ubuntu

```bash
docker cp scl-dashboard:/tmp/StratoCyberLab.CTFd.csv ./StratoCyberLab.CTFd.csv
```

Comprobar que se haya creado:

```bash
ls -lh StratoCyberLab.CTFd.csv
```

En la instalación utilizada como referencia se exportaron 29 tareas pertenecientes a 17 categorías.

**Nota:** el script está basado en la estructura SQLite de la versión de StratoCyberLab utilizada durante el proyecto. Si una versión futura modifica las tablas o los campos, será necesario adaptar la consulta.

---

## 9. Importar los ejercicios a CTFd

Una vez generados los archivos CSV, se pueden importar los desafíos desde el panel de administración de CTFd.

### 9.1. Importar los ejercicios de Juice Shop

1. Abrir http://localhost:8000.
2. Iniciar sesión como administrador.
3. Entrar en **Admin Panel**.
4. Abrir **Config → Backup**.
5. Buscar la opción **Import CSV**.
6. Seleccionar el tipo de datos **Challenges**.
7. Elegir el archivo `JuiceShop.CTFd.csv`.
8. Presionar **Import**.
9. Esperar a que termine el proceso.

### 9.2. Importar los ejercicios de StratoCyberLab

Repetir el procedimiento anterior, pero seleccionar:

`StratoCyberLab.CTFd.csv`

De esta manera, los desafíos de ambas plataformas estarán registrados en CTFd.

**Precaución:** revisar los desafíos existentes antes de importar. No repetir una importación sin comprobar primero si ya se añadieron los registros, para evitar duplicados.

---

## 10. Comprobar la integración

Después de importar ambos archivos, se debe comprobar que los ejercicios aparezcan correctamente.

### 10.1. Verificar la cantidad de desafíos

Desde el panel de administración de CTFd, entrar en **Challenges** y revisar los registros importados.

En la instalación de referencia:

| Plataforma | Desafíos importados |
|---|---:|
| OWASP Juice Shop | 118 |
| StratoCyberLab | 29 |
| **Total** | **147** |

El total puede variar si las versiones de las plataformas contienen más o menos desafíos.

### 10.2. Probar un desafío de Juice Shop

1. Abrir Juice Shop.
2. Resolver un desafío sencillo.
3. Obtener la bandera generada.
4. Abrir CTFd.
5. Buscar el desafío correspondiente.
6. Introducir la bandera en el campo de envío.

CTFd debe aceptar la bandera y registrar los puntos.

### 10.3. Probar un desafío de StratoCyberLab

1. Abrir StratoCyberLab.
2. Iniciar el desafío Hello World.
3. Completar la prueba de envío.
4. Copiar la bandera correspondiente.
5. Buscar el desafío importado en CTFd.
6. Enviar la bandera.

Si CTFd acepta la bandera, la importación se realizó correctamente.

---

## 11. Comandos útiles para administrar los contenedores

### Ver los contenedores activos

```bash
docker ps
```

### Ver todos los contenedores

```bash
docker ps -a
```

### Detener un contenedor

```bash
docker stop juice-shop
```

### Iniciar un contenedor detenido

```bash
docker start juice-shop
```

### Consultar los registros

```bash
docker logs juice-shop
```

### Detener StratoCyberLab

Desde la carpeta del repositorio:

```bash
docker compose stop
```

### Iniciar StratoCyberLab

```bash
docker compose up -d
```

**Importante:** no eliminar contenedores ni volúmenes de CTFd sin realizar previamente una copia de seguridad de sus datos.

---

## 12. Consideraciones de seguridad

- Utilizar estos entornos únicamente para prácticas autorizadas.
- No exponer Juice Shop ni StratoCyberLab directamente a Internet sin aislamiento y controles adecuados.
- No compartir las claves privadas de Juice Shop ni la clave secreta de CTFd.
- No publicar archivos de configuración que contengan claves.
- Mantener respaldos de la base de datos de CTFd.
- Evitar iniciar demasiados escenarios de StratoCyberLab simultáneamente si el equipo tiene recursos limitados.
- Para eventos con varios participantes, tener en cuenta que Juice Shop es una aplicación de un solo usuario y que cada participante debería contar con su propia instancia.

---

## 13. Resultado final

Se instalaron tres herramientas de ciberseguridad mediante Docker: OWASP Juice Shop, StratoCyberLab y CTFd.

Se generaron archivos CSV compatibles con CTFd para incorporar los ejercicios de ambas plataformas. Posteriormente, se importaron los desafíos y se verificó su funcionamiento mediante el envío de banderas de prueba.

La integración permite centralizar la gestión y puntuación de los ejercicios desde CTFd, mientras que las plataformas originales continúan proporcionando sus respectivos entornos de práctica.

## 14. Fuentes oficiales

1. [Docker Desktop para Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
2. [Integración de Docker Desktop con WSL 2](https://docs.docker.com/desktop/features/wsl/)
3. [OWASP Juice Shop - Repositorio oficial](https://github.com/juice-shop/juice-shop)
4. [OWASP Juice Shop - Ejecución con Docker](https://help.owasp-juice.shop/part1/running.html)
5. [OWASP Juice Shop CTF Extension](https://github.com/juice-shop/juice-shop-ctf)
6. [OWASP Juice Shop - Guía para organizar un CTF](https://pwning.owasp-juice.shop/companion-guide/latest/part4/ctf.html)
7. [StratoCyberLab - Repositorio oficial](https://github.com/stratosphereips/stratocyberlab)
8. [CTFd - Repositorio oficial](https://github.com/CTFd/CTFd)
9. [CTFd - Documentación de instalación](https://docs.ctfd.io/docs/deployment/installation/)
