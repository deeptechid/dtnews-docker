# dtnews Docker

Docker configuration for dtnews

## Usage

### Using dtnews docker build.

This will serve up dtnews at http://localhost:3000/

1. Run database

Option 1: Use official mariadb image (without replication)

```
docker run --name dtnews-db \
  -v dtnews_data:/var/lib/mysql \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  -e MYSQL_USER=dtnews \
  -e MYSQL_PASSWORD=dtnews \
  -e MYSQL_DATABASE=dtnews \
  -d \
  mariadb
```
Option 2: Use bitnami maria db image (with replication)

```
docker run --name dtnews-db-master \
  -v dtnews_data:/var/lib/mysql \
  -p 3306:3306 \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  -e MARIADB_REPLICATION_MODE=master \
  -e MARIADB_REPLICATION_USER=dtnews_repl \
  -e MARIADB_REPLICATION_PASSWORD=my-secret-pw \
  -e MARIADB_USER=dtnews \
  -e MARIADB_PASSWORD=my-secret-pw \
  -e MARIADB_DATABASE=dtnews \
  -d \
  bitnami/mariadb:10.2

docker run --name dtnews-db-slave \
  -e MARIADB_REPLICATION_MODE=slave \
  -e MARIADB_REPLICATION_USER=dtnews_repl \
  -e MARIADB_REPLICATION_PASSWORD=my-secret-pw \
  -e MARIADB_MASTER_HOST=dtnews-db-master \
  -e MARIADB_MASTER_ROOT_PASSWORD=my-secret-pw \
  -d \
  bitnami/mariadb:10.2
```

2. Run app

```
docker run \
  -p 3000:3000 \
  -e MARIADB_HOST=dtnews-db-master \
  -e MARIADB_USER=dtnews \
  -e MARIADB_PASSWORD=my-secret-pw \
  -d \
  deeptechid/dtnews:0.1.0
```

### Using docker-compose

docker-compose -f docker-compose.yml up -d

## Environment Variables

You may also set these environment variables

```
MARIADB_HOST
MARIADB_USER
MARIADB_PASSWORD
DTNEWS_HOSTNAME
DTNEWS_SITE_NAME
DTNEWS_DATABASE
RAILS_ENV
SECRET_KEY
RAILS_MAX_THREADS
SMTP_HOST
SMTP_USERNAME
SMTP_PASSWORD
```

## Submodule

dtnews repository was added in this repository as submodule with `git submodule add` command. To
update the repo, you can execute `git submodule update --init --recursive`.
