function InputForm({
  inputMessage,
  setInputMessage,
  sendMessage,
  isLoading,
}) {
  const handleSubmit = (event) => {
    event.preventDefault();
    sendMessage();
  };

  return (
    <form className="input-form" onSubmit={handleSubmit}>
      <input
        type="text"
        value={inputMessage}
        onChange={(event) => setInputMessage(event.target.value)}
        placeholder="Escribe tu mensaje..."
        disabled={isLoading}
      />

      <button
        type="submit"
        disabled={isLoading || !inputMessage.trim()}
      >
        {isLoading ? "Enviando..." : "Enviar"}
      </button>
    </form>
  );
}

export default InputForm;