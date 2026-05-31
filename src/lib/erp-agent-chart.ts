const MAX_CHART_ROWS = 50;
const MAX_CHART_SERIES = 4;
const MAX_TITLE_LENGTH = 120;
const MAX_LABEL_LENGTH = 80;
const safeKeyPattern = /^[a-z_][a-z0-9_]*$/i;

export const agentChartTypes = ['bar', 'line', 'area', 'pie', 'scatter', 'radar'] as const;

export type AgentChartType = (typeof agentChartTypes)[number];

export type AgentChartSeries = {
  key: string;
  label: string;
};

export type AgentChartDatum = Record<string, string | number>;

export type AgentChart = {
  type: AgentChartType;
  title: string;
  xKey: string;
  series: AgentChartSeries[];
  data: AgentChartDatum[];
};

const isRecord = (value: unknown): value is Record<string, unknown> =>
  typeof value === 'object' && value !== null && !Array.isArray(value);

const isChartType = (value: unknown): value is AgentChartType =>
  typeof value === 'string' && agentChartTypes.includes(value as AgentChartType);

const isSafeKey = (value: unknown): value is string =>
  typeof value === 'string' && safeKeyPattern.test(value);

const toNumericValue = (value: unknown) => {
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  if (typeof value !== 'string' || value.trim() === '') return undefined;

  const parsedValue = Number(value);
  return Number.isFinite(parsedValue) ? parsedValue : undefined;
};

export const buildAgentChart = (
  value: unknown,
  sourceRows: Record<string, unknown>[]
): AgentChart | undefined => {
  if (!isRecord(value)) return undefined;
  if (!isChartType(value.type)) return undefined;
  if (typeof value.title !== 'string' || !value.title.trim() || value.title.length > MAX_TITLE_LENGTH) {
    return undefined;
  }
  if (!isSafeKey(value.xKey)) return undefined;
  if (!Array.isArray(value.series) || value.series.length === 0 || value.series.length > MAX_CHART_SERIES) {
    return undefined;
  }

  const series = value.series.flatMap((item) => {
    if (!isRecord(item) || !isSafeKey(item.key)) return [];
    if (typeof item.label !== 'string' || !item.label.trim() || item.label.length > MAX_LABEL_LENGTH) {
      return [];
    }

    return [{ key: item.key, label: item.label.trim() }];
  });

  if (series.length !== value.series.length) return undefined;

  const data = sourceRows.slice(0, MAX_CHART_ROWS).flatMap((row) => {
    const xValue = row[value.xKey as string];
    if (typeof xValue !== 'string' && typeof xValue !== 'number') return [];

    const chartRow: AgentChartDatum = { [value.xKey as string]: xValue };
    for (const item of series) {
      const numericValue = toNumericValue(row[item.key]);
      if (numericValue === undefined) return [];
      chartRow[item.key] = numericValue;
    }

    return [chartRow];
  });

  if (data.length === 0 || data.length !== Math.min(sourceRows.length, MAX_CHART_ROWS)) {
    return undefined;
  }

  return {
    type: value.type,
    title: value.title.trim(),
    xKey: value.xKey,
    series,
    data,
  };
};
