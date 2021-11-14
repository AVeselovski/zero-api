# ZERO-API

REST API for the ZeroCluster (placeholder name).

## Docs

https://zero-cluster-api.herokuapp.com/docs

## Development setup

Rails and Docker must be installed. Project uses Dockerized PostgreSQL as a local development & testing database. Assuming project has dependencies installed (`bundle install`):

Create git ignored `config/local_env.yml` with `JWT_SECRET_KEY: "Secret key here"`.

First terminal window:

- `docker-compose up`

Second terminal window:

- `rails db:create`
- `rails db:migrate`
- `rails s`

## Tests

This project uses Rails default `Minitest` for testing. Run tests with `rails test`.

## Dev notes

Heroku instance cannot read `Rails.application.secrets.secret_key_base` due to reasons. Using manual secret keys instead ([this commit](https://github.com/AVeselovski/zero-api/commit/6f767fe5b49510d4c31dc09be0f94b92ec6909b3)).

Apipie is lame and seems to be outdated, but simple enough to setup, so it will do for now.
