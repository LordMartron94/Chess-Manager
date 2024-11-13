defmodule HoornLogger do
  @moduledoc """
Logger is a module to help logging over the CBAf.
"""
  defp construct_log(log_level, message, force_show, module_separator) do
    payload = Payload.create("log_#{log_level}", [
      {"string", message},
      {"bool", "#{force_show}"},
      {"string", ""},
      {"string", module_separator},
    ])

    log = MessageHandler.construct_advanced_message(payload)
    log
  end

  def debug(socket, message, force_show \\ false, module_separator \\ "ChessCoach.ChessManager") do
    log = construct_log("debug", message, force_show, module_separator)
    TCPClient.send_request(socket, log, "<eom>")
  end

  def info(socket, message, force_show \\ false, module_separator \\ "ChessCoach.ChessManager") do
    log = construct_log("info", message, force_show, module_separator)
    TCPClient.send_request(socket, log, "<eom>")
  end

  def warn(socket, message, force_show \\ false, module_separator \\ "ChessCoach.ChessManager") do
    log = construct_log("warning", message, force_show, module_separator)
    TCPClient.send_request(socket, log, "<eom>")
  end

  def error(socket, message, force_show \\ false, module_separator \\ "ChessCoach.ChessManager") do
    log = construct_log("error", message, force_show, module_separator)
    TCPClient.send_request(socket, log, "<eom>")
  end

  def critical(socket, message, force_show \\ false, module_separator \\ "ChessCoach.ChessManager") do
    log = construct_log("critical", message, force_show, module_separator)
    TCPClient.send_request(socket, log, "<eom>")
  end
end