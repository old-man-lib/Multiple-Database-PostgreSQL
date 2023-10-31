# Multiple-Database-PostgreSQL
Using multiple databases with the official PostgreSQL Docker image

## Usage

### By mounting a volume

Clone the file, mount its directory as a volume into `/docker-entrypoint-initdb.d` and declare database names separated by commas in `POSTGRES_MULTIPLE_DATABASES` environment variable as follows
```docker-compose
    postgresql:
        image: postgres:latest
        volumes:
            - ./init-another-postgresql-databases.sh:/docker-entrypoint-initdb.d/init-another-postgresql-databases.sh
        environment:
            - POSTGRES_MULTIPLE_DATABASES: "db1:admin1, db2:"
            - POSTGRES_USER: admin
            - POSTGRES_PASSWORD: password
```

### Non-standard database names
If you need to use non-standard database names (hyphens, uppercase letters etc), quote them in `POSTGRES_MULTIPLE_DATABASES`:
```
    postgresql:
        ...
        environment:
            - POSTGRES_MULTIPLE_DATABASES: "main-reserv1:admin-reser1, main-reserv2:"
```
