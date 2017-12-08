# meetup-generator [![Build Status](https://travis-ci.org/snltd/meetup-generator.svg?branch=master)](https://travis-ci.org/snltd/meetup-generator) [![Maintainability](https://api.codeclimate.com/v1/badges/4487595d6afb26a57d82/maintainability)](https://codeclimate.com/github/snltd/meetup-generator/maintainability) [![Dependency Status](https://gemnasium.com/badges/github.com/snltd/meetup-generator.svg)](https://gemnasium.com/github.com/snltd/meetup-generator)

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

Includes SMF manifest for your SunOS pleasure.

Pull requests welcome.
