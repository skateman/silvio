class HTTP::WebSocket::Protocol
  getter :response_headers

  def initialize(@io : IO, masked = false, @response_headers = HTTP::Headers.new)
    @header = uninitialized UInt8[2]
    @mask = uninitialized UInt8[4]
    @mask_offset = 0
    @opcode = Opcode::CONTINUATION
    @remaining = 0_u64
    @masked = !!masked
  end

  def self.new(host : String, path : String, port = nil, tls = false, headers = HTTP::Headers.new)
    {% if flag?(:without_openssl) %}
      if tls
        raise "WebSocket TLS is disabled because `-D without_openssl` was passed at compile time"
      end
    {% end %}

    port = port || (tls ? 443 : 80)

    socket = TCPSocket.new(host, port)
    begin
      {% if !flag?(:without_openssl) %}
        if tls
          if tls.is_a?(Bool) # true, but we want to get rid of the union
            context = OpenSSL::SSL::Context::Client.new
          else
            context = tls
          end
          socket = OpenSSL::SSL::Socket::Client.new(socket, context: context, sync_close: true, hostname: host)
        end
      {% end %}

      random_key = Base64.strict_encode(StaticArray(UInt8, 16).new { rand(256).to_u8 })

      headers["Host"] = "#{host}:#{port}"
      headers["Connection"] = "Upgrade"
      headers["Upgrade"] = "websocket"
      headers["Sec-WebSocket-Version"] = VERSION
      headers["Sec-WebSocket-Key"] = random_key

      path = "/" if path.empty?
      handshake = HTTP::Request.new("GET", path, headers)
      handshake.to_io(socket)
      socket.flush
      handshake_response = HTTP::Client::Response.from_io(socket)
      unless handshake_response.status_code == 101
        raise Socket::Error.new("Handshake got denied. Status code was #{handshake_response.status_code}.")
      end

      challenge_response = Protocol.key_challenge(random_key)
      unless handshake_response.headers["Sec-WebSocket-Accept"]? == challenge_response
        raise Socket::Error.new("Handshake got denied. Server did not verify WebSocket challenge.")
      end
    rescue exc
      socket.close
      raise exc
    end

    new(socket, masked: true, response_headers: handshake_response.headers)
  end
end
