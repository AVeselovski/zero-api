# ZERO-API

REST API for the ZeroCluster (placeholder name).

## Setup

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
