import test from 'node:test';
import assert from 'node:assert/strict';

import { buildAgentChart } from '../src/lib/erp-agent-chart.ts';

test('buildAgentChart derives safe chart rows from database output', () => {
  const chart = buildAgentChart(
    {
      type: 'bar',
      title: 'Inventory by department',
      xKey: 'department',
      series: [{ key: 'total', label: 'Inventory total' }],
      data: [{ department: 'Fake', total: 999999 }],
    },
    [
      { department: 'Pharmacy', total: '12' },
      { department: 'Ward', total: 7 },
    ]
  );

  assert.deepEqual(chart, {
    type: 'bar',
    title: 'Inventory by department',
    xKey: 'department',
    series: [{ key: 'total', label: 'Inventory total' }],
    data: [
      { department: 'Pharmacy', total: 12 },
      { department: 'Ward', total: 7 },
    ],
  });
});

test('buildAgentChart rejects unsupported chart types', () => {
  const chart = buildAgentChart(
    {
      type: 'custom-component',
      title: 'Unsafe chart',
      xKey: 'department',
      series: [{ key: 'total', label: 'Total' }],
    },
    [{ department: 'Pharmacy', total: 12 }]
  );

  assert.equal(chart, undefined);
});

test('buildAgentChart rejects rows without numeric series values', () => {
  const chart = buildAgentChart(
    {
      type: 'line',
      title: 'Inventory trend',
      xKey: 'month',
      series: [{ key: 'total', label: 'Total' }],
    },
    [{ month: 'January', total: 'not-a-number' }]
  );

  assert.equal(chart, undefined);
});

test('buildAgentChart limits chart rows returned to the browser', () => {
  const chart = buildAgentChart(
    {
      type: 'area',
      title: 'Monthly usage',
      xKey: 'month',
      series: [{ key: 'total', label: 'Total' }],
    },
    Array.from({ length: 75 }, (_, index) => ({
      month: `Month ${index + 1}`,
      total: index + 1,
    }))
  );

  assert.equal(chart?.data.length, 50);
});

test('buildAgentChart returns no chart when metadata is absent', () => {
  assert.equal(buildAgentChart(undefined, [{ department: 'Pharmacy', total: 12 }]), undefined);
});
