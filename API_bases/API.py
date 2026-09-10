from flask import Flask, request, jsonify
import ollama

app = Flask(__name__)

# Configuración de Ollama
OLLAMA_MODEL = "gemma3:latest"
OLLAMA_URL = "http://10.49.12.56:11434"

# Inicializa Ollama
try:
    ollama_client = ollama.Client(host=OLLAMA_URL)

    # Verifica que el modelo exista
    ollama_client.show(OLLAMA_MODEL)

    print("Conexión con Ollama establecida correctamente")

except Exception as e:
    print(f"Error initializing Ollama: {e}")
    ollama_client = None


@app.route('/')
def home():
    return jsonify({
        "message": "API funcionando correctamente"
    })


@app.route('/health', methods=['GET'])
def health():
    if ollama_client is None:
        return jsonify({
            "status": "down"
        }), 503

    return jsonify({
        "status": "up"
    }), 200


@app.route('/chat', methods=['POST'])
def chat():
    if ollama_client is None:
        return jsonify({
            "error": "Ollama no está inicializado correctamente"
        }), 500

    try:
        data = request.get_json()

        if not data or "message" not in data:
            return jsonify({
                "error": "Se requiere un mensaje"
            }), 400

        message = data["message"]

        response = ollama_client.generate(
            model=OLLAMA_MODEL,
            prompt=message
        )

        return jsonify({
            "response": response["response"]
        })

    except Exception as e:
        print(f"Error generating response: {e}")

        return jsonify({
            "error": f"Error al generar respuesta: {str(e)}"
        }), 500


if __name__ == '__main__':
    app.run(
        debug=True,
        host='0.0.0.0',
        port=5000
    )