require "../silvio"
require "tuntap"
require "http/web_socket"
require "../http/web_socket"
require "../http/web_socket/protocol"

class Silvio::Client
  getter :address, :netmask

  @ws : HTTP::WebSocket
  @tun : Tuntap::Device
  @address : String
  @netmask : String

  def initialize(@url : String, @token : String)
    @ws = connect_ws(@url, @token)
    @address = @ws.response_headers[IP]
    @netmask = @ws.response_headers[NETMASK]
    @tun = create_tun
    @tun.up!
    @tun.add_address(@address)
    @tun.add_netmask(@netmask)
  end

  def run
    spawn do # WS -> TUN
      @ws.on_binary do |msg|
        @tun.write(msg)
      end

      @ws.run
    end

    spawn do # TUN -> WS
      loop do
        packet = @tun.read_packet
        @ws.send(packet.frame)
      end
    end

    # Send a ping every 60 seconds to keep the connection alive
    loop do
      @ws.ping
      sleep 60
    end
  end

  private def connect_ws(url : String, token : String) : HTTP::WebSocket
    headers = HTTP::Headers.new
    headers[TOKEN] = @token
    HTTP::WebSocket.new(@url, headers)
  end

  private def create_tun
    Tuntap::Device.open flags: LibC::IfReqFlags.flags(Tun, NoPi)
  end
end
