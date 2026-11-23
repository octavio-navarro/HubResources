import { useState, useEffect } from "react";
import axios from "axios";
import ChatWindow from "./components/ChatWindow";
import InputForm from "./components/InputForm";
import StatusIndicator from "./components/StatusIndicator";

import "./App.css";

const API_URL = import.meta.env.VITE_API_URL;
const API_KEY = import.meta.env.VITE_API_KEY;

function App() {

  const [messages, setMessages] = useState([]);
  const [inputMessage, setInputMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");
  const [status, setStatus] = useState("Offline");

  const [ollamaModel, setOllamaModel] = useState(
    "gemma3:latest"
  );

  const [temperature, setTemperature] = useState(0.7);

  // Encabezados que se utilizarán en las solicitudes
  const authHeaders = {
    Authorization: `Bearer ${API_KEY}`
  };

  // Verificar conexión con Flask
  useEffect(() => {

    const checkHealth = async () => {

      try {

        await axios.get(
          `${API_URL}/health`,
          {
            headers: authHeaders
          }
        );

        setStatus("Online");

      } catch (err) {

        console.error(err);
        setStatus("Offline");

      }

    };

    checkHealth();

  }, []);

  // Enviar mensaje a Flask
  const sendMessage = async () => {

    const message = inputMessage.trim();

    if (!message || isLoading) return;

    setIsLoading(true);
    setError("");
    setStatus("Loading");

    // Agregar mensaje del usuario
    const userMessage = {
      id: Date.now(),
      sender: "user",
      text: message,
    };

    setMessages((previousMessages) => [
      ...previousMessages,
      userMessage,
    ]);

    setInputMessage("");

    try {

      const response = await axios.post(
        `${API_URL}/chat`,
        {
          message: message,
          model: ollamaModel,
          temperature: temperature,
        },
        {
          headers: {
            ...authHeaders,
            "Content-Type": "application/json"
          }
        }
      );

      if (response.data.response) {

        const ollamaMessage = {
          id: Date.now() + 1,
          sender: "ollama",
          text: response.data.response,
        };

        setMessages((previousMessages) => [
          ...previousMessages,
          ollamaMessage,
        ]);

        setStatus("Online");

      } else {

        setError("La API no devolvió una respuesta.");
        setStatus("Offline");

      }

    } catch (err) {

      console.error(err);

      setError(
        err.response?.data?.error ||
        "No se pudo conectar con la API Flask."
      );

      setStatus("Offline");

    } finally {

      setIsLoading(false);

    }

  };

  return (
    <div className="app-container">

      <header className="app-header">

        <h1>Ollama</h1>

        <p>gemma3</p>

      </header>

      <main className="chat-container">

        <ChatWindow messages={messages} />

        {error && (
          <div className="error-message">
            {error}
          </div>
        )}

        <InputForm
          inputMessage={inputMessage}
          setInputMessage={setInputMessage}
          sendMessage={sendMessage}
          isLoading={isLoading}
        />

        <StatusIndicator status={status} />

      </main>

    </div>
  );
}

export default App;
