# erp database

## Related Skills

- Docker Expert
- psql (PostgreSQL client)

## Docker Container

- container: postgres
- db: erp2
- user : admin
- password : 112233

## Data Retrieval

- You have to use psql command within docker to execute.
- Example:

  ```bash
  docker exec -it postgres psql -U admin -d erp2 "SELECT * FROM public.usage_plan;"
  ```

## Tables

- see [tables.md](tables.md)
