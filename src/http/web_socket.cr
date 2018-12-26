class HTTP::WebSocket
  delegate :response_headers, to: @ws
end
