#!/bin/bash

set -e
set -u

function create_user_and_database() {
	local database=$(echo $1 | cut -d':' -f1)
	local owner=$(echo $1 | cut -d':' -f2)

	if [ -z "$owner" ]; then
		owner="$POSTGRES_USER"
	else
		EXISTING_USER=$(psql -U "$POSTGRES_USER" -d postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$owner'")
		if [ "$EXISTING_USER" != "1" ]; then
			echo "Creating user '$owner'"
			psql -U "$POSTGRES_USER" -d postgres -c "CREATE USER $owner;"
		fi
	fi

	echo "Creating user and database '$database':'$owner'"

	EXISTING_DB=$(psql -U "$POSTGRES_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$database'")
	if [ "$EXISTING_DB" != "1" ]; then
		echo "Creating database '$database'"
		psql -U "$POSTGRES_USER" -d postgres <<-EOSQL
			CREATE DATABASE "$database";
			GRANT ALL PRIVILEGES ON DATABASE "$database" TO "$owner";
		EOSQL
	fi
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
		create_user_and_database $db
	done
fi