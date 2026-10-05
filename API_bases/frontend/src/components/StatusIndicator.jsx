function StatusIndicator({ status }) {
  return (
    <div className={`status-indicator ${status.toLowerCase()}`}>
      <span className="status-dot"></span>
      <span>{status}</span>
    </div>
  );
}

export default StatusIndicator;