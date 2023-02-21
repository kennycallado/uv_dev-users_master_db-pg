FROM postgres:13-alpine

COPY ./db-init/init.sh /docker-entrypoint-initdb.d/01-init.sh
COPY ./db-init/init.sql /docker-entrypoint-initdb.d/02-init.sql

RUN chmod 0666 /docker-entrypoint-initdb.d/01-init.sh
