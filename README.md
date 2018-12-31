# silvio
[![Build Status](https://travis-ci.org/skateman/silvio.svg?branch=master)](https://travis-ci.org/skateman/silvio)

Silvio is a VPN-over-WebSocket implementation, based on the TUN interface. I am using it to connect all my devices to a single virtual network through a web service. According to [Wikpiedia](https://en.wikipedia.org/wiki/Silvio_Pellico), Silvio (Pellico) was an Italian writer, poet, dramatist and patriot active in the Italian unification. I spent some time of my life on a street that was named after him.

## Installation

The code is written in Crystal and uses PostgreSQL to store the information about the networks and clients You can build the server and the client using following command:
```sh
shards build
```

## Usage

### Server

The server requires an empty PostgreSQL database it can be started with the following command:
```
bin/silvio-server -d postgres://user:pass@host:port/db
```
The server by default listens on `0.0.0.0:8090`, you can get more information about how to tweak this if you pass the `--help` argument. Defining clients and networks is possible through the REST API:

```json
# POST /networks
{
  "name": "test-net",
  "address": "192.168.10.0",
  "netmask": "255.255.255.0"
}

# POST /networks/1/clients
{
  "name": "test-client",
  "address": "192.168.10.1"
}
```

### Client

The client uses TUN as the virtual network interface so it needs to run as a privileged user. There are two required arguments, the URL pointing to the server and a unique token stored in the database:
```sh
bin/silvio-client ws://<host>:<port> <token>
```

## Development

After cloning the repository, you can install the dependencies by running `shards` and `bundle`. There are no unit tests, if they become available you will be able to run them using `crystal spec`. There is a high-level test in `spec/ping/test-server.sh` that requires `docker` and tests if two clients can ping each other.

## Contributing

1. Fork it (<https://github.com/skateman/silvio/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Here are some ideas for contributions:
* Storing IP addresses as numbers instead of strings
* Optional traffic routing to the Internet (SOCKS-like)
* Support for IPv6
* Authentication for the REST API
* Static frontend for the REST API
* Load-balancing between multiple instances
* Tests, tests and tests
* OpenShift template
* Support for Windows and OSX

## License

This project is released under the MIT license.
