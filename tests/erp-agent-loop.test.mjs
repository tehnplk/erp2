import test from 'node:test';
import assert from 'node:assert/strict';
import { registerHooks } from 'node:module';

// Next resolves extensionless relative imports between src/lib modules; Node's type stripping does not.
registerHooks({
  resolve(specifier, context, nextResolve) {
    if (specifier.startsWith('.') && context.parentURL?.endsWith('.ts') && !/\.[cm]?[jt]s$/.test(specifier)) {
      return nextResolve(`${specifier}.ts`, context);
    }
    return nextResolve(specifier, context);
  },
});

const { answerErpQuestion, ErpAgentError, getErpAgentErrorResponse } = await import(
  '../src/lib/erp-agent-loop.ts'
);

let nextCallId = 0;
const call = (name, args) => ({
  id: `call_${(nextCallId += 1)}`,
  type: 'function',
  function: { name, arguments: typeof args === 'string' ? args : JSON.stringify(args) },
});
const step = (...toolCalls) => ({ role: 'assistant', content: null, tool_calls: toolCalls });

const inspect = (table = 'department') => call('inspect_erp_table', { table_name: table });
const probe = (sql = 'SELECT id FROM department') => call('query_erp_database', { sql, phase: 'probe' });
const answerQuery = (sql = 'SELECT name, total FROM department') =>
  call('query_erp_database', { sql, phase: 'answer' });
const present = (answer, chart) => call('present_erp_answer', chart ? { answer, chart } : { answer });

const scriptedModel = (steps) => {
  const requests = [];
  const model = async ({ messages }) => {
    requests.push(messages.slice());
    return typeof steps === 'function' ? steps(requests.length) : steps[requests.length - 1];
  };
  return { model, requests };
};

const fakeDatabase = (rowsForSql = () => [{ name: 'Pharmacy', total: 3 }]) => {
  const queries = [];
  return {
    queries,
    getAccessibleSchema: async () => 'Accessible public tables:\ndepartment',
    inspectErpTable: async (tableName) => `Table ${tableName}: id, name, total`,
    queryErpDatabase: async (sql, phase) => {
      queries.push({ sql, phase });
      const rows = rowsForSql(sql);
      return { sql: `${sql} LIMIT 100`, rows, output: JSON.stringify(rows) };
    },
  };
};

const toolReply = (requests, toolCall) =>
  requests.flat().find((message) => message.role === 'tool' && message.tool_call_id === toolCall.id)?.content;

const run = (model, database) => answerErpQuestion({ question: 'How many?', history: [], model, database });

test('inspect, probe, answer query and present returns the answer with the answer-phase SQL', async () => {
  const database = fakeDatabase();
  const { model } = scriptedModel([
    step(inspect()),
    step(probe()),
    step(answerQuery()),
    step(present('Pharmacy has 3.')),
  ]);

  const result = await run(model, database);

  assert.deepEqual(result, {
    answer: 'Pharmacy has 3.',
    sql: 'SELECT name, total FROM department LIMIT 100',
    chart: undefined,
  });
  assert.deepEqual(
    database.queries.map((query) => query.phase),
    ['probe', 'answer']
  );
});

test('a query before any schema inspection is refused without touching the database', async () => {
  const database = fakeDatabase();
  const earlyProbe = probe();
  const { model, requests } = scriptedModel([step(earlyProbe), step(present('No data needed.'))]);

  const result = await run(model, database);

  assert.equal(toolReply(requests, earlyProbe), JSON.stringify({ error: 'Inspect relevant tables before running SQL.' }));
  assert.deepEqual(database.queries, []);
  assert.equal(result.answer, 'No data needed.');
});

test('an answer-phase query before a probe is refused without touching the database', async () => {
  const database = fakeDatabase();
  const earlyAnswer = answerQuery();
  const { model, requests } = scriptedModel([step(inspect()), step(earlyAnswer), step(present('Nothing yet.'))]);

  await run(model, database);

  assert.equal(
    toolReply(requests, earlyAnswer),
    JSON.stringify({ error: 'Run a probe query before the final answer query.' })
  );
  assert.deepEqual(database.queries, []);
});

test('presenting after a probe but before an answer query is refused until the answer query runs', async () => {
  const database = fakeDatabase();
  const earlyPresent = present('Too early.');
  const { model, requests } = scriptedModel([
    step(inspect()),
    step(probe()),
    step(earlyPresent),
    step(answerQuery()),
    step(present('Pharmacy has 3.')),
  ]);

  const result = await run(model, database);

  assert.equal(
    toolReply(requests, earlyPresent),
    JSON.stringify({ error: 'Run an answer query before presenting the final ERP answer.' })
  );
  assert.equal(result.answer, 'Pharmacy has 3.');
});

test('more than four tool calls in one step fails the request with a 500', async () => {
  const { model } = scriptedModel([step(inspect(), inspect(), inspect(), inspect(), inspect())]);

  const error = await run(model, fakeDatabase()).catch((caught) => caught);

  assert.equal(error.message, 'DeepSeek requested too many tool calls at once.');
  assert.deepEqual(getErpAgentErrorResponse(error), { status: 500, message: 'ERP agent request failed.' });
});

test('a seventh database query fails the request with a 422 after six ran', async () => {
  const database = fakeDatabase();
  const { model } = scriptedModel([
    step(inspect()),
    step(probe(), probe(), probe(), probe()),
    step(probe(), probe(), probe()),
  ]);

  const error = await run(model, database).catch((caught) => caught);

  assert.ok(error instanceof ErpAgentError);
  assert.equal(database.queries.length, 6);
  assert.deepEqual(getErpAgentErrorResponse(error), {
    status: 422,
    message: 'ERP agent needed too many database queries. Please simplify the question or try again.',
  });
});

test('a fifth schema inspection fails the request with a 500', async () => {
  const { model } = scriptedModel([step(inspect(), inspect(), inspect(), inspect()), step(inspect())]);

  const error = await run(model, fakeDatabase()).catch((caught) => caught);

  assert.equal(error.message, 'DeepSeek requested too many schema inspections.');
  assert.deepEqual(getErpAgentErrorResponse(error), { status: 500, message: 'ERP agent request failed.' });
});

test('ten tool steps without an answer fail the request with a 500', async () => {
  const { model, requests } = scriptedModel((callNumber) => step(callNumber === 1 ? inspect() : answerQuery()));

  const error = await run(model, fakeDatabase()).catch((caught) => caught);

  assert.equal(error.message, 'DeepSeek did not produce a final answer.');
  assert.equal(requests.length, 10);
  assert.deepEqual(getErpAgentErrorResponse(error), { status: 500, message: 'ERP agent request failed.' });
});

const monthlyChart = {
  type: 'bar',
  title: 'Monthly totals',
  xKey: 'month',
  series: [{ key: 'total', label: 'Total' }],
};

test('the chart is built from the latest answer result that fits it', async () => {
  const database = fakeDatabase((sql) =>
    sql.includes('2024') ? [{ month: 'Jan', total: 1 }] : [{ month: 'Feb', total: 9 }]
  );
  const { model } = scriptedModel([
    step(inspect()),
    step(probe()),
    step(answerQuery('SELECT month, total FROM sales_2024')),
    step(answerQuery('SELECT month, total FROM sales_2025')),
    step(present('Totals by month.', monthlyChart)),
  ]);

  const result = await run(model, database);

  assert.deepEqual(result.chart?.data, [{ month: 'Feb', total: 9 }]);
  assert.equal(result.sql, 'SELECT month, total FROM sales_2025 LIMIT 100');
});

test('the chart falls back to an earlier answer result and reports that SQL', async () => {
  const database = fakeDatabase((sql) =>
    sql.includes('sales') ? [{ month: 'Jan', total: 1 }] : [{ name: 'Pharmacy', count: 2 }]
  );
  const { model } = scriptedModel([
    step(inspect()),
    step(probe()),
    step(answerQuery('SELECT month, total FROM sales')),
    step(answerQuery('SELECT name, count FROM department')),
    step(present('Totals by month.', monthlyChart)),
  ]);

  const result = await run(model, database);

  assert.deepEqual(result.chart?.data, [{ month: 'Jan', total: 1 }]);
  assert.equal(result.sql, 'SELECT month, total FROM sales LIMIT 100');
});

test('a query without a phase fails the request with a 400 naming the problem', async () => {
  const { model } = scriptedModel([step(inspect()), step(call('query_erp_database', { sql: 'SELECT 1' }))]);

  const error = await run(model, fakeDatabase()).catch((caught) => caught);

  assert.deepEqual(getErpAgentErrorResponse(error), {
    status: 400,
    message: 'The database tool requires a probe or answer phase.',
  });
});

test('malformed tool arguments from the model fail the request with a 500', async () => {
  const { model } = scriptedModel([step(call('inspect_erp_table', '{not json'))]);

  const error = await run(model, fakeDatabase()).catch((caught) => caught);

  assert.deepEqual(getErpAgentErrorResponse(error), { status: 500, message: 'ERP agent request failed.' });
});

test('a malformed client request body maps to the invalid JSON response', async () => {
  const error = await new Request('http://localhost/api/agent/chat', { method: 'POST', body: '{not json' })
    .json()
    .catch((caught) => caught);

  assert.deepEqual(getErpAgentErrorResponse(error), { status: 400, message: 'Invalid JSON request.' });
});

test('a missing model configuration maps to 503', () => {
  assert.deepEqual(
    getErpAgentErrorResponse(new ErpAgentError('not-configured', 'DEEPSEEK_API_KEY is not configured.')),
    { status: 503, message: 'ERP agent is not configured.' }
  );
});
