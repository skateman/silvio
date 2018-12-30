require "option_parser"

ENV["CRYSTAL_ENV"] ||= "development"

config = {
  :path => "db/#{ENV["CRYSTAL_ENV"]}.sqlite3",
  :bind => "0.0.0.0",
  :port => 8090,
}

OptionParser.parse! do |p|
  p.banner = "Usage: silvio-server [arguments]"
  p.on("-d DATABASE", "--database DATABASE", "Path to the database file") { |path| config[:path] = path }
  p.on("-b ADDRESS", "--bind ADDRESS", "IP address to listen on, defaults to 0.0.0.0") { |bind| config[:bind] = bind }
  p.on("-p PORT", "--port PORT", "Port to listen on, defaults to 8090") { |port| config[:port] = port }
  p.on("-h", "--help", "Show this help") do
    puts p
    exit 0
  end
end

ENV["DATABASE_PATH"] ||= config[:path].to_s

require "./silvio"
require "./silvio/api"
require "./silvio/server"

server = HTTP::Server.new([HTTP::ErrorHandler.new(true), HTTP::LogHandler.new, Silvio::API.new, Silvio::Server.new])
server.bind_tcp(config[:bind].to_s, config[:port].to_i)
server.listen
