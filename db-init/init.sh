#!/bin/bash

echo "####################"
echo "Creating database..."
echo "####################"

echo "Configuring pg_hba.conf"
echo "host replication $POSTGRES_DB samenet md5" >> "$PGDATA/pg_hba.conf"

echo "Configuring postgresql.conf"
cat >> ${PGDATA}/postgresql.conf << EOF
wal_level = logical
max_wal_senders = 8
archive_mode = on
archive_command = 'cd .'
EOF

echo "Creating a replication user"
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" << EOSQL
CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
EOSQL

