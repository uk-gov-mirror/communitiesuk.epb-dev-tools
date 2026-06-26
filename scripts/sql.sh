#!/usr/bin/env bash

DOCKER_SERVICE_NAME=$APP

if [ "$APP" = "epb-feature-flag" ]; then
  DB_CMD='psql --username unleashed -d unleashed'
else
  DB_CMD='psql --username epb -d epb'
fi

docker compose \
exec "$DOCKER_SERVICE_NAME-db" \
bash -c "$DB_CMD"
