require "../silvio"
require "tuntap"
require "http/server"
require "./database"

class Silvio::Server < HTTP::WebSocketHandler
  def initialize
    @clients = {} of String => HTTP::WebSocket

    super do |sock, context|
      network = context.response.headers[NETWORK]
      address = context.response.headers[IP]
      src = [network, address].join('@')
      @clients[src] = sock

      sock.on_binary do |msg|
        packet = Tuntap::IpPacket.new(msg, false)

        dst = [network, packet.destination_address].join('@')
        @clients[dst].send(msg) if @clients.has_key?(dst)
      end

      sock.on_close do
        @clients.delete(src)
      end
    end
  end

  def call(context)
    if context.request.headers.has_key?(TOKEN)
      token = context.request.headers[TOKEN]

      if client = client_from_token(token)
        context.response.headers[IP] = client.address!
        context.response.headers[NETMASK] = client.network.netmask!
        context.response.headers[NETWORK] = client.network.id.to_s

        return super(context)
      end
    end

    context.response.respond_with_error("Unauthorized", 401)
    call_next(context)
  end

  private def client_from_token(token : String) : Database::Client | Nil
    Database.get_by(Database::Client, Crecto::Repo::Query.where(token: token).preload(:network))
  end
end
