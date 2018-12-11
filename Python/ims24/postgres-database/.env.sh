#!/usr/bin/env bash

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

"${psql[@]}" --dbname="dwh" <<-EOSQL
    CREATE SCHEMA postgis;
    UPDATE pg_extension SET extrelocatable = TRUE WHERE extname = 'postgis';
    ALTER EXTENSION postgis SET SCHEMA postgis;
    ALTER EXTENSION postgis UPDATE TO "2.5.0next";
    ALTER EXTENSION postgis UPDATE TO "2.5.0";
EOSQL
