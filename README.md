# silvio
[![Build Status](https://travis-ci.org/skateman/silvio.svg?branch=master)](https://travis-ci.org/skateman/silvio)

Silvio is a VPN-over-WebSocket implementation, based on the TUN interface. I am using it to connect all my devices to a single virtual network through a web service. According to [Wikpiedia](https://en.wikipedia.org/wiki/Silvio_Pellico), Silvio (Pellico) was an Italian writer, poet, dramatist and patriot active in the Italian unification. The street where I am currently living is named after him.

## Installation

The code is written in Crystal and uses SQLite to store the information about the networks and clients, these are the two main requirements. You can build both the server and the client with the following command:
```sh
shards build
```

## Usage

### Server

For now, you have to use Ruby scripts to run the migrations. There's also an interactive console to create database objects using `ActiveRecord`:

```sh
bundle install
export DATABASE_PATH=path/to/your/db/file
bin/rake db:migrate
bin/console
```

If your database is ready, you can start the server with the following command:
```
bin/silvio-server -d path/to/your/db/file
```
The server by default listens on `0.0.0.0:8090`, you can get more information about how to tweak this if you pass the `--help` argument.

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
* Migrations written in Crystal instead of ActiveRecord
* REST API for clients & networks CRUD
* Static frontend for the REST API
* Support for other database types
* Tests, tests and tests
* OpenShift template

## License

This project is released under the MIT license.
