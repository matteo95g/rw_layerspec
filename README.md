# Resource Watch Layerspec Service

[![Build Status](https://travis-ci.org/resource-watch/rw_layerspec.svg?branch=master)](https://travis-ci.org/resource-watch/rw_layerspec) [![Code Climate](https://codeclimate.com/github/resource-watch/rw_layerspec/badges/gpa.svg)](https://codeclimate.com/github/resource-watch/rw_layerspec)

TODO: Write a project description

## Installation

Requirements:

* Ruby 2.3.1 [How to install](https://gorails.com/setup/osx/10.10-yosemite)
* [MongoDB](https://www.mongodb.org/)

## Usage

### Natively

Install global dependencies:

    gem install bundler

Install project dependencies:

    bundle install

First time execute:

    cp config/mongoid.yml.sample config/mongoid.yml
    cp env.sample .env

To run application:

    bundle exec rails server

### Using Docker

### Requirements for docker

If You are going to use containers, You will need:

- [Docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/)

## Executing

Start by checking out the project from github

```
git clone https://github.com/Vizzuality/rw_layerspec.git
cd rw_layerspec
```

You can either run the application natively, or inside a docker container.

To setup the project on docker:

```
./service develop
```

To run the tests on docker:

```
./service test
```

## TEST

  Run rspec:

    bin/rspec

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b feature/my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/my-new-feature`
5. Submit a pull request :D

### BEFORE CREATING A PULL REQUEST

  Please check all of [these points](https://github.com/resource-watch/rw_layerspec/blob/master/CONTRIBUTING.md).
