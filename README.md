# meetup-generator [![Build Status](https://travis-ci.org/snltd/meetup-generator.svg?branch=master)](https://travis-ci.org/snltd/meetup-generator) [![Maintainability](https://api.codeclimate.com/v1/badges/4487595d6afb26a57d82/maintainability)](https://codeclimate.com/github/snltd/meetup-generator/maintainability)

A very small, very stupid Sinatra app which generates a wholly plausible
agenda for a fictional DevOps meetup.

Now includes API!

```sh
$ curl -s localhost:4567/api/talk | json
{
  "talk": "Dockerizing Dockerized Docker with Docker for Docker Users",
  "talker": "David Thomas",
  "role": "Open Source Dragonslayer",
  "company": "prognosticatr.io"
}
```

## Building

Build a gem with

```sh
$ rake build
```

## Running

Install from Rubygems

```
$ gem install meetup-generator
```

then run with

```
$ rackup $(locate_meetup-generator)
```

Run from a git checkout

```
$ bin/meetup-generator.rb
```

Install as a Solaris/Illumos service

```
$ pfexec svccfg import package/meetup-generator.xml
```

Contributing

Fork it, raise a PR.
