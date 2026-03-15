# erp database

## Docker Container

- container: supabase_db_erp
- db: postgres
- user : admin
- password : 112233

## Tables

- see [tables.md](tables.md)

## execute sql command with docker

```bash
docker exec -i supabase_db_erp psql -U postgres postgres -c "sql command"
```

## redis

- container: erp-redis
- port: 6379
