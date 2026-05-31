# Agent Conversation Charts Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Render safe, responsive charts inside `/agent` assistant messages only when the user explicitly requests a chart.

**Architecture:** DeepSeek submits a declarative chart selection through a `present_erp_answer` function tool after querying ERP data. The API validates chart metadata and derives all rendered chart rows from the same database query result. A focused client component maps approved chart identifiers to fixed Recharts templates.

**Tech Stack:** Next.js App Router, TypeScript, OpenAI-compatible DeepSeek tool calls, PostgreSQL, Recharts, Node test runner, Playwright CLI

---

### Task 1: Chart Specification Validation

**Files:**
- Create: `src/lib/erp-agent-chart.ts`
- Create: `tests/erp-agent-chart.test.mjs`

- [ ] Add failing tests for valid chart derivation, unsupported chart types, missing numeric series, and row limits.
- [ ] Run `node --test tests/erp-agent-chart.test.mjs` and confirm failure because the module does not exist.
- [ ] Implement chart metadata validation and derive safe rows from database output.
- [ ] Re-run `node --test tests/erp-agent-chart.test.mjs` and confirm all chart validation tests pass.

### Task 2: Structured Final Answer Tool

**Files:**
- Modify: `src/lib/erp-agent.ts`
- Modify: `src/app/api/agent/chat/route.ts`

- [ ] Preserve structured database rows alongside the serialized tool output.
- [ ] Add a `present_erp_answer` function tool with `answer` and optional chart metadata.
- [ ] Update the system prompt so charts are offered only for explicit chart requests and use the same query result.
- [ ] Validate chart metadata against the latest database rows and return `{ answer, sql, chart }`.

### Task 3: Conversation Chart Renderer

**Files:**
- Create: `src/app/agent/AgentChart.tsx`
- Modify: `src/app/agent/page.tsx`

- [ ] Add the chart payload to assistant message state.
- [ ] Map `bar`, `line`, `area`, `pie`, `scatter`, and `radar` identifiers to fixed responsive Recharts templates.
- [ ] Render the chart card below assistant markdown and above generated SQL.
- [ ] Keep unsupported or absent charts invisible.

### Task 4: Verification

**Files:**
- Verify: `tests/erp-agent-chart.test.mjs`
- Verify: `tests/erp-agent.test.mjs`

- [ ] Run agent unit tests.
- [ ] Run `npm run lint`.
- [ ] Run `npm run build`.
- [ ] Restart the dev server on port `3000`.
- [ ] Run `playwright-cli show`.
- [ ] Ask for a chart in `/agent` and confirm a chart appears in the assistant message.
- [ ] Ask a normal ERP question and confirm no chart appears.
