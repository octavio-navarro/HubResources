import os
import secrets
from functools import wraps

from dotenv import load_dotenv
from flask import Flask, request, jsonify
from flask_cors import CORS
import ollama


# Cargar variables de entorno
load_dotenv()


# Configuración
API_KEY = os.getenv("API_KEY")
OLLAMA_HOST = os.getenv(
    "OLLAMA_HOST",
    "http://10.49.12.56:11434"
)
OLLAMA_MODEL = os.getenv(
    "OLLAMA_MODEL",
    "gemma3:latest"
)
FLASK_PORT = int(os.getenv("FLASK_PORT", "5000"))


# Validar que exista la API Key
if not API_KEY:
    raise RuntimeError(
        "No se encontró API_KEY en el archivo .env"
    )


# Crear aplicación Flask
app = Flask(__name__)
CORS(app)


# Cliente de Ollama remoto
client = ollama.Client(host=OLLAMA_HOST)


# Middleware para validar la API Key
def require_api_key(function):
    @wraps(function)
    def decorated_function(*args, **kwargs):

        auth_header = request.headers.get("Authorization")

        if not auth_header:
            return jsonify({
                "error": "Falta el encabezado Authorization"
            }), 401

        parts = auth_header.split(" ", 1)

        if len(parts) != 2 or parts[0].lower() != "bearer":
            return jsonify({
                "error": "Formato de Authorization inválido"
            }), 401

        provided_key = parts[1].strip()

        # Comparación segura de claves
        if not secrets.compare_digest(provided_key, API_KEY):
            return jsonify({
                "error": "API Key inválida"
            }), 401

        return function(*args, **kwargs)

    return decorated_function


# Ruta pública para comprobar que Flask funciona
@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "API de chat funcionando"
    }), 200


# Ruta de salud protegida
@app.route("/health", methods=["GET"])
@require_api_key
def health():
    return jsonify({
        "status": "ok",
        "ollama_host": OLLAMA_HOST,
        "model": OLLAMA_MODEL
    }), 200


# Ruta protegida para enviar mensajes a Ollama
@app.route("/chat", methods=["POST"])
@require_api_key
def chat():

    data = request.get_json(silent=True)

    if not data:
        return jsonify({
            "error": "El cuerpo de la solicitud debe ser JSON"
        }), 400

    message = data.get("message", "").strip()
    model = data.get("model", OLLAMA_MODEL)
    temperature = data.get("temperature", 0.7)

    if not message:
        return jsonify({
            "error": "El mensaje no puede estar vacío"
        }), 400

    try:
        response = client.generate(
            model=model,
            prompt=message,
            options={
                "temperature": temperature
            }
        )

        return jsonify({
            "response": response["response"],
            "model": model
        }), 200

    except Exception as error:
        print(f"Error al comunicarse con Ollama: {error}")

        return jsonify({
            "error": "No se pudo obtener una respuesta de Ollama"
        }), 500


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=FLASK_PORT,
        debug=False
    )