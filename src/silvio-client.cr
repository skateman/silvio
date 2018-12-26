require "./silvio"
require "./silvio/client"

abort("Usage: silvio-client <url> <token>") if ARGV.size != 2

url = ARGV[0]
token = ARGV[1]

client = Silvio::Client.new(url, token)
client.run
