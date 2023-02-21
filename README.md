# USERS MASTER DB

## Build the image

``` bash
docker build -t kennycallado/uv_dev-users_master_db-pg:13-alpine .
```

## Run the image

Multi line:
``` bash
docker run --rm --name users_master_db \
  -p 5432:5432 \
  -e POSTGRES_DB=master \
  -e POSTGRES_USER=master \
  -e POSTGRES_PASSWORD=master \
  kennycallado/uv_dev-users_master_db-pg:13-alpine
```

Single line:
``` bash
docker run --rm --name users_master_db -p 5432:5432 -e POSTGRES_DB=master -e POSTGRES_USER=master -e POSTGRES_PASSWORD=master kennycallado/uv_dev-users_master_db-pg:13-alpine
```

## Compose example

``` yaml
version: "3.1"

services:
  master_db:
    image: kennycallado/uv_dev-users_master_db-pg:13-alpine
    environment:
      POSTGRES_DB: master
      POSTGRES_USER: master
      POSTGRES_PASSWORD: master
      PG_REP_USER: support_user
      PG_REP_PASSWORD: support_password
    networks:
      default:   
        aliases:
          - pg_cluster 

  database:
    image: postgres:13-alpine
    environment:
      POSTGRES_DB: questions
      POSTGRES_USER: questions
      POSTGRES_PASSWORD: questions
      PG_REP_USER: support_user
      PG_REP_PASSWORD: support_password
    ports:
      - "5432:5432"
    expose:
      - "5432:5432"

    networks:   
      default:   
        aliases:    
          - pg_cluster
```
