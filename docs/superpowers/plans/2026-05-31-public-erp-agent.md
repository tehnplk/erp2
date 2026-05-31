# Public ERP Database Agent Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a public `/agent` page that uses DeepSeek through the OpenAI Node SDK and safely queries ERP data through a direct PostgreSQL tool.

**Architecture:** Keep tool calling, SQL validation, execution, and summarization server-side. Put the SQL validator and read-only PostgreSQL runner in focused libraries, expose one public API route with Redis rate limiting, and keep the page as a thin client.

**Tech Stack:** Next.js, TypeScript, OpenAI Node SDK, DeepSeek OpenAI-compatible API, Redis, PostgreSQL

---

### Task 1: Guard SQL execution

**Files:**
- Create: `tests/erp-agent.test.mjs`
- Create: `src/lib/erp-agent.ts`

- [ ] Add tests for SQL extraction, allowed read-only queries, blocked tables, blocked mutations, blocked comments, multiple statements, and automatic row limits.
- [ ] Run the focused test file and confirm it fails because `src/lib/erp-agent.ts` does not exist.
- [ ] Implement the SQL guard and the direct PostgreSQL runner.
- [ ] Run the focused tests and confirm they pass.

### Task 2: Add public agent API

**Files:**
- Create: `src/app/api/agent/chat/route.ts`
- Modify: `src/lib/redis.ts`

- [ ] Add a Redis-backed IP limiter for 10 requests per hour.
- [ ] Add DeepSeek client configuration with `DEEPSEEK_API_KEY`, `DEEPSEEK_BASE_URL`, and `DEEPSEEK_MODEL`.
- [ ] Give DeepSeek a `query_erp_database` function tool, validate and execute tool SQL, and return `{ answer, sql }`.
- [ ] Return clear status codes for invalid input, blocked SQL, exhausted rate limits, missing configuration, and upstream failures.

### Task 3: Add public chat UI

**Files:**
- Create: `src/app/agent/page.tsx`

- [ ] Add the `/agent` chat page with question input, answer cards, loading state, error state, and visible generated SQL.
- [ ] Keep a short client-side history for follow-up questions.

### Task 4: Verify

**Files:**
- Modify: `package.json`
- Modify: `package-lock.json`

- [ ] Install `openai`.
- [ ] Run `node --test tests/erp-agent.test.mjs`.
- [ ] Run `npm run lint`.
- [ ] Run `npm run build`.
- [ ] Open `/agent` locally with `playwright-cli show` and verify the public page renders.
