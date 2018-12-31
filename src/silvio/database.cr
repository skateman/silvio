require "pg"
require "crecto"
require "micrate"

module Silvio::Database
  extend Crecto::Repo

  config do |conf|
    conf.adapter = Crecto::Adapters::Postgres
    conf.uri = ENV["DATABASE_PATH"]
    # Run the migrations before accessing the database
    Micrate::DB.connection_url = conf.uri
    Micrate::Cli.run_up
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
