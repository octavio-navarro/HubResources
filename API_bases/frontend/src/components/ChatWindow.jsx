function ChatWindow({ messages }) {
  return (
    <div className="chat-window">
      {messages.length === 0 ? (
        <div className="empty-chat">
          <h2>¡Hola!</h2>
          <p>Escribe un mensaje para comenzar.</p>
        </div>
      ) : (
        messages.map((message) => (
          <div
            key={message.id}
            className={`message ${message.sender}`}
          >
            <div className="message-sender">
              {message.sender === "user" ? "Tú" : "Ollama"}
            </div>

            <div className="message-text">
              {message.text}
            </div>
          </div>
        ))
      )}
    </div>
  );
}

export default ChatWindow;