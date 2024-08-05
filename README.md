# meetup-generator

[![Test](https://github.com/snltd/meetup-generator/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/snltd/meetup-generator/actions/workflows/test.yml) [![Build and Release to Docker Hub](https://github.com/snltd/meetup-generator/actions/workflows/release-dockerhub.yml/badge.svg)](https://github.com/snltd/meetup-generator/actions/workflows/release-dockerhub.yml) [![Build and Release to Rubygems](https://github.com/snltd/meetup-generator/actions/workflows/release-rubygems.yml/badge.svg)](https://github.com/snltd/meetup-generator/actions/workflows/release-rubygems.yml) [![Gem Version](https://badge.fury.io/rb/meetup-generator.svg)](https://badge.fury.io/rb/meetup-generator)

Built on an immutable polyglot femtoservice architecture, meetup-generator
melds Deep ML with the power of the Blockchain to deliver planetscale insights
into the direction of the most disruptive tech. On Kubernetes.

Or is it just hundred lines of Ruby putting random words into a template?

## API

```sh
$ curl -s localhost:4567/api/talk | json
{
  "talk": "Dockerizing Dockerized Docker with Docker for Docker Users",
  "talker": "David Thomas",
  "role": "Open Source Dragonslayer",
  "company": "prognosticatr.io"
}
```
## Running

```sh
$ docker run -p 8080:8080 snltd/meetup-generator:latest
```

## Building

Build a gem with

```sh
$ rake build
```

Build a container with

```sh
$ docker build -t latest .
```

## Running

Install and run from Rubygems

```sh
$ gem install meetup-generator
$ rackup $(locate_meetup-generator)
```

Run from a git checkout

```sh
$ bin/meetup-generator.rb
```

Install as a Solaris/Illumos service

```sh
$ pfexec svccfg import package/meetup-generator.xml
```

## Contributing

Fork it, raise a PR.
