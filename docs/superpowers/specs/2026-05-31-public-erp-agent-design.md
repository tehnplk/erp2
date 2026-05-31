# Public ERP Database Agent Design

## Summary

Add a public `/agent` page that answers ERP database questions using DeepSeek through the official OpenAI Node SDK. DeepSeek may call a server-side read-only PostgreSQL query tool, display the validated SQL, and return a natural-language answer.

## Security Boundary

- Public access is allowed without login.
- Rate limit requests to 10 per IP per hour using Redis.
- Allow one `SELECT` statement or one `WITH ... SELECT` statement only.
- Reject SQL comments, multiple statements, mutation keywords, and administrative commands.
- Block all `auth` schema access.
- Block `public.users` and `public.user_role`.
- Append `LIMIT 100` when the generated query has no limit.
- Execute SQL server-side through the existing PostgreSQL pool.
- Start each tool query inside a read-only transaction with a 10-second statement timeout.
- Return the final answer and generated SQL only. Do not return raw rows to the browser.

## LLM Flow

1. Receive a user question and short chat history.
2. Give DeepSeek a `query_erp_database` function tool.
3. Validate the tool SQL server-side.
4. Execute the validated SQL directly through PostgreSQL.
5. Return structured rows to DeepSeek so it can answer the user.
6. Return `{ answer, sql }`.

## Configuration

- `DEEPSEEK_API_KEY`
- `DEEPSEEK_BASE_URL`, default `https://api.deepseek.com`
- `DEEPSEEK_MODEL`, default `deepseek-chat`
- Existing DB configuration from `DATABASE_URL`
- Existing Redis configuration from `REDIS_URL`

## UI

The `/agent` page provides:

- A public ERP database chat interface
- A short safety notice
- Chat history kept in browser state
- Generated SQL shown under each assistant answer
- Loading and error states

## Production Note

A dedicated PostgreSQL read-only account is recommended for `DATABASE_URL` in production. The app-level SQL validator and read-only transaction remain required even when the DB user is read-only.
