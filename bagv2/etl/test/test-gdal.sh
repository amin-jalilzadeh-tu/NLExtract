#!/bin/bash
PG="PG:dbname=DATALES_20240512 active_schema=public host=localhost user=postgres password=865990289"
# ogr2ogr -f PostgreSQL "${PG}" data/lv/
# ogr2ogr -overwrite -t_srs EPSG:4326 -f PostgreSQL "${PG}" /vsizip/data/0221PND15092020.zip

ogr2ogr -overwrite -f PostgreSQL "${PG}" /vsizip/data/0221PND15092020.zip

