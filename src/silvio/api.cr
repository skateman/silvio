require "../silvio"
require "router"
require "json"
require "./database"
require "./api_helper"

class Silvio::API
  include Router
  include ApiHelper

  def self.new
    api = super
    api.draw_routes
    api.route_handler
  end

  def draw_routes
    json_get("/networks", network_list)
    json_get("/networks/:network_id", network_show)
    json_get("/networks/:network_id/clients", client_list)
    json_get("/networks/:network_id/clients/:client_id", client_show)

    json_post("/networks", network_create)
    json_post("/networks/:network_id/clients", client_create)

    json_put("/networks/:network_id", network_update)
    json_put("/networks/:network_id/clients/:client_id", client_update)

    json_delete("/networks/:network_id", network_delete)
    json_delete("/networks/:network_id/clients/:client_id", client_delete)
  end

  private def network_list(params)
    Database.all(Database::Network)
  end

  private def network_show(params)
    Database.get!(Database::Network, params["network_id"])
  end

  private def client_list(params)
    Database.all(Database::Client, Crecto::Repo::Query.new.where(network_id: params["network_id"]))
  end

  private def client_show(params)
    Database.get_by!(Database::Client, id: params["client_id"], network_id: params["network_id"])
  end

  private def network_create(params)
    merge_params(Database::Network.new, params, name, address, netmask)
  end

  private def client_create(params)
    client = Database::Client.new
    client.token = Random.new.base64(128)
    merge_params(client, params, name, address, network_id)
  end

  private def network_update(params)
    network = Database.get!(Database::Network, params["network_id"])
    merge_params(network, params, name, address, netmask)
  end

  private def client_update(params)
    client = Database.get_by!(Database::Client, network_id: params["network_id"], id: params["client_id"])
    merge_params(client, params, name, address)
  end

  private def network_delete(params)
    network = Database.get!(Database::Network, params["network_id"])
    Database.delete(network)
  end

  private def client_delete(params)
    client = Database.get_by!(Database::Client, network_id: params["network_id"], id: params["client_id"])
    Database.delete(client)
  end

  macro merge_params(model, params, *keys)
    obj = {{ model }}

    {% for key in keys %}
      obj.{{ key }} = params["{{ key }}"] if params.has_key?("{{ key }}")
    {% end %}

    obj
  end
end
