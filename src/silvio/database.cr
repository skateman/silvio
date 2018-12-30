require "sqlite3"
require "crecto"

module Silvio::Database
  extend Crecto::Repo

  config do |conf|
    conf.adapter = Crecto::Adapters::SQLite3
    conf.uri = "sqlite3://#{ENV["DATABASE_PATH"]}"
  end

  class Network < Crecto::Model
    schema "networks" do
      field :name, String
      field :address, String
      field :netmask, String
      has_many :clients, Client
    end

    validate_required [:name, :address, :netmask]
  end

  class Client < Crecto::Model
    schema "clients" do
      field :name, String
      field :token, String
      field :address, String
      belongs_to :network, Network
    end

    unique_constraint :token
    validate_required [:name, :address, :token, :network_id]
  end
end
