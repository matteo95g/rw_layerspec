# Resource Watch Layerspec Service

[![Build Status](https://travis-ci.org/resource-watch/rw_layerspec.svg?branch=staging)](https://travis-ci.org/resource-watch/rw_layerspec) [![Code Climate](https://codeclimate.com/github/resource-watch/rw_layerspec/badges/gpa.svg)](https://codeclimate.com/github/resource-watch/rw_layerspec)

TODO: Write a project description

## Installation

Requirements:

* Ruby 2.3.1 [How to install](https://gorails.com/setup/osx/10.10-yosemite)
* [MongoDB](https://www.mongodb.org/)

Install global dependencies:

    gem install bundler

Install project dependencies:

    bundle install

## Usage

First time execute:

    cp config/mongoid.yml.sample config/mongoid.yml

To run application:

    bundle exec rails server

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
