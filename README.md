# Lexicon::Cli

This repository provides a CLI to download/upload/load/enable compiled lexicon packages into a Postgres (PostGIS) database.

Assuming you have .env in the root of your project with information concerning the target database where you want to load.

## setup

install ruby > 2.6.6

`sudo apt install ruby`

clone repo on your server or on your local machine

## in lexicon-cli/.env
```
# Database server configuration
PRODUCTION_DATABASE_USER=<<YOUR DB USER>>
PRODUCTION_DATABASE_PASSWORD=<<YOUR DB PASSWORD>>
PRODUCTION_DATABASE_HOST=<<YOUR DB HOST>>
PRODUCTION_DATABASE_PORT=<<YOUR DB PORT>>
PRODUCTION_DATABASE_NAME=<<YOUR DB NAME>>
```

Then you can follow the 3 steps :

VERSION could be '6.0.0-ekyviti' for example

## LOCAL MODE from lexicon-cli root folder

`bin/lexicon remote download VERSION`

`bin/lexicon production load VERSION --no-validate`

`bin/lexicon production enable VERSION`

## DOCKER MODE from host

`docker compose up -d`

`docker compose exec lexicon_cli bin/lexicon remote download <VERSION>`

`docker compose exec lexicon_cli bin/lexicon production load <VERSION> --no-validate`

`docker compose exec lexicon_cli bin/lexicon production enable <VERSION>`


